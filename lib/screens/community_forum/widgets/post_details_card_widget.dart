import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/post_details_screen_controller.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/expandable_text/expandable_content_text.dart';

class PostDetailsCard extends StatelessWidget {
  final String title;
  final String content;
  final String authorName;
  final String authorTitle;
  final String authorImage;
  final String postImage;
  final String repostedBy;
  final String dateLabel;
  final List<String> tags;
  final int views;
  final int likes;
  final int comments;

  const PostDetailsCard({
    super.key,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
    required this.postImage,
    required this.repostedBy,
    required this.dateLabel,
    required this.tags,
    required this.views,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    final hasAuthorImage = authorImage.trim().isNotEmpty;
    final hasPostImage = postImage.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (repostedBy.trim().isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF23B36B),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.repeat_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$repostedBy reposted',
                  style: TextStyle(
                    color: CustomColors.textGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: hasAuthorImage
                    ? NetworkImage(authorImage)
                    : const AssetImage('assets/icons/person.png')
                          as ImageProvider,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$authorName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Forum',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF242424),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.textGray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Forum',
              fontWeight: FontWeight.w400,
              color: Color(0xFF111111),
            ),
          ),
          if (content.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            ExpandableContentText(text: content, wordLimit: 30),
          ],
          if (hasPostImage) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                postImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E5DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: CustomColors.cardGray,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('$views Views'),
              _buildStatItem('$likes Likes'),
              _buildStatItem('$comments comments'),
            ],
          ),
          const SizedBox(height: 12),
          const _VoteButton(),
          const SizedBox(height: 34),
          const _CommentsSection(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 12, color: CustomColors.textGray),
    );
  }
}

class _VoteButton extends GetView<PostDetailsScreenController> {
  const _VoteButton();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final upActive = controller.isUpVoted;
      final downActive = controller.isDownVoted;
      final canVote = controller.canVote;
      final isVoteLoading = controller.vm.isVoteLoading.value;
      const disabledColor = Color(0xFFB8B8B8);

