import 'package:get/get.dart';

class TabViewModel extends GetxController {
  final RxInt currentIndex = RxInt(0);

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void resetTab() {
    currentIndex.value = 0;
  }
}
