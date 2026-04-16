import 'dart:convert';

import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/event_details_model.dart';
import 'package:kulyx/model/community_forum/resgister_event_model.dart' hide Data;

import 'package:kulyx/network/api_base_service.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/network/respone_handler.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class EventDetailsViewmodel extends GetxController {
  final CommunityForumRepo _repo = CommunityForumRepo();

  Rx<ApiResponse<EventDetalsModel>> eventDetailsResponse =
      ApiResponse<EventDetalsModel>.loading().obs;
  RxBool isAboutExpanded = false.obs;
  RxBool isSpeakerFollowing = false.obs;
  RxInt speakerFollowersCount = 0.obs;
  RxBool isSpeakerFollowInProgress = false.obs;
  RxBool isEventRegisterInProgress = false.obs;
  final RxString currentUserId = ''.obs;
  Rx<RegisterEventModel> eventRegistrationResponse = RegisterEventModel(
    success: false,
  ).obs;

  Data? get eventData => eventDetailsResponse.value.data?.data;

  String get eventTitle => eventData?.name ?? 'Event Details';

  String get hostName {
    final firstName = eventData?.createdBy?.firstName ?? '';
    final lastName = eventData?.createdBy?.lastName ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isNotEmpty ? fullName : 'Host';
  }

  String get dateLabel => _formatEventDate(eventData?.startDateTime);

  String get locationLabel {
    final address = eventData?.location?.address ?? 'Location TBD';
    final city = eventData?.location?.city ?? 'Venue';
    return '$address$city';
  }

  int get attendeeCount => eventData?.attendeeCount ?? 0;

  String get attendeeLabel {
    final count = attendeeCount;
    return '$count attendee${count == 1 ? '' : 's'}';
  }

  String get aboutText =>
      eventData?.description ??
      'A big shoutout to our amazing yoga community for reaching out to organize a weekend retreat that blends YOGA and HEALTHY COOKING!';

  bool get shouldShowSeeMore => _wordCount(aboutText) > 12;

  String get displayAboutText {
    if (!shouldShowSeeMore || isAboutExpanded.value) {
      return aboutText;
    }
    return _truncateToWords(aboutText, 12);
  }

  String get coverImage => eventData?.coverImage ?? '';

  String get speakerRole => 'Event Creator';

  String get speakerImage => eventData?.createdBy?.profileImage ?? '';

  bool get isRegistered => eventData?.isRegistered == true;

  bool get isFollowing => eventData?.isFollowing == true;

  void onRegisterTap() {
    registerForEvent(eventData?.id ?? '');
  }

  void onFollowTap() {
    final userId = eventData?.createdBy?.id ?? '';
    toggleSpeakerFollow(userId);
  }

  void _syncUserIdFromToken() {
    if (currentUserId.value.isNotEmpty) return;

    final token = NetworkApiServices.accessToken.isNotEmpty
        ? NetworkApiServices.accessToken
        : ApiBaseService.accessToken;
    if (token.isEmpty) return;

    final parts = token.split('.');
    if (parts.length < 2) return;

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
      final userId = (payloadMap['sub'] ?? '').toString();
      if (userId.isNotEmpty) {
        currentUserId.value = userId;
      }
    } catch (_) {
      // Ignore invalid token payloads and keep the user id empty.
    }
  }

  Future<void> fetchEventDetails(String eventId) async {
    if (eventId.isEmpty) {
      eventDetailsResponse.value = ApiResponse.error('Event ID is required');
      return;
    }

    collapseAbout();
    eventDetailsResponse.value = ApiResponse.loading();
    final response = await _repo.CommunityEventsDetails(eventId: eventId);
    if (response.success == true) {
      isSpeakerFollowing.value = response.data?.isFollowing == true;
      speakerFollowersCount.value =
          response.data?.createdBy?.followersCount ?? 0;
      eventDetailsResponse.value = ApiResponse.completed(response);
    } else {
      eventDetailsResponse.value = ApiResponse.error(
        response.message ?? 'Failed to fetch event details',
      );
    }
  }

  void toggleAboutExpanded() {
    isAboutExpanded.value = !isAboutExpanded.value;
  }

  void collapseAbout() {
    isAboutExpanded.value = false;
  }

  Future<void> toggleSpeakerFollow(String personId) async {
    final cleanPersonId = personId.trim();
    if (cleanPersonId.isEmpty) {
      AppSnackbar.show('Person id not available');
      return;
    }

    try {
      final response = await _repo.followOrUnfollowPerson(cleanPersonId);
      final success = response['success'] == true;
      final message = (response['message'] ?? 'Failed to update follow status')
          .toString();
      AppSnackbar.show(message);

      if (!success) {
        return;
      }

      final data = response['data'] as Map<String, dynamic>?;
      final nextIsFollowing = data?['isFollowing'] == true;
      final previousIsFollowing = isSpeakerFollowing.value;

      isSpeakerFollowing.value = nextIsFollowing;

      final serverFollowersCount = (data?['followersCount'] as num?)?.toInt();
      if (serverFollowersCount != null) {
        speakerFollowersCount.value = serverFollowersCount;
      } else {
        if (!previousIsFollowing && nextIsFollowing) {
          speakerFollowersCount.value = speakerFollowersCount.value + 1;
        } else if (previousIsFollowing && !nextIsFollowing) {
          speakerFollowersCount.value = (speakerFollowersCount.value - 1)
              .clamp(0, 1 << 31)
              .toInt();
        }
      }

      final eventData = eventDetailsResponse.value.data?.data;
      if (eventData != null) {
        eventData.isFollowing = nextIsFollowing;
        eventData.createdBy?.followersCount = speakerFollowersCount.value;
      }
    } finally {}
  }

  Future<void> registerForEvent(String eventId, [String? userId]) async {
    final cleanEventId = eventId.trim();
    if (cleanEventId.isEmpty) {
      AppSnackbar.show('Event id not available');
      return;
    }

    _syncUserIdFromToken();
    final cleanUserId = (userId?.trim().isNotEmpty == true)
        ? userId!.trim()
        : currentUserId.value;
    if (cleanUserId.isEmpty) {
      AppSnackbar.show('User id not available');
      return;
    }

    isEventRegisterInProgress.value = true;

    try {
      final response = await _repo.registerEvent(cleanEventId, cleanUserId);
      final success = response.success == true;
      final message = response.message ?? 'Failed to register for event';

      AppSnackbar.show(message);

      if (success) {
        eventRegistrationResponse.value = response;

        // Update event details with registration status
        final eventData = eventDetailsResponse.value.data?.data;
        if (eventData != null) {
          eventData.isRegistered = true;
          eventData.attendeeCount = (eventData.attendeeCount ?? 0) + 1;
          eventDetailsResponse.refresh();
        }
      }
    } finally {
      isEventRegisterInProgress.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _syncUserIdFromToken();
    final eventId = Get.arguments?['eventId']?.toString() ?? '';
    if (eventId.isNotEmpty) {
      fetchEventDetails(eventId);
    }
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
