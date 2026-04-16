import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/controllers/community_forum_controller.dart';
import 'package:kulyx/features/marketplace/models/forum_person_model.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final person = arguments is ForumPerson ? arguments : null;
    final personId =
        (arguments is Map<String, dynamic>
            ? arguments['personId']?.toString()
            : null) ??
        person?.id ??
        '';
    final personName =
        (arguments is Map<String, dynamic>
            ? arguments['name']?.toString()
            : null) ??
        person?.name ??
        'Person';
    final personRole =
        (arguments is Map<String, dynamic>
            ? arguments['role']?.toString()
            : null) ??
        person?.role ??
        'Member';
    final personImage =
        (arguments is Map<String, dynamic>
            ? arguments['image']?.toString()
            : null) ??
        person?.image ??
        '';
    final personIsFollowing =
        (arguments is Map<String, dynamic>
            ? arguments['isFollowing'] as bool?
            : null) ??
        person?.isFollow ??
        false;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _RoundIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        personName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: CustomColors.darkGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _FollowButton(
                      personId: personId,
                      initialFollowing: personIsFollowing,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AspectRatio(
                    aspectRatio: 1.9,
                    child: Image(
                      image: const AssetImage(AssetsImages.culinaryTagline),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 60, 14, 16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              personName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 32,
                                color: CustomColors.darkGray,
                                fontFamily: 'Forum',
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              personRole,
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.mediumGray,
                                fontFamily: 'Forum',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 0,
                      child: _ProfileAvatar(image: personImage),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: onTap,
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(icon, size: 24, color: CustomColors.darkGray),
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final String personId;
  final bool initialFollowing;

  const _FollowButton({required this.personId, required this.initialFollowing});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final forumController = _forumController;
      final isFollowing = forumController != null
          ? forumController.isPersonFollowed(personId)
          : initialFollowing;
      final isLoading =
          forumController != null &&
          forumController.peopleController.followActionInProgressIds.contains(
            personId,
          );

      return GestureDetector(
        onTap: isLoading ? null : () => _toggleFollow(forumController),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color
                // : isFollowing
                //     ? CustomColors.white
                :
                CustomColors.primaryOrange,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            isFollowing ? 'Following' : '+ Follow',
            style: TextStyle(
              color:
                  //  isFollowing
                  // ? CustomColors.primaryOrange
                  // :
                  CustomColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  CommunityForumController? get _forumController {
    if (!Get.isRegistered<CommunityForumController>()) {
      return null;
    }

    return Get.find<CommunityForumController>();
  }

  Future<void> _toggleFollow(CommunityForumController? forumController) async {
    if (personId.isEmpty) {
      Get.snackbar('Person', 'Person id not available');
      return;
    }

    if (forumController == null) {
      Get.snackbar('Person', 'Follow action is unavailable right now');
      return;
    }

    await forumController.followOrUnfollowPerson(personId);
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String image;

  const _ProfileAvatar({required this.image});

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider(image);

    return Container(
      width: 107,
      height: 107,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    if (path.isNotEmpty) {
      return AssetImage(path);
    }

    return const AssetImage(AssetsImages.person);
  }
}
