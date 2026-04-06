import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Community Filter Chip Widget for ALL, People, Post, Group, Event
class CommunityFilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  const CommunityFilterChipWidget({
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
