import 'package:get/get.dart';
import 'package:kulyx/features/dashboard/viewmodels/dashboard_viewmodel.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardViewModel>(() => DashboardViewModel());
  }
}
