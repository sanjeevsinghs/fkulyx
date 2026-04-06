import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/controllers/community_forum_controller.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityForumController>(() => CommunityForumController());
  }
}
