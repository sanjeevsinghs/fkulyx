import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/add_post_viewmodel.dart';
import 'package:kulyx/widgets/loder.dart';

class AddPostScreen extends GetView<AddPostViewModel> {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF45C00);
    const borderColor = Color(0xFF9A9A9A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => Stack(
          children: <Widget>[
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Create Post',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'forum',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD0D0D0),
                    ),
                    const SizedBox(height: 18),
                    const Text('Post Title', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    _TextFieldBox(
                      controller: controller.titleController,
                      hintText: 'Enter Post Title',
                      borderColor: borderColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),
                    const Text('Description*', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    _TextFieldBox(
                      controller: controller.descriptionController,
                      hintText: 'What is the purpose of your post?',
                      borderColor: borderColor,
                      maxLines: 3,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Image', style: TextStyle(fontSize: 14)),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomPaint(
                            painter: _DashedRectPainter(
                              color: const Color(0xFF444444),
                              strokeWidth: 1,
                              dashWidth: 8,
                              dashGap: 6,
                            ),
                            child: SizedBox(
                              height: 112,
                              child: controller.selectedImageBytes.value != null
                                  ? Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: Image.memory(
                                              controller
                                                  .selectedImageBytes
                                                  .value!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            color: Colors.black54,
                                            child: const Text(
                                              'Change',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.image_outlined,
                                          size: 42,
                                          color: Color(0xFF9E9E9E),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Upload Post image',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Minimum width 480 pixels, 16:9 recommended',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8D8D8D),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.selectedImage.value == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                controller.selectedImage.value!.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6D6D6D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Location', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    _TextFieldBox(
                      controller: controller.locationController,
                      hintText: '',
                      borderColor: borderColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),
                    const Text('Tags', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                ...controller.tags.map(
                                  (tag) => Chip(
                                    label: Text(tag),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () => controller.removeTag(tag),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  height: 34,
                                  child: TextField(
                                    controller: controller.tagController,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => controller.addTag(),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                      hintText: 'Add Tags',
                                      hintStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color: accentColor,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: controller.addTag,
                                        icon: const Icon(Icons.add, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: SizedBox(
                        width: 175,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isSubmitting.value
                              ? null
                              : controller.submitPost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add Post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isSubmitting.value)
              Positioned.fill(
                child: AbsorbPointer(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(child: Loder()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.controller,
    required this.hintText,
    required this.borderColor,
    required this.maxLines,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
  });

  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding,
        border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  const _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    _drawDashedLine(canvas, paint, rect.topLeft, rect.topRight);
    _drawDashedLine(canvas, paint, rect.topRight, rect.bottomRight);
    _drawDashedLine(canvas, paint, rect.bottomRight, rect.bottomLeft);
    _drawDashedLine(canvas, paint, rect.bottomLeft, rect.topLeft);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final totalLength = (end - start).distance;
    if (totalLength == 0) return;

    final direction = (end - start) / totalLength;
    double distance = 0;

    while (distance < totalLength) {
      final dashEnd = distance + dashWidth < totalLength
          ? distance + dashWidth
          : totalLength;
      canvas.drawLine(
        start + direction * distance,
        start + direction * dashEnd,
        paint,
      );
      distance += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
