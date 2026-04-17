import 'package:kulyx/model/community_forum/event_details_model.dart';
import 'package:kulyx/model/community_forum/join_group_model.dart';
import 'package:kulyx/model/community_forum/post_details_model.dart';
import 'package:kulyx/model/community_forum/resgister_event_model.dart';

import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class CommunityForumRepo {
  final NetworkApiServices _apiService = NetworkApiServices();

  Future<JoinGroupModel> joinGroup(String groupId) async {
    try {
      final response = await _apiService.postApi({
        'groupId': groupId,
      }, ApiEndpoints.joinGroup);
      try {
        final parsedResponse = JoinGroupModel.fromJson(response);
        return parsedResponse;
      } catch (parseError) {
        return JoinGroupModel.fromJson(response);
      }
    } catch (e) {
      String errorMessage = e.toString();

      // Remove exception prefixes
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.split('Exception: ').last;
      }
      if (errorMessage.contains('FetchDataException: ')) {
        errorMessage = errorMessage.split('FetchDataException: ').last;
      }

      // Return a response object instead of throwing, so view model can display it
      return JoinGroupModel(
        success: false,
        message: errorMessage.isNotEmpty
            ? errorMessage
            : 'Failed to join group',
        // member: null,
      );
    }
  }

  // Future<JoinGroupModel> joinGroup(
  //   required String groupId,
  // ) async {
  //   final response = await _apiService.postApi({
  //     "groupId": groupId,
  //   }, ApiEndpoints.joinGroup);
  //   return JoinGroupModel.fromJson(response);
  // }

  Future<EventDetalsModel> CommunityEventsDetails({
    required String eventId,
  }) async {
    try {
      final url = '${ApiEndpoints.communityEvents}/$eventId';
      final response = await _apiService.getApi(url);
      return EventDetalsModel.fromJson(response);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.split('Exception: ').last;
      }
      if (errorMessage.contains('FetchDataException: ')) {
        errorMessage = errorMessage.split('FetchDataException: ').last;
      }
      return EventDetalsModel(
        success: false,
        message: errorMessage.isNotEmpty
            ? errorMessage
            : 'Failed to fetch event details',
      );
    }
  }

  Future<Map<String, dynamic>> followOrUnfollowPerson(String personId) async {
    final cleanPersonId = personId.trim();
    if (cleanPersonId.isEmpty) {
      return <String, dynamic>{
        'success': false,
        'message': 'Person id not available',
      };
    }

    try {
      final url = '${ApiEndpoints.followers}/$cleanPersonId/follow';
      final response = await _apiService.postApi(null, url);
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected follow response format');
      }

      return response;
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.split('Exception: ').last;
      }
      if (errorMessage.contains('FetchDataException: ')) {
        errorMessage = errorMessage.split('FetchDataException: ').last;
      }

      return <String, dynamic>{
        'success': false,
        'message': errorMessage.isNotEmpty
            ? errorMessage
            : 'Failed to update follow status',
      };
    }
  }

  Future<RegisterEventModel> registerEvent(
    String eventId,
    String userId,
  ) async {
    final cleanEventId = eventId.trim();
    final cleanUserId = userId.trim();

    if (cleanEventId.isEmpty) {
      return RegisterEventModel(
        success: false,
        message: 'Event id not available',
      );
    }

    if (cleanUserId.isEmpty) {
      return RegisterEventModel(
        success: false,
        message: 'User id not available',
      );
    }

    try {
      final payload = {
        'eventId': cleanEventId,
        'userId': cleanUserId,
        'status': 'registered',
        'metadata': {},
      };

      final response = await _apiService.postApi(
        payload,
        ApiEndpoints.communityEventAttendees,
      );

      try {
        final parsedResponse = RegisterEventModel.fromJson(response);
        return parsedResponse;
      } catch (parseError) {
        return RegisterEventModel.fromJson(response);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.split('Exception: ').last;
      }
      if (errorMessage.contains('FetchDataException: ')) {
        errorMessage = errorMessage.split('FetchDataException: ').last;
      }

      return RegisterEventModel(
        success: false,
        message: errorMessage.isNotEmpty
            ? errorMessage
            : 'Failed to register for event',
      );
    }
  }

  // Future<GamificationChallengesModel> allChallenges() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.allChallenges,
  //   );
  //   return GamificationChallengesModel.fromJson(response);
  // }

  Future<PostDetailsModel> postDetail(String postId) async {
    final response = await _apiService.getApi(
      '${ApiEndpoints.communityPosts}/$postId',
    );
    return PostDetailsModel.fromJson(response);
  }

  Future<PostDetailsModel> upVotePost(String postId) async {
    final response = await _apiService.postApi(
      null,
      '${ApiEndpoints.communityPosts}/$postId/upvote',
    );
    return PostDetailsModel.fromJson(response);
  }

  Future<PostDetailsModel> downVotePost(String postId) async {
    final response = await _apiService.postApi(
      null,
      '${ApiEndpoints.communityPosts}/$postId/downvote',
    );
    return PostDetailsModel.fromJson(response);
  }

  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String content,
    String parentCommentId = '',
  }) async {
    final response = await _apiService.postApi({
      'postId': postId,
      'content': content,
      'parentCommentId': parentCommentId,
      'metadata': <String, dynamic>{},
    }, ApiEndpoints.communityComments);

    if (response is Map<String, dynamic>) {
      return response;
    }

    return <String, dynamic>{
      'success': false,
      'message': 'Unexpected comment response format',
    };
  }

  Future<Map<String, dynamic>> replyToComment({
    required String commentId,
    required String content,
  }) async {
    final response = await _apiService.postApi({
      'content': content,
      'metadata': <String, dynamic>{},
    }, '${ApiEndpoints.communityComments}/$commentId/reply');

    if (response is Map<String, dynamic>) {
      return response;
    }

    return <String, dynamic>{
      'success': false,
      'message': 'Unexpected reply response format',
    };
  }

  Future<Map<String, dynamic>> likeComment(String commentId) async {
    final response = await _apiService.postApi(
      null,
      '${ApiEndpoints.communityComments}/$commentId/like',
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    return <String, dynamic>{
      'success': false,
      'message': 'Unexpected like response format',
    };
  }

  Future<Map<String, dynamic>> dislikeComment(String commentId) async {
    final response = await _apiService.postApi(
      null,
      '${ApiEndpoints.communityComments}/$commentId/dislike',
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    return <String, dynamic>{
      'success': false,
      'message': 'Unexpected dislike response format',
    };
  }

  // Future<ChallengesMyRankingsModel> challengeMyRanking() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.challengeMyRankings,
  //   );
  //   return ChallengesMyRankingsModel.fromJson(response);
  // }

  // Future<ChallengesUserCardsModel> challengeUseCards() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.challengeUserCards,
  //   );
  //   return ChallengesUserCardsModel.fromJson(response);
  // }
}
