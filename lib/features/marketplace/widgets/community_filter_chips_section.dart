import 'package:flutter/material.dart';
import 'community_filter_chip_widget.dart';

/// Community Filter Chips Section (ALL, People, Post, Group, Event)
class CommunityFilterChipsSection extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final bool compact;

  const CommunityFilterChipsSection({
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
            child: CommunityFilterChipWidget(
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
