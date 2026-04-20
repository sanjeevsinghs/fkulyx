import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/add_post_viewmodel.dart';

class AddPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPostViewModel>(() => AddPostViewModel());
  }
}
