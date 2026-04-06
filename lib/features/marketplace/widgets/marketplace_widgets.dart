import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Marketplace Header with Menu, Logo, and Cart
class MarketplaceHeaderWidget extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onCartPressed;
  final Widget logoImage;

  const MarketplaceHeaderWidget({
    super.key,
    this.onMenuPressed,
    this.onCartPressed,
    required this.logoImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Row(
        children: [
          _buildIconButton(
            onPressed: onMenuPressed,
            icon: Icons.menu,
            size: 22,
            iconColor: CustomColors.mediumGray,
            borderColor: CustomColors.borderGray,
            backgroundColor: CustomColors.white,
          ),
          const SizedBox(width: 12),
          logoImage,
          const Spacer(),
          _buildIconButton(
            onPressed: onCartPressed,
            icon: Icons.shopping_cart_outlined,
            size: 19,
            iconColor: CustomColors.white,
            borderColor: CustomColors.primaryOrange,
            backgroundColor: CustomColors.primaryOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required double size,
    required Color iconColor,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: Icon(icon, size: size, color: iconColor),
        ),
      ),
    );
  }
}

/// Category Card Widget for "Newest and Recent" & "Popular of the day"
class CategoryCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Color iconBgColor;
  final VoidCallback? onTap;
  final bool compact;

  const CategoryCardWidget({
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

/// Filter Chip Widget for ALL, People, Post, Group, Event
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: compact ? 72 : 78,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? CustomColors.primaryOrange : CustomColors.lightGray,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? CustomColors.white : CustomColors.chipTextGray,
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Forum',
          ),
        ),
      ),
    );
  }
}

/// Category Cards Container (Newest and Recent + Popular)
class CategoryCardsSection extends StatelessWidget {
  final Widget newestIcon;
  final Widget popularIcon;
  final VoidCallback? onNewestTap;
  final VoidCallback? onPopularTap;
  final bool compact;

  const CategoryCardsSection({
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
            child: CategoryCardWidget(
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
            child: CategoryCardWidget(
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

/// Filter Chips Container (ALL, People, Post, Group, Event)
class FilterChipsSection extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final bool compact;

  const FilterChipsSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['ALL', 'People', 'Post', 'Group', 'Event'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == filters.length - 1 ? 0 : 16,
            ),
            child: FilterChipWidget(
              label: filter,
              selected: selectedFilter == filter,
              onTap: () => onFilterSelected(filter),
              compact: compact,
            ),
          );
        }),
      ),
    );
  }
}
