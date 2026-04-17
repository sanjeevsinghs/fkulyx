import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/post_details_screen_controller.dart';
import 'package:kulyx/screens/community_forum/widgets/post_details_card_widget.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/loder.dart';

class PostDetailsScreen extends GetView<PostDetailsScreenController> {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1EF),
      body: SafeArea(
        child: Obx(() {
          if (controller.vm.isLoading.value &&
              controller.vm.postDetail.value == null) {
            return const Center(child: Loder());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        onPressed: Get.back,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Post',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.addPostScreen),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: CustomColors.primaryOrange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 20),
                              SizedBox(width: 2),
                              Text(
                                'Add Post ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PostDetailsCard(
                  title: controller.title,
                  content: controller.content,
                  authorName: controller.authorName,
                  authorTitle: controller.authorTitle,
                  authorImage: controller.authorImage,
                  postImage: controller.postImage,
                  repostedBy: controller.repostedBy,
                  dateLabel: controller.dateLabel,
                  tags: controller.tags,
                  views: controller.views,
                  likes: controller.likes,
                  comments: controller.commentsCount,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
