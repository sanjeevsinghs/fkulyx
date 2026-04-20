import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/controllers/community_forum_controller.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/view_model/Community_forum/join_group_viewmodel.dart';
import 'package:kulyx/features/marketplace/widgets/community_category_cards_section.dart';
import 'package:kulyx/features/marketplace/widgets/community_filter_chips_section.dart';
import 'package:kulyx/features/marketplace/widgets/community_header_widget.dart';
import 'package:kulyx/features/marketplace/widgets/forum_event_card_widget.dart';
import 'package:kulyx/features/marketplace/widgets/forum_group_card_widget.dart';
import 'package:kulyx/features/marketplace/widgets/forum_people_card_widget.dart';
import 'package:kulyx/features/marketplace/widgets/forum_post_card_widget.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/custom_text_field.dart';
import 'package:kulyx/widgets/images.dart';
import 'package:kulyx/widgets/loder.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class MarketplaceView extends GetView<CommunityForumController> {
  const MarketplaceView({super.key});

  JoinGroupViewmodel get _joinGroupVm => Get.put(JoinGroupViewmodel());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isCompact = width < 360;

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommunityHeaderWidget(
              logoImage: const Image(
                image: AssetImage(AssetsImages.culinaryTagline),
                height: 34,
                fit: BoxFit.contain,
              ),
              onMenuPressed: null,
              onCartPressed: null,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomSearchField(
                hintText: 'Search for anything',
                controller: controller.searchController,
                readOnly: false,
                onSearchPressed: null,
                onChanged: controller.onSearchChanged,
              ),
            ),
            const SizedBox(height: 24),
            CommunityCategoryCardsSection(
              newestIcon: const Icon(
                Icons.new_releases_outlined,
                color: CustomColors.primaryOrange,
                size: 18,
              ),
              popularIcon: Image.asset(
                AssetsImages.comPopularIcon,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
              ),
              onNewestTap: null,
              onPopularTap: null,
              compact: isCompact,
            ),
            const SizedBox(height: 16),
            Obx(
              () => CommunityFilterChipsSection(
                selectedFilter: controller.selectedFilter.value,
                onFilterSelected: controller.selectFilter,
                compact: isCompact,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final selected = controller.selectedFilter.value;
                final posts = controller.postsForDisplay(selected);
                final people = controller.peopleForDisplay(selected);
                final groups = controller.groupsForDisplay(selected);
                final events = controller.eventsForDisplay(selected);

                final showPosts = selected == 'ALL' || selected == 'Post';
                final showPeople = selected == 'ALL' || selected == 'People';
                final showGroups = selected == 'ALL' || selected == 'Group';
                final showEvents = selected == 'ALL' || selected == 'Event';
                final isAllFilter = selected == 'ALL';
                final showViewAll = isAllFilter;
                final hasNoVisibleSections =
                    !showPosts && !showPeople && !showGroups && !showEvents;

                final showAllInitialLoader =
                    isAllFilter &&
                    controller.allPosts.isEmpty &&
                    controller.allPeople.isEmpty &&
                    controller.allGroups.isEmpty &&
                    controller.allEvents.isEmpty &&
                    (controller.isLoadingPosts.value ||
                        controller.isLoadingPeople.value ||
                        controller.isLoadingGroups.value ||
                        controller.isLoadingEvents.value);

                if (hasNoVisibleSections) {
                  return Center(
                    child: Text(
                      'No content available for this filter',
                      style: TextStyle(
                        color: CustomColors.textGray,
                        fontFamily: 'Forum',
                      ),
                    ),
                  );
                }

                if (showAllInitialLoader) {
                  return const Center(child: Loder());
                }

                final listContent = ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (showPosts) ...[
                      if (isAllFilter) ...[
                        _buildSectionHeader(
                          title: 'Posts',
                          showViewAll: showViewAll,
                          onViewAllTap: () => controller.selectFilter('Post'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (controller.postError.value.isNotEmpty)
                        _buildEmptyState('Unable to load posts right now')
                      else if (posts.isEmpty)
                        _buildEmptyState('No posts found')
                      else
                        ...posts.map(
                          (post) => ForumPostCardWidget(
                            postTitle: post.title,
                            postImage: post.image,
                            repostedBy: post.repostedBy,
                            tags: post.safeTags,
                            authorName: post.authorName,
                            authorTitle: post.authorTitle,
                            authorImage: post.authorImage,
                            views: post.views,
                            likes: post.likes,
                            comments: post.comments,
                            isLiked: controller.isPostLiked(post.id),
                            isFollowing: controller.isPostFollowed(post.id),
                            onLikeTap: () => controller.togglePostLike(post.id),
                            onFollowTap: () => controller.followPostAuthor(
                              postId: post.id,
                              authorId: post.createdBy,
                            ),
                            onCardTap: () {
                              Get.toNamed(
                                AppRoutes.postDetailsScreen,
                                arguments: {
                                  'postId': post.id,
                                  'postTitle': post.title,
                                  'postContent': post.content,
                                  'postImage': post.image,
                                  'tags': post.safeTags,
                                  'repostedBy': post.repostedBy,
                                  'authorName': post.authorName,
                                  'authorTitle': post.authorTitle,
                                  'authorImage': post.authorImage,
                                  'views': post.views,
                                  'likes': post.likes,
                                  'comments': post.comments,
                                  'isLiked': controller.isPostLiked(post.id),
                                  'isFollowing': controller.isPostFollowed(
                                    post.id,
                                  ),
                                },
                              );
                            },
                          ),
                        ),
                    ],
                    if (showPeople) ...[
                      if (showPosts) const SizedBox(height: 10),
                      if (isAllFilter) ...[
                        _buildSectionHeader(
                          title: 'People',
                          showViewAll: showViewAll,
                          onViewAllTap: () => controller.selectFilter('People'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (controller.peopleError.value.isNotEmpty)
                        _buildEmptyState('Unable to load people right now')
                      else if (people.isEmpty)
                        _buildEmptyState('No people found')
                      else
                        ...people.map(
                          (person) => ForumPeopleCardWidget(
                            name: person.name,
                            role: person.role,
                            location: person.location,
                            image: person.image,
                            tags: person.tags,
                            isFollowing: controller.isPersonFollowed(person.id),
                            onFollowTap: () =>
                                controller.followOrUnfollowPerson(person.id),
                            onCardTap: () {
                              Get.toNamed(
                                AppRoutes.personDetailsScreen,
                                arguments: {
                                  'personId': person.id,
                                  'name': person.name,
                                  'role': person.role,
                                  'image': person.image,
                                  'isFollowing': controller.isPersonFollowed(
                                    person.id,
                                  ),
                                },
                              );
                            },
                          ),
                        ),
                    ],
                    if (showGroups) ...[
                      if (showPosts || showPeople) const SizedBox(height: 10),
                      if (isAllFilter) ...[
                        _buildSectionHeader(
                          title: 'Groups',
                          showViewAll: showViewAll,
                          onViewAllTap: () => controller.selectFilter('Group'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (controller.groupError.value.isNotEmpty)
                        _buildEmptyState('Unable to load groups right now')
                      else if (groups.isEmpty)
                        _buildEmptyState('No groups found')
                      else
                        ...groups.map(
                          (group) => Obx(() {
                            final joinedState = _joinGroupVm
                                .joinedStateForGroup(group.id, group.isJoined);

                            return ForumGroupCardWidget(
                              name: group.name,
                              groupType: group.groupType,
                              location: group.location,
                              description: group.description,
                              image: group.image,
                              isJoined: joinedState,
                              onJoinTap: () async {
                                final response = await _joinGroupVm
                                    .fetchJoinGroupData(group.id);
                                final latestJoined =
                                    response?.data?.isJoined ??
                                    _joinGroupVm.joinedStateForGroup(
                                      group.id,
                                      group.isJoined,
                                    );
                                final apiMessage = response?.message?.trim();
                                AppSnackbar.show(
                                  (apiMessage != null && apiMessage.isNotEmpty)
                                      ? '$apiMessage | isJoined: $latestJoined'
                                      : 'isJoined: $latestJoined',
                                );
                              },
                              onCardTap: () {
                                Get.toNamed(
                                  AppRoutes.groupDetailsScreen,
                                  arguments: {'groupId': group.id},
                                  
                                );
                                // AppSnackbar.show('Group id: ${group.id}');
                              },
                            );
                          }),
                        ),
                    ],
                    if (showEvents) ...[
                      if (showPosts || showPeople || showGroups)
                        const SizedBox(height: 10),
                      if (isAllFilter) ...[
                        _buildSectionHeader(
                          title: 'Events',
                          showViewAll: showViewAll,
                          onViewAllTap: () => controller.selectFilter('Event'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (controller.eventError.value.isNotEmpty)
                        _buildEmptyState('Unable to load events right now')
                      else if (events.isEmpty)
                        _buildEmptyState('No events found')
                      else
                        ...events.map(
                          (event) => ForumEventCardWidget(
                            title: event.name,
                            coverImage: event.coverImage,
                            dateLabel: event.startLabel,
                            locationLabel: event.locationText,
                            description: event.description,
                            attendeeCount: event.attendeeCount,
                            onCardTap: () {
                              Get.toNamed(
                                AppRoutes.eventDetailsScreen,
                                arguments: {
                                  'eventId': event.id,
                                  'eventName': event.name,
                                  'coverImage': event.coverImage,
                                  'dateLabel': event.startLabel,
                                  'addressLine': event.location.address,
                                  'venueLine': event.locationText,
                                  'description': event.description,
                                  'attendeeCount': event.attendeeCount,
                                  'hostName': 'Yasin Youcef',
                                  'speakerRole':
                                      'Certified Yoga Ther.\nEducator | Keynote',
                                  'speakerFollowers': 196,
                                },
                              );
                            },
                          ),
                        ),
                    ],
                    if (!isAllFilter &&
                        showPosts &&
                        controller.isLoadingMorePosts.value)
                      _buildBottomLoader(verticalPadding: 16),
                    if (!isAllFilter &&
                        showPeople &&
                        controller.isLoadingMorePeople.value)
                      _buildBottomLoader(verticalPadding: 8),
                    if (!isAllFilter &&
                        showGroups &&
                        controller.isLoadingMoreGroups.value)
                      _buildBottomLoader(verticalPadding: 8),
                    if (!isAllFilter &&
                        showEvents &&
                        controller.isLoadingMoreEvents.value)
                      _buildBottomLoader(verticalPadding: 8),
                    const SizedBox(height: 10),
                  ],
                );

                final contentWithRefresh = RefreshIndicator(
                  onRefresh: controller.refreshVisibleSections,
                  child: listContent,
                );

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 120) {
                      controller.loadMoreForVisibleSections();
                    }

                    return false;
                  },
                  child: isAllFilter ? listContent : contentWithRefresh,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool showViewAll,
    required VoidCallback onViewAllTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: CustomColors.darkGray,
              fontFamily: 'Forum',
              height: 1,
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: CustomColors.primaryOrange,
                    width: 1,
                  ),
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.primaryOrange,
                    fontFamily: 'Forum',
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: CustomColors.textGray,
            fontSize: 16,
            fontFamily: 'Forum',
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLoader({required double verticalPadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: const Center(child: Loder()),
    );
  }
}