      final upColor = isVoteLoading
          ? disabledColor
          : upActive
          ? const Color(0xFF23B36B)
          : canVote
          ? const Color(0xFF3A3A3A)
          : disabledColor;
      final downColor = isVoteLoading
          ? disabledColor
          : downActive
          ? const Color(0xFFE53935)
          : canVote
          ? const Color(0xFF3A3A3A)
          : disabledColor;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            ignoring: !canVote || isVoteLoading,
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: controller.onUpVotePressed,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(100, 36),
                    side: BorderSide(color: upColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: upColor,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                  label: Text('Up Vote (${controller.upVotes})'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: controller.onDownVotePressed,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(100, 36),
                    side: BorderSide(color: downColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: downColor,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  icon: const Icon(Icons.arrow_downward_rounded, size: 14),
                  label: Text('Down Vote (${controller.downVotes})'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _CommentsSection extends GetView<PostDetailsScreenController> {
  const _CommentsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Comments',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Forum',
              color: Color(0xFF2A2A2A),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.replyingTo.value != null) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              TextField(
                controller: controller.commentController,
                onChanged: controller.updateCommentDraft,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF707070),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Type here your wise suggestion',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9A9A9A),
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Color(0xFF8A8A8A),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Color(0xFF8A8A8A),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: CustomColors.primaryOrange,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    height: 34,
                    child: OutlinedButton(
                      onPressed: controller.clearCommentDraft,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CustomColors.primaryOrange,
                        side: const BorderSide(
                          color: CustomColors.primaryOrange,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 34,
                    child: Obx(() {
                      final hasText = controller.commentDraft.value
                          .trim()
                          .isNotEmpty;
                      final isSubmitting =
                          controller.vm.isCommentSubmitting.value;
                      return ElevatedButton.icon(
                        onPressed: hasText && !isSubmitting
                            ? controller.submitComment
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryOrange,
                          disabledBackgroundColor: const Color(0xFFD2A990),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        icon: const Icon(Icons.messenger_outline, size: 14),
                        label: Text(isSubmitting ? 'Submitting...' : 'Submit'),
                      );
                    }),
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: 18),
        Obx(() {
          if (controller.commentsCount == 0) {
            return const _NoCommentsState();
          }

          final activeReplyId = controller.replyingTo.value?.id;
          final threads = controller.commentThreads;
          if (threads.isEmpty) {
            return const _NoCommentsState();
          }

          return Column(
            children: threads
                .map(
                  (thread) => _CommentThreadTile(
                    thread: thread,
                    isExpanded: controller.isThreadExpanded(thread.parent.id),
                    onToggleReplies: () =>
                        controller.toggleThreadReplies(thread.parent.id),
                    activeReplyId: activeReplyId,
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }
}

class _NoCommentsState extends StatelessWidget {
  const _NoCommentsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F1EA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Forum',
                color: Color(0xFF2A2A2A),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Be the first one to share your suggestion.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8A8A8A),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentThreadTile extends StatelessWidget {
  const _CommentThreadTile({
    required this.thread,
    required this.isExpanded,
    required this.onToggleReplies,
    required this.activeReplyId,
  });

  final PostCommentThread thread;
  final bool isExpanded;
  final VoidCallback onToggleReplies;
  final String? activeReplyId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentTile(
            item: thread.parent,
            repliesCount: thread.replies.length,
            isExpanded: isExpanded,
            onToggleReplies: onToggleReplies,
            onReply: () => Get.find<PostDetailsScreenController>().startReply(
              thread.parent,
            ),
            onLike: () => Get.find<PostDetailsScreenController>()
                .onCommentLikePressed(thread.parent.id),
            onDislike: () => Get.find<PostDetailsScreenController>()
                .onCommentDislikePressed(thread.parent.id),
          ),
          if (activeReplyId == thread.parent.id) ...[
            const SizedBox(height: 8),
            const _InlineReplyComposer(),
          ],
          if (thread.replies.isNotEmpty) ...[
            if (isExpanded) ...[
              const SizedBox(height: 4),
              ...thread.replies.map(
                (reply) => Padding(
                  padding: const EdgeInsets.only(left: 22, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReplyTile(
                        item: reply,
                        onReply: () => Get.find<PostDetailsScreenController>()
                            .startReply(reply),
                        onLike: () => Get.find<PostDetailsScreenController>()
                            .onCommentLikePressed(reply.id),
                        onDislike: () => Get.find<PostDetailsScreenController>()
                            .onCommentDislikePressed(reply.id),
                      ),
                      if (activeReplyId == reply.id) ...[
                        const SizedBox(height: 8),
                        const _InlineReplyComposer(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
          const Divider(height: 16, thickness: 1, color: Color(0xFFE5E5E5)),
        ],
      ),
    );
  }
}

class _InlineReplyComposer extends GetView<PostDetailsScreenController> {
  const _InlineReplyComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4EE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.commentController,
            onChanged: controller.updateCommentDraft,
            minLines: 2,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF707070),
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Write a reply.....',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9A9A9A),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF8A8A8A),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF8A8A8A),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: CustomColors.primaryOrange,
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: controller.cancelReply,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CustomColors.primaryOrange,
                    side: const BorderSide(
                      color: CustomColors.primaryOrange,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: Obx(() {
                  final hasText = controller.commentDraft.value
                      .trim()
                      .isNotEmpty;
                  final isSubmitting = controller.vm.isCommentSubmitting.value;

                  return ElevatedButton(
                    onPressed: hasText && !isSubmitting
                        ? controller.submitComment
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryOrange,
                      disabledBackgroundColor: const Color(0xFFD2A990),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text(isSubmitting ? 'Submitting...' : 'Submit'),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.item,
    required this.repliesCount,
    required this.isExpanded,
    required this.onToggleReplies,
    required this.onReply,
    required this.onLike,
    required this.onDislike,
  });

  final PostCommentItem item;
  final int repliesCount;
  final bool isExpanded;
  final VoidCallback onToggleReplies;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommentAvatar(imageUrl: item.avatarUrl),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${item.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8A8A8A),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.message,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 8),
        _CommentActionRow(
          likes: item.likes,
          dislikes: item.dislikes,
          repliesCount: repliesCount,
          isExpanded: isExpanded,
          isLiked: item.isLiked,
          isDisliked: item.isDisliked,
          onToggleReplies: onToggleReplies,
          onReply: onReply,
          onLike: onLike,
          onDislike: onDislike,
        ),
      ],
    );
  }
}

class _ReplyTile extends StatelessWidget {
  const _ReplyTile({
    required this.item,
    required this.onReply,
    required this.onLike,
    required this.onDislike,
  });

  final PostCommentItem item;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommentAvatar(imageUrl: item.avatarUrl),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${item.username}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8A8A8A),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          item.message,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5D5D5D),
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        _CommentActionRow(
          likes: item.likes,
          dislikes: item.dislikes,
          repliesCount: 0,
          isExpanded: false,
          isLiked: item.isLiked,
          isDisliked: item.isDisliked,
          onToggleReplies: () {},
          onReply: onReply,
          onLike: onLike,
          onDislike: onDislike,
        ),
      ],
    );
  }
}

class _CommentActionRow extends StatelessWidget {
  const _CommentActionRow({
    required this.likes,
    required this.dislikes,
    required this.repliesCount,
    required this.isExpanded,
    required this.isLiked,
    required this.isDisliked,
    required this.onToggleReplies,
    required this.onReply,
    required this.onLike,
    required this.onDislike,
  });

  final int likes;
  final int dislikes;
  final int repliesCount;
  final bool isExpanded;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onToggleReplies;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLike,
          child: isLiked
              ? const Icon(
                  Icons.thumb_up_alt,
                  size: 18,
                  color: Color(0xFF5A8BFF),
                )
              : const Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 18,
                  color: Color(0xFFA0A0A0),
                ),
        ),
        const SizedBox(width: 4),
        Text(
          '$likes',
          style: const TextStyle(fontSize: 10, color: Color(0xFF9B9B9B)),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onDislike,
          child: isDisliked
              ? const Icon(
                  Icons.thumb_down_alt,
                  size: 18,
                  color: Color(0xFF5A8BFF),
                )
              : const Icon(
                  Icons.thumb_down_alt_outlined,
                  size: 18,
                  color: Color(0xFFA0A0A0),
                ),
        ),
        const SizedBox(width: 4),
        Text(
          '$dislikes',
          style: const TextStyle(fontSize: 10, color: Color(0xFF9B9B9B)),
        ),
        const Spacer(),
        if (repliesCount > 0)
          TextButton.icon(
            onPressed: onToggleReplies,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(10, 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: const Color(0xFF5A8BFF),
            ),
            icon: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 12,
            ),
            label: Text(
              isExpanded
                  ? 'Hide All Replies ($repliesCount)'
                  : 'Show All Replies ($repliesCount)',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onReply,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(10, 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: const Color(0xFF5A8BFF),
          ),
          icon: const Icon(Icons.reply_rounded, size: 12),
          label: const Text(
            'Reply',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl?.trim().isNotEmpty == true;
    return CircleAvatar(
      radius: 15,
      backgroundColor: const Color(0xFFDADADA),
      backgroundImage: hasImage ? _imageProvider(imageUrl!.trim()) : null,
      child: hasImage
          ? null
          : const Icon(
              Icons.person_rounded,
              size: 14,
              color: Color(0xFF707070),
            ),
    );
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }

    return NetworkImage(path);
  }
}
