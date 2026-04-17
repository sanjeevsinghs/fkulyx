import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/post_details_screen_controller.dart';
import 'package:kulyx/view_model/Community_forum/post_details_viewmodel.dart';

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostDetailsViewModel>(() => PostDetailsViewModel());
    Get.lazyPut<PostDetailsScreenController>(() => PostDetailsScreenController());
  }
}