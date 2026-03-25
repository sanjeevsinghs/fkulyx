import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/lms/viewmodels/lms_viewmodel.dart';
import 'package:kulyx/widgets/custom_text_field.dart';

class LmsView extends StatelessWidget {
  const LmsView({super.key});

  @override
  Widget build(BuildContext context) {
    final LmsViewModel viewModel = Get.find<LmsViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'LMS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Learn culinary skills with short guided lessons.',
              style: TextStyle(color: Color(0xFF666666)),
            ),
            const SizedBox(height: 14),
            Obx(
              () => viewModel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.value.isNotEmpty
                      ? Center(child: Text(viewModel.error.value))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = viewModel.lessons[index];
                              return _LessonTile(
                                title: lesson.title,
                                subtitle: lesson.subtitle,
                                progress: lesson.progress,
                              );
                            },
                          ),
                          
                        ),
                        
            ),
          
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFF6A00)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF666666))),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFF2F2F2),
              color: const Color(0xFFFF6A00),
            ),
          ),
            CustomTextFormField(
              controller: TextEditingController(),
              hintText: 'Search for anything',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF999999), size: 20),
              borderRadius: 8,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            ),
        ],
      ),
    );
  }
}
