import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class CommunityGroupsController extends GetxController {
  static const int pageSize = 10;

  final NetworkApiServices _apiService = NetworkApiServices();

  final RxList<ForumGroup> items = <ForumGroup>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
  final RxInt page = 1.obs;

  Future<void> fetch({
    int pageNumber = 1,
    int limit = pageSize,
    bool includeInactive = false,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
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
      final uri = Uri.parse(ApiEndpoints.communityGroups).replace(
        queryParameters: <String, String>{
          'page': '$pageNumber',
          'limit': '$limit',
          'includeInactive': '$includeInactive',
          'sortBy': sortBy,
          'sortOrder': sortOrder,
        },
      );

      final response = await _apiService.getApi(uri.toString());
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected groups response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final rawItems = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load groups',
        );
      }

      final groups = rawItems
          .whereType<Map<String, dynamic>>()
          .map(ForumGroup.fromJson)
          .toList();

      if (reset) {
        items.assignAll(groups);
      } else {
        items.addAll(groups);
      }

      hasMore.value = groups.length >= limit;
      page.value = pageNumber;
    } catch (e) {
      error.value = e.toString();
      if (reset) {
        items.clear();
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

  List<ForumGroup> filtered(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return items;
    }

    return items.where((group) {
      return group.name.toLowerCase().contains(normalized) ||
          group.groupType.toLowerCase().contains(normalized) ||
          group.location.toLowerCase().contains(normalized);
    }).toList();
  }
}
