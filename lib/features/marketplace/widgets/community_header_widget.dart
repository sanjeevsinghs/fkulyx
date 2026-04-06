import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

/// Community Header with Menu, Logo, and Cart
class CommunityHeaderWidget extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onCartPressed;
  final Widget logoImage;

  const CommunityHeaderWidget({
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
