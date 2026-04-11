import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';

class ForumGroupCardWidget extends StatelessWidget {
  final String name;
  final String groupType;
  final String location;
  final String description;
  final String image;
  final VoidCallback? onJoinTap;
  final VoidCallback? onCardTap;

  const ForumGroupCardWidget({
    super.key,
    required this.name,
    required this.groupType,
    required this.location,
    required this.description,
    required this.image,
    this.onJoinTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider(image);

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Forum',
                          color: CustomColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        groupType,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                        ),
                      ),
                      // const SizedBox(height: 2),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.location_on,
                      //       size: 16,
                      //       color: CustomColors.black,
                      //     ),
                      //     const SizedBox(width: 4),
                      //     Expanded(
                      //       child: Text(
                      //         location,
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: const TextStyle(
                      //           fontSize: 14,
                      //           color: CustomColors.cardGray,
                      //           fontFamily: 'Forum',
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.mediumGray,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onJoinTap,
              child: Container(
                width: 120,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: CustomColors.primaryOrange,
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(
                    fontSize: 24,
                    color: CustomColors.primaryOrange,
                    fontFamily: 'Forum',
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    if (path.isNotEmpty) {
      return AssetImage(path);
    }

    return const AssetImage(AssetsImages.splash);
  }
}
