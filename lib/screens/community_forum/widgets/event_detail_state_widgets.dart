import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/loder.dart';

class EventDetailLoadingView extends StatelessWidget {
  const EventDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Center(child: Loder()),
    );
  }
}

class EventDetailErrorView extends StatelessWidget {
  final String message;

  const EventDetailErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Forum',
                color: CustomColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: CustomColors.mediumGray,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: Get.back,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryOrange,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 16,
                    fontFamily: 'Forum',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailEmptyView extends StatelessWidget {
  const EventDetailEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: CustomColors.primaryOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 16,
                  fontFamily: 'Forum',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
