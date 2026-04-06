import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Community Category Card Widget for "Newest and Recent" & "Popular of the day"
class CommunityCategoryCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Color iconBgColor;
  final VoidCallback? onTap;
  final bool compact;

  const CommunityCategoryCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconBgColor = CustomColors.iconBg,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: CustomColors.blackOverlay(0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: compact ? 10.5 : 11.5,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.cardGray,
                      fontFamily: 'Forum',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 8 : 9,
                      color: CustomColors.textGray,
                      fontFamily: 'Forum',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
