import 'package:get/get.dart';
import 'package:kulyx/features/lms/viewmodels/lms_viewmodel.dart';

class LmsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LmsViewModel>(() => LmsViewModel());
  }
}
