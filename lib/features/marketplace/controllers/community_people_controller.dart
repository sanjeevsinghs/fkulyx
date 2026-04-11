import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

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

  void toggleFollow(String personId) {
    if (followedPeopleIds.contains(personId)) {
      followedPeopleIds.remove(personId);
      return;
    }

    followedPeopleIds.add(personId);
  }

  void _syncFollowState(List<ForumPerson> people) {
    followedPeopleIds
      ..clear()
      ..addAll(people.where((person) => person.isFollow).map((p) => p.id));
  }
}
