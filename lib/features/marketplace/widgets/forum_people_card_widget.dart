import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

class ForumPeopleCardWidget extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String image;
  final List<String> tags;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onCardTap;

  const ForumPeopleCardWidget({
    super.key,
    required this.name,
    required this.role,
    required this.location,
    required this.image,
    required this.tags,
    this.isFollowing = false,
    this.onFollowTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: CustomColors.darkGray,
                          fontFamily: 'Forum',
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$role    $location',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.cardGray,
                          fontFamily: 'Forum',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E5DF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.cardGray,
                                    fontFamily: 'Forum',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Align(
              child: GestureDetector(
                onTap: onFollowTap,
                child: Container(
                  width: 132,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFollowing
                        ? CustomColors.primaryOrange
                        : CustomColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: CustomColors.primaryOrange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      fontSize: 18,
                      color: isFollowing
                          ? CustomColors.white
                          : CustomColors.primaryOrange,
                      fontFamily: 'Forum',
                    ),
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
