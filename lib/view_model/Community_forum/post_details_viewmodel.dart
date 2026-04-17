import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/post_details_model.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class PostDetailsViewModel extends GetxController {
  final CommunityForumRepo _api = CommunityForumRepo();

  final Rxn<PostDetailsModel> postDetail = Rxn<PostDetailsModel>();
  final RxBool isLoading = false.obs;
  final RxBool isVoteLoading = false.obs;
  final RxBool isCommentSubmitting = false.obs;
  final RxBool isCommentActionLoading = false.obs;

  Future<void> getPostDetailsApi(String id) async {
    final postId = id.trim();
    if (postId.isEmpty) {
      AppSnackbar.show('Post id is required');
      return;
    }

    isLoading.value = true;

    _api
        .postDetail(postId)
        .then((response) {
          isLoading.value = false;

          if (response.success == true && response.data != null) {
            postDetail.value = response;
          } else {
            AppSnackbar.show(response.message ?? 'Failed to load post details');
            Get.back();
          }
        })
        .onError((error, stackTrace) {
          isLoading.value = false;
          AppSnackbar.show(error.toString());
          debugPrint('${error.toString()} $stackTrace');
        });
  }

  Future<void> upVotePost(String id) async {
    await _votePost(id: id, isUpVote: true);
  }

  Future<void> downVotePost(String id) async {
    await _votePost(id: id, isUpVote: false);
  }

  Future<void> _votePost({required String id, required bool isUpVote}) async {
    final postId = id.trim();
    if (postId.isEmpty) {
      AppSnackbar.show('Post id is required');
      return;
    }

    if (isVoteLoading.value) return;
    isVoteLoading.value = true;

    try {
      final response = isUpVote
          ? await _api.upVotePost(postId)
          : await _api.downVotePost(postId);

      if (response.success == true && response.data != null) {
        postDetail.value = response;
      } else {
        AppSnackbar.show(response.message ?? 'Failed to update vote');
      }
    } catch (error, stackTrace) {
      AppSnackbar.show(error.toString());
      debugPrint('${error.toString()} $stackTrace');
    } finally {
      isVoteLoading.value = false;
    }
  }

  Future<bool> submitComment({
    required String postId,
    required String content,
    String parentCommentId = '',
  }) async {
    final cleanPostId = postId.trim();
    final cleanContent = content.trim();

    if (cleanPostId.isEmpty) {
      AppSnackbar.show('Post id is required');
      return false;
    }

    if (cleanContent.isEmpty) {
      AppSnackbar.show('Please write your suggestion first');
      return false;
    }

    if (isCommentSubmitting.value) return false;

    isCommentSubmitting.value = true;

    try {
      final response = await _api.createComment(
        postId: cleanPostId,
        content: cleanContent,
        parentCommentId: parentCommentId,
      );

      final success = response['success'] == true;
      if (!success) {
        AppSnackbar.show(
          response['message']?.toString() ?? 'Failed to create comment',
        );
        return false;
      }

      await getPostDetailsApi(cleanPostId);
      AppSnackbar.show(
        response['message']?.toString() ?? 'Comment created successfully',
      );
      return true;
    } catch (error, stackTrace) {
      AppSnackbar.show(error.toString());
      debugPrint('${error.toString()} $stackTrace');
      return false;
    } finally {
      isCommentSubmitting.value = false;
    }
  }

  Future<bool> submitReply({
    required String postId,
    required String commentId,
    required String content,
  }) async {
    final cleanPostId = postId.trim();
    final cleanCommentId = commentId.trim();
    final cleanContent = content.trim();

    if (cleanPostId.isEmpty || cleanCommentId.isEmpty) {
      AppSnackbar.show('Reply target is missing');
      return false;
    }

    if (cleanContent.isEmpty) {
      AppSnackbar.show('Please write your reply first');
      return false;
    }

    if (isCommentSubmitting.value) return false;

    isCommentSubmitting.value = true;

    try {
      final response = await _api.replyToComment(
        commentId: cleanCommentId,
        content: cleanContent,
      );

      final success = response['success'] == true;
      if (!success) {
        AppSnackbar.show(
          response['message']?.toString() ?? 'Failed to create reply',
        );
        return false;
      }

      await getPostDetailsApi(cleanPostId);
      AppSnackbar.show(
        response['message']?.toString() ?? 'Reply created successfully',
      );
      return true;
    } catch (error, stackTrace) {
      AppSnackbar.show(error.toString());
      debugPrint('${error.toString()} $stackTrace');
      return false;
    } finally {
      isCommentSubmitting.value = false;
    }
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
  }) async {
    await _commentAction(postId: postId, commentId: commentId, isLike: true);
  }

  Future<void> dislikeComment({
    required String postId,
    required String commentId,
  }) async {
    await _commentAction(postId: postId, commentId: commentId, isLike: false);
  }

  Future<void> _commentAction({
    required String postId,
    required String commentId,
    required bool isLike,
  }) async {
    final cleanPostId = postId.trim();
    final cleanCommentId = commentId.trim();
    if (cleanPostId.isEmpty || cleanCommentId.isEmpty) {
      AppSnackbar.show('Comment action target is missing');
      return;
    }

    if (isCommentActionLoading.value) return;
    isCommentActionLoading.value = true;

    try {
      final response = isLike
          ? await _api.likeComment(cleanCommentId)
          : await _api.dislikeComment(cleanCommentId);

      final success = response['success'] == true;
      if (!success) {
        AppSnackbar.show(
          response['message']?.toString() ?? 'Failed to update comment',
        );
        return;
      }

      await getPostDetailsApi(cleanPostId);
    } catch (error, stackTrace) {
      AppSnackbar.show(error.toString());
      debugPrint('${error.toString()} $stackTrace');
    } finally {
      isCommentActionLoading.value = false;
    }
  }
}
