import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/group_details_viewmodel.dart';

class GroupDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupDetailsViewmodel>(() => GroupDetailsViewmodel());
  }
}
