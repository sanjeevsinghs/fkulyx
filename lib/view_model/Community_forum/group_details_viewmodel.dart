import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/join_group_model.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

import '../../network/respone_handler.dart';

class GroupDetailsViewmodel extends GetxController {
  final CommunityForumRepo _repo = CommunityForumRepo();

  Rx<ApiResponse<JoinGroupModel>> communityGroupDetails =
      ApiResponse<JoinGroupModel>.loading().obs;

  Future<void> fetchGroupDetails(String groupId) async {
    final cleanGroupId = groupId.trim();
    if (cleanGroupId.isEmpty) {
      communityGroupDetails.value = ApiResponse.error('Group ID is required');
      return;
    }

    communityGroupDetails.value = ApiResponse.loading();
    final response = await _repo.communityGroupDetails(groupId: cleanGroupId);
    if (response.success == true) {
      communityGroupDetails.value = ApiResponse.completed(response);
    } else {
      communityGroupDetails.value = ApiResponse.error(
        response.message ?? 'Failed to get group details',
      );
      AppSnackbar.showError(
        communityGroupDetails.value.message ?? 'Failed to get group details',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    final groupId = Get.arguments is Map<String, dynamic>
        ? (Get.arguments['groupId']?.toString() ?? '')
        : '';

    fetchGroupDetails(groupId);
  }
}
