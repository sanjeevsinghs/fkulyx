import 'package:get/get.dart';
import 'package:kulyx/features/tabs/viewmodels/tab_viewmodel.dart';

class TabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabViewModel>(() => TabViewModel());
  }
}