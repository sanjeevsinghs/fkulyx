import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/widgets/expandable_text/expandable_content_controller.dart';

class ExpandableContentText extends StatefulWidget {
  const ExpandableContentText({
    super.key,
    required this.text,
    this.wordLimit = 30,
    this.textStyle,
    this.actionStyle,
  });

  final String text;
  final int wordLimit;
  final TextStyle? textStyle;
  final TextStyle? actionStyle;

  @override
  State<ExpandableContentText> createState() => _ExpandableContentTextState();
}

class _ExpandableContentTextState extends State<ExpandableContentText> {
  late final ExpandableContentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableContentController(
      text: widget.text,
      wordLimit: widget.wordLimit,
    );
  }

  @override
  void didUpdateWidget(covariant ExpandableContentText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.updateText(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.trim().isEmpty) return const SizedBox.shrink();

    return Obx(() {
      final preview = _controller.visibleText;
      final showToggle = _controller.canExpand;
      final expanded = _controller.isExpanded.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            preview,
            style:
                widget.textStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  color: Color(0xFF202020),
                  fontWeight: FontWeight.w400,
                ),
          ),
          if (showToggle) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _controller.toggleExpanded,
              child: Text(
                expanded ? 'Show less' : 'Show more',
                style:
                    widget.actionStyle ??
                    const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD8742F),
                    ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
