import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Forum Post Card Widget for displaying community posts/content
class ForumPostCardWidget extends StatelessWidget {
  final String postTitle;
  final String postImage;
  final List<String> tags;
  final String authorName;
  final String authorTitle;
  final String authorImage;
  final int views;
  final int likes;
  final int comments;
  final VoidCallback? onLikeTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onCardTap;

  const ForumPostCardWidget({
    super.key,
    required this.postTitle,
    required this.postImage,
    required this.tags,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
    required this.views,
    required this.likes,
    required this.comments,
    this.onLikeTap,
    this.onFollowTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(postImage),
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
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: CustomColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: CustomColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                          fontFamily: 'Forum',
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
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(authorImage),
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
                        '$authorName •',
                        style: const TextStyle(
                          fontSize: 13,
                          color: CustomColors.cardGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                      Text(
                        authorTitle,
                        style: const TextStyle(
                          fontSize: 10,
                          color: CustomColors.textGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onFollowTap,
                  child: Container(
                    width: 84,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFBBBBBB),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.cardGray,
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

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: CustomColors.textGray,
        fontFamily: 'Forum',
      ),
    );
  }
}
