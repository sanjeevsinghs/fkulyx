// import '../../core/custom_imports.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/custom_field_style.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;

  // Border customization
  final double? borderRadius;
  final Color? hintTextColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final double? focusedBorderWidth;
  final double? enabledBorderWidth;
  final double? disabledBorderWidth;
  final double? errorBorderWidth;

  // Text customization
  final double? fontSize;
  final Color? textColor;
  final Color? focusedTextColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final FontWeight? fontWeight;
  final FontWeight? focusedFontWeight;
  final FontWeight? enabledFontWeight;
  final FontWeight? disabledFontWeight;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  // Fill color customization
  final Color? fillColor;
  final Color? focusedFillColor;
  final Color? enabledFillColor;
  final bool? filled;
  final AutovalidateMode? autovalidateMode;
  final String? errorText;
  final bool? digitsOnly;

  const CustomTextFormField({
    this.digitsOnly,
    super.key,
    this.controller,
    this.hintText,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.contentPadding,
    this.validator,
    this.borderRadius,
    this.hintTextColor,
    this.borderColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.enabledBorderWidth,
    this.disabledBorderWidth,
    this.errorBorderWidth,
    this.fontSize,
    this.textColor,
    this.focusedTextColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.fontWeight,
    this.focusedFontWeight,
    this.enabledFontWeight,
    this.disabledFontWeight,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.focusedFillColor,
    this.enabledFillColor,
    this.filled,
    this.autovalidateMode,
    this.errorText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  bool get _isFocused => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  TextStyle _getTextStyle() {
    final baseColor = widget.textColor ?? HexColor(color313131);
    final focusColor = widget.focusedTextColor ?? baseColor;
    final enableColor = widget.enabledTextColor ?? baseColor;
    final disableColor = widget.disabledTextColor ?? HexColor(color808080);

    final baseWeight = widget.fontWeight ?? FontWeight.w400;
    final focusWeight = widget.focusedFontWeight ?? baseWeight;
    final enableWeight = widget.enabledFontWeight ?? baseWeight;
    final disableWeight = widget.disabledFontWeight ?? FontWeight.w400;

    if (widget.readOnly == true) {
      return robotoStyle(
        textSize: widget.fontSize ?? 14,
        textColor: disableColor,
        fontWeight: disableWeight,
      );
    } else if (_isFocused) {
      return robotoStyle(
        textSize: widget.fontSize ?? 14,
        textColor: focusColor,
        fontWeight: focusWeight,
      );
    } else {
      return robotoStyle(
        textSize: widget.fontSize ?? 14,
        textColor: enableColor,
        fontWeight: enableWeight,
      );
    }
  }

  OutlineInputBorder _buildBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Color _getFillColor() {
    if (widget.filled == false) {
      return Colors.transparent;
    }
    if (_isFocused && widget.focusedFillColor != null) {
      return widget.focusedFillColor!;
    }
    if (!_isFocused && widget.enabledFillColor != null) {
      return widget.enabledFillColor!;
    }
    return widget.fillColor ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.borderColor ?? HexColor(textFildColor);
    final focusedColor = widget.focusedBorderColor ?? HexColor(colorEC5600);
    final enabledColor = widget.enabledBorderColor ?? HexColor(textFildColor);
    final disabledColor = widget.disabledBorderColor ?? HexColor(colorC8C8C8);
    final errorColor = widget.errorBorderColor ?? HexColor(errorRedColor);

    // Safely get controller - only use if not null and widget is still mounted
    TextEditingController? controller;
    if (widget.controller != null && mounted) {
      try {
        // Try to access the controller to check if it's still valid
        // If disposed, accessing text will throw an error
        final _ = widget.controller!.text;
        controller = widget.controller;
      } catch (e) {
        // Controller is disposed, use null
        controller = null;
      }
    }

    return TextFormField(
      controller: controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines ?? 1,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
      style: widget.textStyle ?? _getTextStyle(),
      cursorColor: HexColor(primaryBlack),
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: widget.hintText ?? "",
        hintStyle:
            widget.hintStyle ??
            robotoStyle(
              textSize: widget.fontSize ?? 14,
              textColor:
                  widget.hintTextColor ??
                  HexColor(primaryBlack),
              height: 1.4,
            ),
        border: _buildBorder(
          color: defaultColor,
          width: widget.borderWidth ?? 1,
        ),
        enabledBorder: _buildBorder(
          color: enabledColor,
          width: widget.enabledBorderWidth ?? 1,
        ),
        focusedBorder: _buildBorder(
          color: focusedColor,
          width: widget.focusedBorderWidth ?? 1.5,
        ),
        errorBorder: _buildBorder(
          color: errorColor,
          width: widget.errorBorderWidth ?? 1,
        ),
        focusedErrorBorder: _buildBorder(
          color: errorColor,
          width: widget.errorBorderWidth ?? 1.5,
        ),
        disabledBorder: _buildBorder(
          color: disabledColor,
          width: widget.disabledBorderWidth ?? 1,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText == true
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: HexColor(color313131),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        filled: widget.filled ?? true,
        fillColor: _getFillColor(),

        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }
}

class PhoneInputWithCode extends StatefulWidget {
  final TextEditingController controller;
  final String countryCode;
  final String? Function(String?)? validator;
  final String? hintText;

  const PhoneInputWithCode({
    super.key,
    required this.controller,
    this.countryCode = "+213",
    this.validator,
    this.hintText,
  });

  @override
  State<PhoneInputWithCode> createState() => _PhoneInputWithCodeState();
}

class _PhoneInputWithCodeState extends State<PhoneInputWithCode> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _buildBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = HexColor(textFildColor);
    final focusedColor = HexColor(colorEC5600);
    final errorColor = HexColor(errorRedColor);

    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          validator: widget.validator,
          style: robotoStyle(
            textSize: 14,
            textColor: HexColor(color313131),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: widget.hintText ?? "Enter Mobile Number",
            hintStyle: robotoStyle(
              textSize: 14,
              textColor: HexColor(color9CA3AF),
              fontWeight: FontWeight.w400,
            ),

            border: _buildBorder(color: defaultColor, width: 1),
            enabledBorder: _buildBorder(color: defaultColor, width: 1),
            focusedBorder: _buildBorder(color: focusedColor, width: 1.5),
            errorBorder: _buildBorder(color: errorColor, width: 1),
            focusedErrorBorder: _buildBorder(color: errorColor, width: 1.5),

            contentPadding: const EdgeInsets.only(
              left: 80,  // Space for country code
              right: 12,
              top: 16,
              bottom: 16,
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: 16,
          bottom: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.countryCode,
                style: robotoStyle(
                  textSize: 14,
                  textColor: HexColor(color313131),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 20,
                width: 1,
                color: HexColor(colorD1D5DB),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}