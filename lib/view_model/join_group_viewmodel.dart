import 'package:get/get.dart';
import 'package:kulyx/model/join_group_model.dart';
import 'package:kulyx/network/respone_handler.dart';
import 'package:kulyx/repository/community_Forum_repo/market_planer/Join_group_repo.dart';

class JoinGroupViewmodel extends GetxController {
  final JoinGroupRepo _repo = JoinGroupRepo();

  final Rx<ApiResponse<JoinGroupModel>> _joinGroupResponse =
      ApiResponse<JoinGroupModel>.loading().obs;

  final Rxn<JoinGroupModel> joinGroupModel = Rxn<JoinGroupModel>();
  final RxMap<String, bool> joinedStateByGroupId = <String, bool>{}.obs;
  final RxSet<String> joinInProgressGroupIds = <String>{}.obs;

  bool joinedStateForGroup(String groupId, bool initialValue) {
    return joinedStateByGroupId[groupId] ?? initialValue;
  }

  bool isJoinInProgress(String groupId) {
    return joinInProgressGroupIds.contains(groupId);
  }

  Future<JoinGroupModel?> fetchJoinGroupData(String groupId) async {
    final cleanGroupId = groupId.trim();
    if (cleanGroupId.isEmpty) {
      _joinGroupResponse.value = ApiResponse.error('Group id not available');
      return null;
    }

    if (joinInProgressGroupIds.contains(cleanGroupId)) {
      return joinGroupModel.value;
    }

    joinInProgressGroupIds.add(cleanGroupId);
    _joinGroupResponse.value = ApiResponse.loading();
    try {
      final response = await _repo.joinGroup(cleanGroupId);

      // Store full API response object for later use in UI/debugging.
      joinGroupModel.value = response;

      if (response.success == true) {
        final isJoined = response.data?.isJoined == true;
        joinedStateByGroupId[cleanGroupId] = isJoined;
        _joinGroupResponse.value = ApiResponse.completed(response);
      } else {
        _joinGroupResponse.value = ApiResponse.error(response.message);
      }

      return response;
    } catch (error) {
      _joinGroupResponse.value = ApiResponse.error(error.toString());
      return null;
    } finally {
      joinInProgressGroupIds.remove(cleanGroupId);
    }
  }
}
