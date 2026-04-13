import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/index.dart';
import 'package:kulyx/features/marketplace/controllers/community_events_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_groups_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_people_controller.dart';
import 'package:kulyx/features/marketplace/controllers/community_posts_controller.dart';

class CommunityForumController extends GetxController {
  final CommunityPostsController postsController;
  final CommunityPeopleController peopleController;
  final CommunityGroupsController groupsController;
  final CommunityEventsController eventsController;

  CommunityForumController({
    required this.postsController,
    required this.peopleController,
    required this.groupsController,
    required this.eventsController,
  });

  final RxString selectedFilter = 'ALL'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  RxBool get isLoadingPosts => postsController.isLoading;
  RxBool get isLoadingMorePosts => postsController.isLoadingMore;
  RxBool get hasMorePosts => postsController.hasMore;
  RxString get postError => postsController.error;
  RxInt get postPage => postsController.page;
  RxList<ForumPost> get allPosts => postsController.items;

  RxBool get isLoadingPeople => peopleController.isLoading;
  RxBool get isLoadingMorePeople => peopleController.isLoadingMore;
  RxBool get hasMorePeople => peopleController.hasMore;
  RxString get peopleError => peopleController.error;
  RxInt get peoplePage => peopleController.page;
  RxList<ForumPerson> get allPeople => peopleController.items;

  RxBool get isLoadingGroups => groupsController.isLoading;
  RxBool get isLoadingMoreGroups => groupsController.isLoadingMore;
  RxBool get hasMoreGroups => groupsController.hasMore;
  RxString get groupError => groupsController.error;
  RxInt get groupPage => groupsController.page;
  RxList<ForumGroup> get allGroups => groupsController.items;

  RxBool get isLoadingEvents => eventsController.isLoading;
  RxBool get isLoadingMoreEvents => eventsController.isLoadingMore;
  RxBool get hasMoreEvents => eventsController.hasMore;
  RxString get eventError => eventsController.error;
  RxInt get eventPage => eventsController.page;
  RxList<ForumEvent> get allEvents => eventsController.items;

  @override
  void onInit() {
    super.onInit();
    refreshVisibleSections();
  }

  Future<void> loadMorePosts() => postsController.loadMore();

  Future<void> loadMorePeople() => peopleController.loadMore();

  Future<void> loadMoreGroups() => groupsController.loadMore();

  Future<void> loadMoreEvents() => eventsController.loadMore();

  Future<void> loadMoreForVisibleSections() async {
    final currentFilter = selectedFilter.value;
    final jobs = <Future<void>>[];

    if (currentFilter == 'ALL' || currentFilter == 'Post') {
      jobs.add(postsController.loadMore());
    }

    if (currentFilter == 'ALL' || currentFilter == 'People') {
      jobs.add(peopleController.loadMore());
    }

    if (currentFilter == 'ALL' || currentFilter == 'Group') {
      jobs.add(groupsController.loadMore());
    }

    if (currentFilter == 'ALL' || currentFilter == 'Event') {
      jobs.add(eventsController.loadMore());
    }

    await Future.wait<void>(jobs);
  }

  Future<void> refreshVisibleSections() async {
    final currentFilter = selectedFilter.value;
    final jobs = <Future<void>>[];

    if (currentFilter == 'ALL') {
      jobs.addAll(<Future<void>>[
        postsController.refreshData(),
        peopleController.refreshData(),
        groupsController.refreshData(),
        eventsController.refreshData(),
      ]);
      await Future.wait<void>(jobs);
      return;
    }

    if (currentFilter == 'Post') {
      await postsController.refreshData();
      return;
    }

    if (currentFilter == 'People') {
      await peopleController.refreshData();
      return;
    }

    if (currentFilter == 'Group') {
      await groupsController.refreshData();
      return;
    }

    if (currentFilter == 'Event') {
      await eventsController.refreshData();
    }
  }

  bool isPostLiked(String postId) => postsController.isLiked(postId);

  Future<void> togglePostLike(String postId) =>
      postsController.toggleLike(postId);

  bool isPostFollowed(String postId) => postsController.isFollowed(postId);

  Future<void> followPostAuthor({
    required String postId,
    required String authorId,
  }) => postsController.followAuthor(postId: postId, authorId: authorId);

  bool isPersonFollowed(String personId) =>
      peopleController.isFollowed(personId);

    Future<void> followOrUnfollowPerson(String personId) =>
      peopleController.followOrUnfollow(personId);

  List<ForumPost> get filteredPosts {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Post') {
      return <ForumPost>[];
    }

    return postsController.filtered(searchQuery.value);
  }

  List<ForumPerson> get filteredPeople {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'People') {
      return <ForumPerson>[];
    }

    return peopleController.filtered(searchQuery.value);
  }

  List<ForumGroup> get filteredGroups {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Group') {
      return <ForumGroup>[];
    }

    return groupsController.filtered(searchQuery.value);
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

  List<ForumEvent> get filteredEvents {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Event') {
      return <ForumEvent>[];
    }

    return eventsController.filtered(searchQuery.value);
  }

  List<ForumEvent> eventsForDisplay(String filter) {
    final events = filteredEvents;
    if (filter == 'ALL') {
      return events.take(2).toList();
    }

    return events;
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
