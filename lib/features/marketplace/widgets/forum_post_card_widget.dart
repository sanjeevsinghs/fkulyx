import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';

/// Forum Post Card Widget for displaying community posts/content
class ForumPostCardWidget extends StatelessWidget {
  final String postTitle;
  final String postContent;
  final String postImage;
  final List<String>? tags;
  final String repostedBy;
  final String authorName;
  final String authorTitle;
  final String authorImage;
  final int views;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isFollowing;
  final VoidCallback? onLikeTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onCardTap;

  const ForumPostCardWidget({
    super.key,
    required this.postTitle,
    this.postContent = '',
    required this.postImage,
    required this.tags,
    required this.repostedBy,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
    required this.views,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    this.isFollowing = false,
    this.onLikeTap,
    this.onFollowTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final postImageProvider = _imageProvider(postImage);
    final authorImageProvider = _imageProvider(authorImage);
    final safeTags = tags ?? const <String>[];

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repostedBy.trim().isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.repeat, size: 16, color: CustomColors.mediumGray),
                  SizedBox(width: 5),
                  Text(
                    'Reposted by $repostedBy',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 22, 21, 21),
                      fontFamily: 'Forum',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: postImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    postTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.cardGray,
                      fontFamily: 'Forum',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onLikeTap,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isLiked
                          ? CustomColors.primaryOrange
                          : const Color(0xFFE8E5DF),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image(image: AssetImage(AssetsImages.likeIcon)),
                    ),
                  ),
                ),
              ],
            ),
            if (postContent.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                postContent,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: CustomColors.textGray,
                  fontFamily: 'Forum',
                ),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: safeTags
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
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: authorImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$authorName•',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.black,
                        ),
                      ),
                      Text(
                        authorTitle,
                        style: const TextStyle(
                          fontSize: 10,
                          color: CustomColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onFollowTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isFollowing
                            ? CustomColors.primaryOrange
                            : const Color(0xFFBBBBBB),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        fontSize: 16,
                        color: isFollowing
                            ? CustomColors.primaryOrange
                            : CustomColors.cardGray,
                        fontFamily: 'Forum',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('${_formatCount(views)} Views'),
                _buildStatItem('${_formatCount(likes)} Likes'),
                _buildStatItem('${_formatCount(comments)} comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int value) {
    final text = value.toString();
    final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return text.replaceAllMapped(regExp, (match) => ',');
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    if (path.isNotEmpty) {
      return AssetImage(path);
    }

    return const AssetImage('assets/images/splash.png');
  }

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: CustomColors.mediumGray),
    );
  }
}
