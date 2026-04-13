import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

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
  final RxSet<String> likingPostIds = <String>{}.obs;
  final RxSet<String> followingUserIds = <String>{}.obs;

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

  Future<void> toggleLike(String postId) async {
    if (postId.trim().isEmpty || likingPostIds.contains(postId)) {
      return;
    }

    likingPostIds.add(postId);

    try {
      final response = await _apiService.postApi(
        null,
        '${ApiEndpoints.communityPosts}/$postId/like',
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected like response format');
      }

      final success = response['success'] == true;
      final message = (response['message'] ?? 'Failed to update like')
          .toString();

      if (!success) {
        throw Exception(message);
      }

      final data = response['data'] as Map<String, dynamic>?;
      final serverIsLiked = data?['isLiked'] == true;

      if (serverIsLiked) {
        likedPostIds.add(postId);
      } else {
        likedPostIds.remove(postId);
      }

      _syncPostLikeData(postId: postId, data: data);
    } catch (e) {
      AppSnackbar.show(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      likingPostIds.remove(postId);
    }
  }

  bool isFollowed(String postId) => followedPostIds.contains(postId);

  Future<void> followAuthor({
    required String postId,
    required String authorId,
  }) async {
    final cleanAuthorId = authorId.trim();
    if (postId.trim().isEmpty || cleanAuthorId.isEmpty) {
      AppSnackbar.show('Creator id not available');
      return;
    }

    if (followingUserIds.contains(cleanAuthorId)) {
      return;
    }

    followingUserIds.add(cleanAuthorId);

    try {
      final response = await _apiService.postApi(
        null,
        '${ApiEndpoints.followers}/$cleanAuthorId/follow',
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected follow response format');
      }

      final success = response['success'] == true;
      final message = (response['message'] ?? 'Follow request failed')
          .toString();

      AppSnackbar.show(message);

      if (!success) {
        return;
      }

      final data = response['data'] as Map<String, dynamic>?;
      final isFollowing = data?['isFollowing'] == true;
      _syncPostFollowData(authorId: cleanAuthorId, isFollowing: isFollowing);
    } catch (e) {
      AppSnackbar.show(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      followingUserIds.remove(cleanAuthorId);
    }
  }

  void _syncInteractionState(List<ForumPost> posts) {
    likedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isLiked).map((post) => post.id));

    followedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isFollow).map((post) => post.id));
  }

  void _syncPostLikeData({
    required String postId,
    required Map<String, dynamic>? data,
  }) {
    if (data == null) {
      return;
    }

    final index = items.indexWhere((post) => post.id == postId);
    if (index == -1) {
      return;
    }

    final current = items[index];
    final updated = current.copyWith(
      isLiked: data['isLiked'] == true,
      likes: (data['likes'] as num?)?.toInt() ?? current.likes,
    );

    items[index] = updated;
  }

  void _syncPostFollowData({
    required String authorId,
    required bool isFollowing,
  }) {
    for (var i = 0; i < items.length; i++) {
      final post = items[i];
      if (post.createdBy != authorId) {
        continue;
      }

      items[i] = post.copyWith(isFollow: isFollowing);
      if (isFollowing) {
        followedPostIds.add(post.id);
      } else {
        followedPostIds.remove(post.id);
      }
    }
  }
}
