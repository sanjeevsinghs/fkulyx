import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Forum User Info Widget for displaying community user profiles
class ForumUserInfoWidget extends StatelessWidget {
  final String userName;
  final String userTitle;
  final String userImage;
  final String viewCount;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onProfileTap;

  const ForumUserInfoWidget({
    super.key,
    required this.userName,
    required this.userTitle,
    required this.userImage,
    required this.viewCount,
    this.isFollowing = false,
    this.onFollowTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CustomColors.lightGray, width: 0.5),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // User Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(userImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.cardGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.textGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                      Text(
                        viewCount,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomColors.textGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userTitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: CustomColors.textGray,
                      fontFamily: 'Forum',
                    ),
                  ),
                ],
              ),
            ),
            // Follow Button
            GestureDetector(
              onTap: onFollowTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isFollowing
                      ? CustomColors.white
                      : CustomColors.primaryOrange,
                  border: Border.all(
                    color: CustomColors.primaryOrange,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isFollowing
                        ? CustomColors.primaryOrange
                        : CustomColors.white,
                    fontFamily: 'Forum',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
