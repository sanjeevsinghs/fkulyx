import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/controllers/community_forum_controller.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/custom_text_field.dart';
import 'package:kulyx/widgets/images.dart';
import 'package:kulyx/features/marketplace/widgets/community_header_widget.dart';
import 'package:kulyx/features/marketplace/widgets/community_category_cards_section.dart';
import 'package:kulyx/features/marketplace/widgets/community_filter_chips_section.dart';
import 'package:kulyx/features/marketplace/widgets/forum_people_card_widget.dart';
import 'package:kulyx/features/marketplace/widgets/forum_post_card_widget.dart';

class MarketplaceView extends GetView<CommunityForumController> {
  const MarketplaceView({super.key});

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
            // Header
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

            // Search
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

            // Category Cards
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

            // Filter Chips
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
                final posts = controller.filteredPosts;
                final people = controller.filteredPeople;

                final showPosts = selected == 'ALL' || selected == 'Post';
                final showPeople = selected == 'ALL' || selected == 'People';

                if (!showPosts && !showPeople) {
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

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (showPosts) ...[
                      _buildSectionHeader(title: 'Posts'),
                      const SizedBox(height: 12),
                      if (posts.isEmpty)
                        _buildEmptyState('No posts found')
                      else
                        ...posts.map(
                          (post) => ForumPostCardWidget(
                            postTitle: post.title,
                            postImage: post.image,
                            tags: [post.category, 'bitcoin', 'crypto'],
                            authorName: post.authorName,
                            authorTitle: post.authorTitle,
                            authorImage: post.authorImage,
                            views: post.views,
                            likes: post.likes,
                            comments: post.comments,
                            onLikeTap: () {},
                            onFollowTap: () {},
                            onCardTap: () {},
                          ),
                        ),
                    ],
                    if (showPeople) ...[
                      if (showPosts) const SizedBox(height: 10),
                      _buildSectionHeader(title: 'People'),
                      const SizedBox(height: 12),
                      if (people.isEmpty)
                        _buildEmptyState('No people found')
                      else
                        ...people.map(
                          (person) => ForumPeopleCardWidget(
                            name: person.name,
                            role: person.role,
                            location: person.location,
                            image: person.image,
                            tags: person.tags,
                            isFollowing: false,
                            onFollowTap: () {},
                            onCardTap: () {},
                          ),
                        ),
                    ],
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title}) {
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
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: CustomColors.primaryOrange, width: 1),
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
}
