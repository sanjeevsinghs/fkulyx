import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/group_details_model.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

import '../../network/respone_handler.dart';

class GroupDetailsViewmodel extends GetxController {
  final CommunityForumRepo _repo = CommunityForumRepo();

  Rx<ApiResponse<GroupDetailsModel>> communityGroupDetails =
      ApiResponse<GroupDetailsModel>.loading().obs;
  final RxBool isJoining = false.obs;

  Future<void> fetchGroupDetails(String groupId) async {
    final cleanGroupId = groupId.trim();
    if (cleanGroupId.isEmpty) {
      communityGroupDetails.value = ApiResponse.error('Group ID is required');
      return;
    }

    communityGroupDetails.value = ApiResponse.loading();
    final response = await _repo.communityGroupDetails(groupId: cleanGroupId);
    if (response.success == false) {
      communityGroupDetails.value = ApiResponse.error(
        response.message ?? 'Failed to get group details',
      );
      AppSnackbar.showError(
        communityGroupDetails.value.message ?? 'Failed to get group details',
      );
    } else {
      communityGroupDetails.value = ApiResponse.completed(response);
    }
  }

  Future<void> joinCurrentGroup() async {
    final group = communityGroupDetails.value.data?.data;
    final groupId = group?.id?.trim() ?? '';

    if (groupId.isEmpty) {
      Get.snackbar('Error', 'Group id not available');
      return;
    }

    if (isJoining.value) {
      return;
    }

    final wasJoined = group?.isJoined ?? false;
    isJoining.value = true;
    final result = await _repo.joinGroup(groupId);
    isJoining.value = false;

    final isSuccess = result.success == true;
    Get.snackbar(
      isSuccess ? 'Success' : 'Error',
      result.message?.toString() ??
          (isSuccess
              ? (result.data?.isJoined == true
                    ? 'Joined successfully'
                    : 'Left group')
              : 'Failed to update group status'),
      backgroundColor: isSuccess
          ? const Color(0xFF2E7D32)
          : const Color(0xFFC62828),
      colorText: const Color(0xFFFFFFFF),
    );

    if (isSuccess && result.data != null) {
      final newJoinedState = result.data!.isJoined ?? false;

      // Update isJoined state from API response
      group?.isJoined = newJoinedState;

      // Update member count based on state change
      if (group?.memberCount != null) {
        if (!wasJoined && newJoinedState) {
          // User just joined
          group!.memberCount = group.memberCount! + 1;
        } else if (wasJoined && !newJoinedState) {
          // User just left
          group!.memberCount = group.memberCount! - 1;
        }
      }

      communityGroupDetails.refresh();
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
