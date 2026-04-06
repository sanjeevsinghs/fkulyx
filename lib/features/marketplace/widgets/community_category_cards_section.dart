import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'community_category_card_widget.dart';

/// Community Category Cards Section (Newest and Recent + Popular)
class CommunityCategoryCardsSection extends StatelessWidget {
  final Widget newestIcon;
  final Widget popularIcon;
  final VoidCallback? onNewestTap;
  final VoidCallback? onPopularTap;
  final bool compact;

  const CommunityCategoryCardsSection({
    super.key,
    required this.newestIcon,
    required this.popularIcon,
    this.onNewestTap,
    this.onPopularTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CustomColors.softBeige,
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      child: Row(
        children: [
          Expanded(
            child: CommunityCategoryCardWidget(
              title: 'Newest and Recent',
              subtitle: 'Find the latest update',
              icon: newestIcon,
              iconBgColor: CustomColors.iconBg,
              onTap: onNewestTap,
              compact: compact,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CommunityCategoryCardWidget(
              title: 'Popular of the day',
              subtitle: 'Shots featured today by curators',
              icon: popularIcon,
              iconBgColor: CustomColors.iconBg,
              onTap: onPopularTap,
              compact: compact,
            ),
          ),
        ],
      ),
    );
  }
}
