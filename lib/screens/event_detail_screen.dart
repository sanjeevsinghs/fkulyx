import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/event_details_viewmodel.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/images.dart';
import 'package:kulyx/widgets/loder.dart';
import 'package:kulyx/network/respone_handler.dart';

class EventDetailScreen extends GetView<EventDetailsViewmodel> {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.eventDetailsResponse.value;

      if (response.status == Status.LOADING) {
        return const Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: Center(child: Loder()),
        );
      }

      if (response.status == Status.ERROR) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Forum',
                    color: CustomColors.darkGray,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    response.message ?? 'Failed to load event details',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.mediumGray,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.primaryOrange,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 16,
                        fontFamily: 'Forum',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final eventData = response.data?.data;
      if (eventData == null) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          body: SafeArea(
            child: Center(
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.primaryOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 16,
                      fontFamily: 'Forum',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final eventTitle = eventData.name ?? 'Event Details';
      final hostName =
          '${eventData.createdBy?.firstName ?? ''} ${eventData.createdBy?.lastName ?? ''}'
              .trim()
              .isNotEmpty
          ? '${eventData.createdBy?.firstName ?? ''} ${eventData.createdBy?.lastName ?? ''}'
                .trim()
          : 'Host';
      final dateLabel = _formatEventDate(eventData.startDateTime);
      final addressLine = eventData.location?.address ?? 'Location TBD';
      final venueName = eventData.location?.city ?? 'Venue';
      final attendees = eventData.attendeeCount ?? 0;
      final aboutText =
          eventData.description ??
          'A big shoutout to our amazing yoga community for reaching out to organize a weekend retreat that blends YOGA and HEALTHY COOKING!';
      final coverImage = eventData.coverImage ?? AssetsImages.splash;
      final speakerRole = 'Event Creator';
      final speakerImage =
          eventData.createdBy?.profileImage ?? AssetsImages.splash;
      final aboutWordCount = _wordCount(aboutText);
      final shouldShowSeeMore = aboutWordCount > 12;
      final isAboutExpanded = controller.isAboutExpanded.value;
      final displayAboutText = !shouldShowSeeMore || isAboutExpanded
          ? aboutText
          : _truncateToWords(aboutText, 12);

      return Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                      child: Row(
                        children: [
                          _CircleIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: Get.back,
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
                          _DetailLine(
                            icon: Icons.calendar_month_outlined,
                            text: dateLabel,
                          ),
                          const SizedBox(height: 10),
                          _DetailLine(
                            icon: Icons.location_on_outlined,
                            text: '$addressLine$venueName',
                          ),
                          const SizedBox(height: 10),
                          _DetailLine(
                            icon: Icons.groups,
                            text:
                                '$attendees attendee${attendees == 1 ? '' : 's'}',
                          ),
                          Container(
                            color: const Color(0xFFF4F4F4),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: _ActionButtonsRow(
                              eventId: eventData.id ?? '',
                              userId: eventData.createdBy?.id ?? '',
                              isRegistered: eventData.isRegistered ?? false,
                              isFollowing: eventData.isFollowing ?? false,
                              onRegisterTap: () {
                                controller.registerForEvent(
                                  eventData.id ?? '',
                                  eventData.createdBy?.id ?? '',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                      child: Column(
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
                          _SpeakerCard(
                            image: speakerImage,
                            name: hostName,
                            role: speakerRole,
                            followers: controller.speakerFollowersCount.value,
                            isFollowing: controller.isSpeakerFollowing.value,
                            isFollowLoading: false,
                            onFollowTap: () {
                              final userId = eventData.createdBy?.id ?? '';
                              controller.toggleSpeakerFollow(userId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  ImageProvider _imageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }

  String _formatEventDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Date not available';
    }

    final localDate = dateTime.toLocal();
    final now = DateTime.now();
    final sameDay =
        now.year == localDate.year &&
        now.month == localDate.month &&
        now.day == localDate.day;
    final dayName = sameDay ? 'Today' : _getDayName(localDate);

    final hour = localDate.hour % 12 == 0 ? 12 : localDate.hour % 12;
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$dayName, $hour:$minute $period';
  }

  String _getDayName(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  int _wordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return 0;
    }

    return trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  String _truncateToWords(String text, int maxWords) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= maxWords) {
      return text.trim();
    }

    return '${words.take(maxWords).join(' ')}...';
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

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

class _DetailLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: CustomColors.darkGray),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGray,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final String eventId;
  final String userId;
  final bool isRegistered;
  final bool isFollowing;
  final VoidCallback? onRegisterTap;

  const _ActionButtonsRow({
    required this.eventId,
    required this.userId,
    required this.isRegistered,
    required this.isFollowing,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onRegisterTap,
            child: Container(
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isRegistered ? Colors.green : CustomColors.primaryOrange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                isRegistered ? 'Registered' : 'Register',
                style: const TextStyle(
                  color: CustomColors.white,
                  fontSize: 28,
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

class _SpeakerCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final int followers;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onFollowTap;

  const _SpeakerCard({
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
                    SizedBox(width: 5),
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
                    child: isFollowLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isFollowing
                                    ? CustomColors.white
                                    : CustomColors.primaryOrange,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isFollowing
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: CustomColors.white,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 18,
                                      color: isFollowing
                                          ? CustomColors.white
                                          : CustomColors.primaryOrange,
                                    ),
                              const SizedBox(width: 6),
                              Text(
                                isFollowing ? 'Following' : 'Follow',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isFollowing
                                      ? CustomColors.white
                                      : CustomColors.primaryOrange,
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
