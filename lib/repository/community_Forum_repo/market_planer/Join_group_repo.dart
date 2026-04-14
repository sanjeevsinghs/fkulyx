import 'package:kulyx/model/join_group_model.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class JoinGroupRepo {
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

  // Future<GamificationTasksModel> gamificationTasks() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.gamificationTasks,
  //   );
  //   return GamificationTasksModel.fromJson(response);
  // }

  // Future<GamificationChallengesLeaderboardModel> challengesLeaderboard() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.challengesLeaderboard,
  //   );
  //   return GamificationChallengesLeaderboardModel.fromJson(response);
  // }

  // Future<GamificationChallengesModel> allChallenges() async {
  //   final response = await _apiService.getApi(
  //     ApiEndpoints.allChallenges,
  //   );
  //   return GamificationChallengesModel.fromJson(response);
  // }

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
