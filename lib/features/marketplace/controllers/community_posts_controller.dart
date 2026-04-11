import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class CommunityPostsController extends GetxController {
  static const int pageSize = 10;

  final NetworkApiServices _apiService = NetworkApiServices();

  final RxList<ForumPost> items = <ForumPost>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
  final RxInt page = 1.obs;
  final RxSet<String> likedPostIds = <String>{}.obs;
  final RxSet<String> followedPostIds = <String>{}.obs;

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
      final uri = Uri.parse(ApiEndpoints.communityPosts).replace(
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
        throw Exception('Unexpected posts response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final rawItems = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load posts',
        );
      }

      final posts = rawItems
          .whereType<Map<String, dynamic>>()
          .map(ForumPost.fromJson)
          .toList();

      if (reset) {
        items.assignAll(posts);
      } else {
        items.addAll(posts);
      }

      hasMore.value = posts.length >= limit;
      page.value = pageNumber;
      _syncInteractionState(items);
    } catch (e) {
      error.value = e.toString();
      if (reset) {
        items.clear();
        likedPostIds.clear();
        followedPostIds.clear();
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

  List<ForumPost> filtered(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return items;
    }

    return items.where((post) {
      return post.title.toLowerCase().contains(normalized) ||
          post.authorName.toLowerCase().contains(normalized) ||
          post.safeTags.any((tag) => tag.toLowerCase().contains(normalized));
    }).toList();
  }

  bool isLiked(String postId) => likedPostIds.contains(postId);

  void toggleLike(String postId) {
    if (likedPostIds.contains(postId)) {
      likedPostIds.remove(postId);
      return;
    }

    likedPostIds.add(postId);
  }

  bool isFollowed(String postId) => followedPostIds.contains(postId);

  void toggleFollow(String postId) {
    if (followedPostIds.contains(postId)) {
      followedPostIds.remove(postId);
      return;
    }

    followedPostIds.add(postId);
  }

  void _syncInteractionState(List<ForumPost> posts) {
    likedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isLiked).map((post) => post.id));

    followedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isFollow).map((post) => post.id));
  }
}
