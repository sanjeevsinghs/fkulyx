import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';

class ForumEventCardWidget extends StatelessWidget {
  final String title;
  final String coverImage;
  final String dateLabel;
  final String locationLabel;
  final String description;
  final int attendeeCount;
  final VoidCallback? onCardTap;

  const ForumEventCardWidget({
    super.key,
    required this.title,
    required this.coverImage,
    required this.dateLabel,
    required this.locationLabel,
    required this.description,
    required this.attendeeCount,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider(coverImage);

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 168,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                color: CustomColors.cardGray,
                fontFamily: 'Forum',
                height: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(icon: Icons.calendar_month_outlined, text: dateLabel),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              text: locationLabel,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.mediumGray,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.groups_outlined,
              text: '$attendeeCount Attendee${attendeeCount == 1 ? '' : 's'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: CustomColors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: CustomColors.mediumGray,
              height: 1.2,
            ),
          ),
        ),
      ],
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
