import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/post_details_model.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class PostDetailsViewModel extends GetxController {
	final CommunityForumRepo _api = CommunityForumRepo();

	final Rxn<PostDetailsModel> postDetail = Rxn<PostDetailsModel>();
	final RxBool isLoading = false.obs;

	Future<void> getPostDetailsApi(String id) async {
		final postId = id.trim();
		if (postId.isEmpty) {
			AppSnackbar.show('Post id is required');
			return;
		}

		isLoading.value = true;

		_api.postDetail(postId).then((response) {
			isLoading.value = false;

			if (response.success == true && response.data != null) {
				postDetail.value = response;
			} else {
				AppSnackbar.show(response.message ?? 'Failed to load post details');
				Get.back();
			}
		}).onError((error, stackTrace) {
			isLoading.value = false;
			AppSnackbar.show(error.toString());
			debugPrint('${error.toString()} $stackTrace');
		});
	}
}
