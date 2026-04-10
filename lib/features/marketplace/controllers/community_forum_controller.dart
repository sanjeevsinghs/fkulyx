import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class CommunityForumController extends GetxController {
  static const int _pageSize = 10;

  final NetworkApiServices _apiService = NetworkApiServices();
  final RxString selectedFilter = 'ALL'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoadingPosts = false.obs;
  final RxBool isLoadingMorePosts = false.obs;
  final RxBool hasMorePosts = true.obs;
  final RxString postError = ''.obs;
  final RxBool isLoadingPeople = false.obs;
  final RxBool isLoadingMorePeople = false.obs;
  final RxBool hasMorePeople = true.obs;
  final RxString peopleError = ''.obs;
  final RxBool isLoadingGroups = false.obs;
  final RxBool isLoadingMoreGroups = false.obs;
  final RxBool hasMoreGroups = true.obs;
  final RxString groupError = ''.obs;
  final RxInt postPage = 1.obs;
  final RxInt peoplePage = 1.obs;
  final RxInt groupPage = 1.obs;
  final RxList<ForumPost> allPosts = <ForumPost>[].obs;
  final RxList<ForumPerson> allPeople = <ForumPerson>[].obs;
  final RxList<ForumGroup> allGroups = <ForumGroup>[].obs;
  final RxSet<String> likedPostIds = <String>{}.obs;
  final RxSet<String> followedPostIds = <String>{}.obs;
  final RxSet<String> followedPeopleIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCommunityPosts(reset: true);
    initializePeople(reset: true);
    fetchCommunityGroups(reset: true);
  }

  Future<void> fetchCommunityPosts({
    int page = 1,
    int limit = _pageSize,
    bool includeInactive = false,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    bool reset = false,
  }) async {
    if (isLoadingPosts.value || isLoadingMorePosts.value) {
      return;
    }

    if (!reset && !hasMorePosts.value) {
      return;
    }

    if (reset) {
      postPage.value = 1;
      hasMorePosts.value = true;
      isLoadingPosts.value = true;
      postError.value = '';
    } else {
      isLoadingMorePosts.value = true;
    }

    try {
      final uri = Uri.parse(ApiEndpoints.communityPosts).replace(
        queryParameters: <String, String>{
          'page': '$page',
          'limit': '$limit',
          'includeInactive': '$includeInactive',
          'sortBy': sortBy,
          'sortOrder': sortOrder,
        },
      );

      final response = await _apiService.getApi(uri.toString());
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected posts response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final items = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load posts',
        );
      }

      final posts = items
          .whereType<Map<String, dynamic>>()
          .map(ForumPost.fromJson)
          .toList();

      if (reset) {
        allPosts.assignAll(posts);
      } else {
        allPosts.addAll(posts);
      }

      hasMorePosts.value = posts.length >= limit;
      postPage.value = page;
      _syncPostInteractionState(allPosts);
    } catch (e) {
      postError.value = e.toString();
      if (reset) {
        allPosts.clear();
        likedPostIds.clear();
        followedPostIds.clear();
      }
    } finally {
      if (reset) {
        isLoadingPosts.value = false;
      } else {
        isLoadingMorePosts.value = false;
      }
    }
  }

  Future<void> initializePeople({
    int page = 1,
    int limit = _pageSize,
    bool reset = false,
  }) async {
    if (isLoadingPeople.value || isLoadingMorePeople.value) {
      return;
    }

    if (!reset && !hasMorePeople.value) {
      return;
    }

    if (reset) {
      peoplePage.value = 1;
      hasMorePeople.value = true;
      isLoadingPeople.value = true;
      peopleError.value = '';
    } else {
      isLoadingMorePeople.value = true;
    }

    try {
      final uri = Uri.parse(
        ApiEndpoints.usersLimited,
      ).replace(
        queryParameters: <String, String>{
          'limit': '$limit',
          'page': '$page',
        },
      );

      final response = await _apiService.getApi(uri.toString());
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected users response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final items = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load users',
        );
      }

      final people = items
          .whereType<Map<String, dynamic>>()
          .map(ForumPerson.fromJson)
          .toList();

      if (reset) {
        allPeople.assignAll(people);
      } else {
        allPeople.addAll(people);
      }

      hasMorePeople.value = people.length >= limit;
      peoplePage.value = page;
      _syncPeopleInteractionState(allPeople);
    } catch (e) {
      peopleError.value = e.toString();
      if (reset) {
        allPeople.clear();
        followedPeopleIds.clear();
      }
    } finally {
      if (reset) {
        isLoadingPeople.value = false;
      } else {
        isLoadingMorePeople.value = false;
      }
    }
  }

  Future<void> fetchCommunityGroups({
    int page = 1,
    int limit = _pageSize,
    bool includeInactive = false,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    bool reset = false,
  }) async {
    if (isLoadingGroups.value || isLoadingMoreGroups.value) {
      return;
    }

    if (!reset && !hasMoreGroups.value) {
      return;
    }

    if (reset) {
      groupPage.value = 1;
      hasMoreGroups.value = true;
      isLoadingGroups.value = true;
      groupError.value = '';
    } else {
      isLoadingMoreGroups.value = true;
    }

    try {
      final uri = Uri.parse(ApiEndpoints.communityGroups).replace(
        queryParameters: <String, String>{
          'page': '$page',
          'limit': '$limit',
          'includeInactive': '$includeInactive',
          'sortBy': sortBy,
          'sortOrder': sortOrder,
        },
      );

      final response = await _apiService.getApi(uri.toString());
      if (response is! Map<String, dynamic>) {
        throw Exception('Unexpected groups response format');
      }

      final success = response['success'] == true;
      final data = response['data'] as Map<String, dynamic>?;
      final items = (data?['items'] as List?) ?? const [];

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Failed to load groups',
        );
      }

      final groups = items
          .whereType<Map<String, dynamic>>()
          .map(ForumGroup.fromJson)
          .toList();

      if (reset) {
        allGroups.assignAll(groups);
      } else {
        allGroups.addAll(groups);
      }

      hasMoreGroups.value = groups.length >= limit;
      groupPage.value = page;
    } catch (e) {
      groupError.value = e.toString();
      if (reset) {
        allGroups.clear();
      }
    } finally {
      if (reset) {
        isLoadingGroups.value = false;
      } else {
        isLoadingMoreGroups.value = false;
      }
    }
  }

  Future<void> loadMorePosts() async {
    await fetchCommunityPosts(
      page: postPage.value + 1,
      limit: _pageSize,
      reset: false,
    );
  }

  Future<void> loadMorePeople() async {
    await initializePeople(
      page: peoplePage.value + 1,
      limit: _pageSize,
      reset: false,
    );
  }

  Future<void> loadMoreGroups() async {
    await fetchCommunityGroups(
      page: groupPage.value + 1,
      limit: _pageSize,
      reset: false,
    );
  }

  Future<void> loadMoreForVisibleSections() async {
    final currentFilter = selectedFilter.value;
    final shouldLoadPosts = currentFilter == 'ALL' || currentFilter == 'Post';
    final shouldLoadPeople =
        currentFilter == 'ALL' || currentFilter == 'People';
    final shouldLoadGroups = currentFilter == 'ALL' || currentFilter == 'Group';

    if (shouldLoadPosts) {
      await loadMorePosts();
    }

    if (shouldLoadPeople) {
      await loadMorePeople();
    }

    if (shouldLoadGroups) {
      await loadMoreGroups();
    }
  }

  void _syncPostInteractionState(List<ForumPost> posts) {
    likedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isLiked).map((post) => post.id));

    followedPostIds
      ..clear()
      ..addAll(posts.where((post) => post.isFollow).map((post) => post.id));
  }

  bool isPostLiked(String postId) => likedPostIds.contains(postId);

  void togglePostLike(String postId) {
    if (likedPostIds.contains(postId)) {
      likedPostIds.remove(postId);
      return;
    }

    likedPostIds.add(postId);
  }

  bool isPostFollowed(String postId) => followedPostIds.contains(postId);

  void togglePostFollow(String postId) {
    if (followedPostIds.contains(postId)) {
      followedPostIds.remove(postId);
      return;
    }

    followedPostIds.add(postId);
  }

  bool isPersonFollowed(String personId) =>
      followedPeopleIds.contains(personId);

  void _syncPeopleInteractionState(List<ForumPerson> people) {
    followedPeopleIds
      ..clear()
      ..addAll(
        people.where((person) => person.isFollow).map((person) => person.id),
      );
  }

  void togglePersonFollow(String personId) {
    if (followedPeopleIds.contains(personId)) {
      followedPeopleIds.remove(personId);
      return;
    }

    followedPeopleIds.add(personId);
  }

  List<ForumPost> get filteredPosts {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Post') {
      return <ForumPost>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return allPosts;
    }

    return allPosts.where((post) {
      return post.title.toLowerCase().contains(query) ||
          post.authorName.toLowerCase().contains(query) ||
          post.safeTags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<ForumPerson> get filteredPeople {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'People') {
      return <ForumPerson>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return allPeople;
    }

    return allPeople.where((person) {
      return person.name.toLowerCase().contains(query) ||
          person.role.toLowerCase().contains(query) ||
          person.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<ForumGroup> get filteredGroups {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Group') {
      return <ForumGroup>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return allGroups;
    }

    return allGroups.where((group) {
      return group.name.toLowerCase().contains(query) ||
          group.category.toLowerCase().contains(query) ||
          group.location.toLowerCase().contains(query);
    }).toList();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<ForumPost> postsForDisplay(String filter) {
    final posts = filteredPosts;
    if (filter == 'ALL') {
      return posts.take(2).toList();
    }

    return posts;
  }

  List<ForumPerson> peopleForDisplay(String filter) {
    final people = filteredPeople;
    if (filter == 'ALL') {
      return people.take(2).toList();
    }

    return people;
  }

  List<ForumGroup> groupsForDisplay(String filter) {
    final groups = filteredGroups;
    if (filter == 'ALL') {
      return groups.take(2).toList();
    }

    return groups;
  }

  bool get hasMoreGroupsForGroupFilter {
    if (selectedFilter.value != 'Group') {
      return false;
    }

    return hasMoreGroups.value;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
