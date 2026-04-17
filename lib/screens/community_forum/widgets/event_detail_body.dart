import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/event_details_viewmodel.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';

class EventDetailBody extends StatelessWidget {
  final EventDetailsViewmodel controller;

  const EventDetailBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final eventTitle = controller.eventTitle;
    final hostName = controller.hostName;
    final dateLabel = controller.dateLabel;
    final locationLabel = controller.locationLabel;
    final attendeeLabel = controller.attendeeLabel;
    final coverImage = controller.coverImage.isNotEmpty
        ? controller.coverImage
        : AssetsImages.splash;
    final speakerRole = controller.speakerRole;
    final speakerImage = controller.speakerImage.isNotEmpty
        ? controller.speakerImage
        : AssetsImages.splash;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Row(
                  children: [
                    EventCircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Event',
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.darkGray,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.primaryOrange,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Add Event',
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 16,
                                fontFamily: 'Forum',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1.78,
                    child: Image(
                      image: _imageProvider(coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'Forum',
                        color: CustomColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Event by $hostName',
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 14),
                    EventDetailLine(
                      icon: Icons.calendar_month_outlined,
                      text: dateLabel,
                    ),
                    const SizedBox(height: 10),
                    EventDetailLine(
                      icon: Icons.location_on_outlined,
                      text: locationLabel,
                    ),
                    const SizedBox(height: 10),
                    EventDetailLine(icon: Icons.groups, text: attendeeLabel),
                    Container(
                      color: const Color(0xFFF4F4F4),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: EventActionButtonsRow(
                        isRegistered: controller.isRegistered,
                        isRegisterLoading:
                            controller.isEventRegisterInProgress.value,
                        onRegisterTap: controller.onRegisterTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                child: Obx(() {
                  final shouldShowSeeMore = controller.shouldShowSeeMore;
                  final isAboutExpanded = controller.isAboutExpanded.value;
                  final displayAboutText = controller.displayAboutText;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Forum',
                          color: CustomColors.mediumGray,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        displayAboutText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.darkGray,
                          height: 1.45,
                        ),
                      ),
                      if (shouldShowSeeMore) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: controller.toggleAboutExpanded,
                          child: Text(
                            isAboutExpanded ? 'See less' : 'See more',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Forum',
                              color: CustomColors.mediumGray,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      const Text(
                        'Speakers',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Forum',
                          color: CustomColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => EventSpeakerCard(
                          image: speakerImage,
                          name: hostName,
                          role: speakerRole,
                          followers: controller.speakerFollowersCount.value,
                          isFollowing: controller.isSpeakerFollowing.value,
                          isFollowLoading:
                              controller.isSpeakerFollowInProgress.value,
                          onFollowTap: controller.onFollowTap,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }
}

class EventCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const EventCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        onTap: onTap,
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(icon, size: 20, color: CustomColors.darkGray),
        ),
      ),
    );
  }
}

class EventDetailLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventDetailLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: CustomColors.darkGray),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: CustomColors.darkGray,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class EventActionButtonsRow extends StatelessWidget {
  final bool isRegistered;
  final bool isRegisterLoading;
  final VoidCallback? onRegisterTap;

  const EventActionButtonsRow({
    super.key,
    required this.isRegistered,
    required this.isRegisterLoading,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isRegistered || isRegisterLoading ? null : onRegisterTap,
            child: Container(
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isRegistered
                    ? Colors.green
                    : isRegisterLoading
                    ? CustomColors.primaryOrange.withValues(alpha: 0.7)
                    : CustomColors.primaryOrange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: isRegisterLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.white,
                        ),
                      ),
                    )
                  : Text(
                      isRegistered ? 'Registered' : 'Register',
                      style: const TextStyle(
                        color: CustomColors.white,
                        fontSize: 18,
                        fontFamily: 'Forum',
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: CustomColors.primaryOrange),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Share',
                    style: TextStyle(
                      color: CustomColors.primaryOrange,
                      fontSize: 28,
                      fontFamily: 'Forum',
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: CustomColors.primaryOrange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EventSpeakerCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final int followers;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onFollowTap;

  const EventSpeakerCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    required this.followers,
    required this.isFollowing,
    required this.isFollowLoading,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: Image.asset(
                    AssetsImages.culinaryTagline,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 32,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.white, width: 4),
                    image: DecorationImage(
                      image: _imageProvider(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: CustomColors.darkGray,
                    fontFamily: 'Forum',
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.mediumGray,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$followers',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CustomColors.mediumGray,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Followers',
                      style: TextStyle(
                        fontSize: 14,
                        color: CustomColors.mediumGray,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: isFollowLoading ? null : onFollowTap,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? CustomColors.primaryOrange
                          : CustomColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: CustomColors.primaryOrange),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        fontSize: 18,
                        color: isFollowing
                            ? CustomColors.white
                            : CustomColors.primaryOrange,
                        fontFamily: 'Forum',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }
}
