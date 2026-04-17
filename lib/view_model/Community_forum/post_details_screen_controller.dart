import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kulyx/model/community_forum/post_details_model.dart';
import 'package:kulyx/network/api_base_service.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/view_model/Community_forum/post_details_viewmodel.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class PostCommentThread {
  const PostCommentThread({required this.parent, required this.replies});

  final PostCommentItem parent;
  final List<PostCommentItem> replies;
}

class PostCommentItem {
  const PostCommentItem({
    required this.id,
    required this.username,
    required this.message,
    required this.timeLabel,
    required this.likes,
    required this.dislikes,
    this.avatarUrl,
    bool? isLiked,
    bool? isDisliked,
  }) : isLiked = isLiked ?? false,
       isDisliked = isDisliked ?? false;

  final String id;
  final String username;
  final String message;
  final String timeLabel;
  final int likes;
  final int dislikes;
  final String? avatarUrl;
  final bool isLiked;
  final bool isDisliked;
}

class PostDetailsScreenController extends GetxController {
  final PostDetailsViewModel vm = Get.find<PostDetailsViewModel>();
  final TextEditingController commentController = TextEditingController();
  final RxString commentDraft = ''.obs;
  final Rxn<PostCommentItem> replyingTo = Rxn<PostCommentItem>();
  final RxSet<String> expandedThreadIds = <String>{}.obs;
  final Map<String, dynamic> _arguments =
      (Get.arguments as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

  bool _didRequest = false;
  String _currentUserId = '';

  Data? get postData => vm.postDetail.value?.data;

  String get postId => _arguments['postId']?.toString() ?? '';

  String get title =>
      postData?.title ?? _arguments['postTitle']?.toString() ?? 'Post';

  String get content => _arguments['postContent']?.toString() ?? '';

  String get authorName {
    final author = postData?.createdBy;
    final fullName = '${author?.firstName ?? ''} ${author?.lastName ?? ''}'
        .trim();
    if (fullName.isNotEmpty) return fullName;

    return _arguments['authorName']?.toString() ?? 'Unknown author';
  }

  String get authorTitle {
    final roles = postData?.createdBy?.roles;
    if (roles != null && roles.isNotEmpty) {
      return roles.first;
    }

    return _arguments['authorTitle']?.toString() ?? '';
  }

  String get authorImage {
    final image = postData?.createdBy?.profileImage?.toString().trim();
    if (image != null && image.isNotEmpty) return image;

    return _arguments['authorImage']?.toString() ?? '';
  }

  String get postImage {
    final image = postData?.image?.trim();
    if (image != null && image.isNotEmpty) return image;

    return _arguments['postImage']?.toString() ?? '';
  }

  List<String> get tags {
    final apiTags = postData?.tags;
    if (apiTags != null && apiTags.isNotEmpty) {
      return apiTags.map((tag) => tag.toString()).toList();
    }

    final fallbackTags = _arguments['tags'];
    if (fallbackTags is List) {
      return fallbackTags.map((tag) => tag.toString()).toList();
    }

    return <String>[];
  }

  int get views => postData?.views ?? (_arguments['views'] as int? ?? 0);

  int get likes => postData?.likes ?? (_arguments['likes'] as int? ?? 0);

  int get upVotes => postData?.upVotes ?? 0;

  int get downVotes => postData?.downVotes ?? 0;

  bool get isUpVoted => postData?.isUpVote == true;

  bool get isDownVoted => postData?.isDownVote == true;

  bool get hasVoted => isUpVoted || isDownVoted;

  bool get canVote => !hasVoted && !vm.isVoteLoading.value;

  int get commentsCount =>
      postData?.commentsCount ?? (_arguments['comments'] as int? ?? 0);

  List<PostCommentThread> get commentThreads {
    final apiComments = postData?.comments ?? <Comment>[];
    if (apiComments.isEmpty) {
      return <PostCommentThread>[];
    }

    final topLevel = <Comment>[];
    final groupedReplies = <String, List<Comment>>{};

    for (final comment in apiComments) {
      final parentId = comment.parentCommentId?.id?.trim() ?? '';
      if (parentId.isEmpty) {
        topLevel.add(comment);
      } else {
        groupedReplies.putIfAbsent(parentId, () => <Comment>[]).add(comment);
      }
    }

    return topLevel.map((root) {
      final rootId = (root.id ?? '').trim();
      final replies = groupedReplies[rootId] ?? const <Comment>[];
      return PostCommentThread(
        parent: _toCommentItem(root),
        replies: replies.map(_toCommentItem).toList(),
      );
    }).toList();
  }

  String get repostedBy {
    final reposted = postData?.repostedBy;
    final name = reposted?.username?.trim() ?? '';
    if (name.isNotEmpty) return name;

    return _arguments['repostedBy']?.toString() ?? '';
  }

  String get dateLabel {
    final createdAt = postData?.createdAt;
    if (createdAt == null) return 'Unknown date';

    final localDate = createdAt.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = _monthName(localDate.month);
    final year = localDate.year;
    final hour = localDate.hour % 12 == 0 ? 12 : localDate.hour % 12;
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year $hour:$minute $period';
  }

  @override
  void onReady() {
    super.onReady();
    if (_didRequest) return;
    _didRequest = true;
    _syncUserIdFromToken();
    vm.getPostDetailsApi(postId);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void updateCommentDraft(String value) {
    commentDraft.value = value;
  }

  void clearCommentDraft() {
    commentController.clear();
    commentDraft.value = '';
  }

  void startReply(PostCommentItem item) {
    replyingTo.value = item;
    clearCommentDraft();
  }

  void cancelReply() {
    replyingTo.value = null;
    clearCommentDraft();
  }

  Future<void> submitComment() async {
    final target = replyingTo.value;
    final success = target == null
        ? await vm.submitComment(
            postId: postId,
            content: commentDraft.value,
            parentCommentId: '',
          )
        : await vm.submitReply(
            postId: postId,
            commentId: target.id,
            content: commentDraft.value,
          );

    if (success) {
      clearCommentDraft();
      cancelReply();
    }
  }

  Future<void> onCommentLikePressed(String commentId) async {
    await vm.likeComment(postId: postId, commentId: commentId);
  }

  Future<void> onCommentDislikePressed(String commentId) async {
    await vm.dislikeComment(postId: postId, commentId: commentId);
  }

  Future<void> onUpVotePressed() async {
    if (!canVote) {
      if (hasVoted) {
        AppSnackbar.show('You can vote only one time on this post');
      }
      return;
    }

    await vm.upVotePost(postId);
  }

  Future<void> onDownVotePressed() async {
    if (!canVote) {
      if (hasVoted) {
        AppSnackbar.show('You can vote only one time on this post');
      }
      return;
    }

    await vm.downVotePost(postId);
  }

  bool isThreadExpanded(String parentId) {
    return expandedThreadIds.contains(parentId);
  }

  void toggleThreadReplies(String parentId) {
    if (expandedThreadIds.contains(parentId)) {
      expandedThreadIds.remove(parentId);
    } else {
      expandedThreadIds.add(parentId);
    }
    expandedThreadIds.refresh();
  }

  PostCommentItem _toCommentItem(Comment source) {
    final first = source.userId?.firstName?.trim() ?? '';
    final last = source.userId?.lastName?.trim() ?? '';
    final fullName = '$first $last'.trim();
    final user = source.userId?.username?.trim() ?? '';

    return PostCommentItem(
      id: source.id?.trim().isNotEmpty == true
          ? source.id!.trim()
          : '${source.userId?.id ?? user}_${source.createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}',
      username: fullName.isNotEmpty
          ? fullName.replaceAll(' ', '').toLowerCase()
          : (user.isNotEmpty ? user : 'unknown'),
      message: source.content?.trim().isNotEmpty == true
          ? source.content!.trim()
          : 'No comment text',
      timeLabel: _formatCommentTime(source.createdAt),
      likes: source.likes ?? 0,
      dislikes: source.dislikes ?? 0,
      avatarUrl: _resolveCommentAvatarUrl(source),
      isLiked: _isCommentLikedByCurrentUser(source),
      isDisliked: _isCommentDislikedByCurrentUser(source),
    );
  }

  bool _isCommentLikedByCurrentUser(Comment source) {
    if (source.isLiked == true) return true;

    if (_currentUserId.isEmpty) {
      _syncUserIdFromToken();
    }

    if (_currentUserId.isEmpty) return false;

    final likedBy = source.likedBy ?? const <dynamic>[];
    return likedBy.any((item) => _extractUserId(item) == _currentUserId);
  }

  bool _isCommentDislikedByCurrentUser(Comment source) {
    if (_currentUserId.isEmpty) {
      _syncUserIdFromToken();
    }

    if (_currentUserId.isEmpty) return false;

    final dislikedBy = source.dislikedBy ?? const <dynamic>[];
    return dislikedBy.any((item) => _extractUserId(item) == _currentUserId);
  }

  String _extractUserId(dynamic raw) {
    if (raw == null) return '';

    if (raw is String) {
      return raw.trim();
    }

    if (raw is Map<String, dynamic>) {
      return (raw['_id'] ?? raw['id'] ?? raw['userId'] ?? '').toString().trim();
    }

    return raw.toString().trim();
  }

  void _syncUserIdFromToken() {
    if (_currentUserId.isNotEmpty) return;

    final token = NetworkApiServices.accessToken.isNotEmpty
        ? NetworkApiServices.accessToken
        : ApiBaseService.accessToken;
    if (token.isEmpty) return;

    final parts = token.split('.');
    if (parts.length < 2) return;

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
      _currentUserId = (payloadMap['sub'] ?? '').toString().trim();
    } catch (_) {
      // Ignore invalid token payloads and keep current user id empty.
    }
  }

  String? _resolveCommentAvatarUrl(Comment source) {
    final createdByImage = _resolveProfileImage(source.createdBy?.profileImage);
    if (createdByImage.isNotEmpty) return createdByImage;

    final updatedByImage = _resolveProfileImage(source.updatedBy?.profileImage);
    if (updatedByImage.isNotEmpty) return updatedByImage;

    final userImage = _resolveProfileImage(source.userId?.profileImage);
    if (userImage.isNotEmpty) return userImage;

    return null;
  }

  String _resolveProfileImage(dynamic imageRaw) {
    if (imageRaw == null) return '';

    if (imageRaw is String) {
      return imageRaw.trim();
    }

    if (imageRaw is Map<String, dynamic>) {
      return imageRaw['url']?.toString().trim() ?? '';
    }

    return imageRaw.toString().trim();
  }

  String _formatCommentTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';

    final localDate = dateTime.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = _monthName(localDate.month);
    final year = localDate.year;
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day $month $year $hour:$minute';
  }

  String _monthName(int month) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    if (month < 1 || month > months.length) return '';
    return months[month - 1];
  }
}
