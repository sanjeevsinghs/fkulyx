import 'package:get/get.dart';
import 'package:kulyx/features/lms/models/lesson_model.dart';

class LmsViewModel extends GetxController {
  final RxList<Lesson> lessons = RxList<Lesson>([]);
  final RxBool isLoading = RxBool(false);
  final RxString error = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      lessons.value = [
        Lesson(
          id: '1',
          title: 'Knife Skills Basics',
          subtitle: '12 min • Beginner',
          progress: 0.75,
        ),
        Lesson(
          id: '2',
          title: 'Making Perfect Broth',
          subtitle: '18 min • Intermediate',
          progress: 0.35,
        ),
        Lesson(
          id: '3',
          title: 'Sauce Masterclass',
          subtitle: '25 min • Advanced',
          progress: 0.10,
        ),
      ];
    } catch (e) {
      error.value = 'Failed to load lessons: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
