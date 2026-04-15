import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/event_details_model.dart';
import 'package:kulyx/model/community_forum/register_event_model.dart';
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
  RxBool isEventRegisterInProgress = false.obs;
  Rx<RegisterEventModel> eventRegistrationResponse = RegisterEventModel(
    success: false,
  ).obs;

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

  Future<void> registerForEvent(String eventId, String userId) async {
    final cleanEventId = eventId.trim();
    if (cleanEventId.isEmpty) {
      AppSnackbar.show('Event id not available');
      return;
    }

    isEventRegisterInProgress.value = true;

    try {
      final response = await _repo.registerEvent(cleanEventId, userId);
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
        }
      }
    } finally {
      isEventRegisterInProgress.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final eventId = Get.arguments?['eventId']?.toString() ?? '';
    if (eventId.isNotEmpty) {
      fetchEventDetails(eventId);
    }
  }
}
