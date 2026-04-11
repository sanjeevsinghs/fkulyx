import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/controllers/community_events_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_forum_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_groups_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_people_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_posts_controller.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityPostsController>(() => CommunityPostsController());
    Get.lazyPut<CommunityPeopleController>(() => CommunityPeopleController());
    Get.lazyPut<CommunityGroupsController>(() => CommunityGroupsController());
    Get.lazyPut<CommunityEventsController>(() => CommunityEventsController());
    Get.lazyPut<CommunityForumController>(
      () => CommunityForumController(
        postsController: Get.find<CommunityPostsController>(),
        peopleController: Get.find<CommunityPeopleController>(),
        groupsController: Get.find<CommunityGroupsController>(),
        eventsController: Get.find<CommunityEventsController>(),
      ),
    );
  }
}
