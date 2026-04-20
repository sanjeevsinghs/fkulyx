import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulyx/repository/community_Forum_repo/communitiy_forum_repo.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class AddPostViewModel extends GetxController {
  AddPostViewModel({CommunityForumRepo? communityForumRepo})
    : _communityForumRepo = communityForumRepo ?? CommunityForumRepo();

  final CommunityForumRepo _communityForumRepo;
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final RxList<String> tags = <String>[].obs;
  final Rxn<XFile> selectedImage = Rxn<XFile>();
  final Rxn<Uint8List> selectedImageBytes = Rxn<Uint8List>();
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    tagController.dispose();
    super.onClose();
  }

  void addTag() {
    final tag = tagController.text.trim();
    if (tag.isEmpty || tags.contains(tag)) {
      return;
    }

    tags.add(tag);
    tagController.clear();
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  Future<void> pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedImage == null) {
        return;
      }

      final bytes = await pickedImage.readAsBytes();
      selectedImage.value = pickedImage;
      selectedImageBytes.value = bytes;
    } catch (_) {
      AppSnackbar.show('Unable to pick image');
    }
  }

  Future<void> submitPost() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final location = locationController.text.trim();

    if (title.isEmpty) {
      AppSnackbar.show('Please enter a post title');
      return;
    }

    if (isSubmitting.value) {
      return;
    }

    isSubmitting.value = true;

    try {
      final response = await _communityForumRepo.createPost(
        title: title,
        description: location.isNotEmpty
            ? '$description\n\nLocation: $location'
            : description,
        tags: tags.toList(),
        imageFile: selectedImage.value == null
            ? null
            : File(selectedImage.value!.path),
      );

      final success = response['success'] == true;
      final message =
          (response['message'] ??
                  (success
                      ? 'Post created successfully'
                      : 'Failed to create post'))
              .toString();

      AppSnackbar.show(message);

      if (!success) {
        return;
      }

      clearForm();
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    tagController.clear();
    tags.clear();
    selectedImage.value = null;
    selectedImageBytes.value = null;
  }
}
