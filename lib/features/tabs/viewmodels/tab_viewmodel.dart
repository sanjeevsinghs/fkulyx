import 'package:get/get.dart';

class TabViewModel extends GetxController {
  final RxInt currentIndex = RxInt(3);

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void resetTab() {
    currentIndex.value = 3;
  }
}
