import 'package:flutter/material.dart';
import 'package:kulyx/widgets/custom_color.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onSearchPressed;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const CustomSearchField({
    super.key,
    this.hintText = 'Search for anything',
    this.controller,
    this.onSearchPressed,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CustomColors.darkGray,
          width: 1.2,
        ),
      ),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: CustomColors.hintGray,
            fontSize: 18,
            fontFamily: 'Forum',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(
            left: 12,
            right: 6,
            bottom: 10,
          ),
          suffixIcon: GestureDetector(
            onTap: onSearchPressed,
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.search,
                size: 28,
                color: CustomColors.darkGray,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 34,
            minHeight: 34,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Forum',
          fontSize: 18,
          color: CustomColors.darkGray,
        ),
      ),
    );
  }
}
