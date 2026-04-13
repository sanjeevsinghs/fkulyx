import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class CommunityPeopleController extends GetxController {
  static const int pageSize = 10;

  final NetworkApiServices _apiService = NetworkApiServices();

  final RxList<ForumPerson> items = <ForumPerson>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
  final RxInt page = 1.obs;
  final RxSet<String> followedPeopleIds = <String>{}.obs;
  final RxSet<String> followActionInProgressIds = <String>{}.obs;

  Future<void> fetch({
    int pageNumber = 1,
    int limit = pageSize,
    bool reset = false,
  }) async {
    if (isLoading.value || isLoadingMore.value) {
      return;
    }

    if (!reset && !hasMore.value) {
      return;
    }

    if (reset) {
      page.value = 1;
      hasMore.value = true;
      isLoading.value = true;
      error.value = '';
    } else {
      isLoadingMore.value = true;
    }

    try {
      final uri = Uri.parse(ApiEndpoints.usersLimited).replace(
        queryParameters: <String, String>{
          'limit': '$limit',
          'page': '$pageNumber',
        },
      );

      final response = await _apiService.getApi(uri.toString());
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected users response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final rawItems = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load users',
        );
      }

      final people = rawItems
          .whereType<Map<String, dynamic>>()
          .map(ForumPerson.fromJson)
          .toList();

      if (reset) {
        items.assignAll(people);
      } else {
        items.addAll(people);
      }

      hasMore.value = people.length >= limit;
      page.value = pageNumber;
      _syncFollowState(items);
    } catch (e) {
      error.value = e.toString();
      if (reset) {
        items.clear();
        followedPeopleIds.clear();
      }
    } finally {
      if (reset) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    await fetch(pageNumber: page.value + 1, reset: false);
  }

  Future<void> refreshData() async {
    await fetch(reset: true);
  }

  List<ForumPerson> filtered(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return items;
    }

    return items.where((person) {
      return person.name.toLowerCase().contains(normalized) ||
          person.role.toLowerCase().contains(normalized) ||
          person.tags.any((tag) => tag.toLowerCase().contains(normalized));
    }).toList();
  }

  bool isFollowed(String personId) => followedPeopleIds.contains(personId);

  Future<void> followOrUnfollow(String personId) async {
    final cleanPersonId = personId.trim();
    if (cleanPersonId.isEmpty) {
      AppSnackbar.show('Person id not available');
      return;
    }

    if (followActionInProgressIds.contains(cleanPersonId)) {
      return;
    }

    followActionInProgressIds.add(cleanPersonId);
    try {
      final alreadyFollowing = isFollowed(cleanPersonId);
      final action = alreadyFollowing ? 'unfollow' : 'follow';
      final url = '${ApiEndpoints.followers}/$cleanPersonId/$action';

      final response = await _apiService.postApi(null, url);
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected follow response format');
      }

      final success = response['success'] == true;
      final message = (response['message'] ?? 'Failed to update follow status')
          .toString();
      AppSnackbar.show(message);

      if (!success) {
        return;
      }

      final data = response['data'] as Map<String, dynamic>?;
      final serverIsFollowing = data?['isFollowing'] == true;

      if (serverIsFollowing) {
        followedPeopleIds.add(cleanPersonId);
      } else {
        followedPeopleIds.remove(cleanPersonId);
      }

      _syncSinglePersonFollowState(
        personId: cleanPersonId,
        isFollowing: serverIsFollowing,
      );
    } catch (e) {
      AppSnackbar.show(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      followActionInProgressIds.remove(cleanPersonId);
    }
  }

  void _syncFollowState(List<ForumPerson> people) {
    followedPeopleIds
      ..clear()
      ..addAll(people.where((person) => person.isFollow).map((p) => p.id));
  }

  void _syncSinglePersonFollowState({
    required String personId,
    required bool isFollowing,
  }) {
    final index = items.indexWhere((person) => person.id == personId);
    if (index == -1) {
      return;
    }

    items[index] = items[index].copyWith(isFollow: isFollowing);
  }
}
