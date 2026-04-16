import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/model/community_forum/post_details_model.dart';
import 'package:kulyx/view_model/Community_forum/post_details_viewmodel.dart';
import 'package:kulyx/widgets/custom_color.dart';
import 'package:kulyx/widgets/loder.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late final PostDetailsViewModel _vm;
  late final Map<String, dynamic> _arguments;
  bool _didRequest = false;

  @override
  void initState() {
    super.initState();
    _vm = Get.find<PostDetailsViewModel>();
    _arguments =
        (Get.arguments as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didRequest) return;
      _didRequest = true;
      _vm.getPostDetailsApi(_postId);
    });
  }

  String get _postId => _arguments['postId']?.toString() ?? '';

  Data? get _postData => _vm.postDetail.value?.data;

  String get _title =>
      _postData?.title ?? _arguments['postTitle']?.toString() ?? 'Post';

  String get _content => _arguments['postContent']?.toString() ?? '';

  String get _authorName {
    final author = _postData?.createdBy;
    final name = '${author?.firstName ?? ''} ${author?.lastName ?? ''}'.trim();
    if (name.isNotEmpty) return name;

    return _arguments['authorName']?.toString() ?? 'Unknown author';
  }

  String get _authorTitle {
    final roles = _postData?.createdBy?.roles;
    if (roles != null && roles.isNotEmpty) {
      return roles.first;
    }

    return _arguments['authorTitle']?.toString() ?? '';
  }

  String get _authorImage {
    final image = _postData?.createdBy?.profileImage?.toString().trim();
    if (image != null && image.isNotEmpty) return image;

    return _arguments['authorImage']?.toString() ?? '';
  }

  String get _postImage {
    final image = _postData?.image?.trim();
    if (image != null && image.isNotEmpty) return image;

    return _arguments['postImage']?.toString() ?? '';
  }

  List<String> get _tags {
    final apiTags = _postData?.tags;
    if (apiTags != null && apiTags.isNotEmpty) {
      return apiTags.map((tag) => tag.toString()).toList();
    }

    final fallbackTags = _arguments['tags'];
    if (fallbackTags is List) {
      return fallbackTags.map((tag) => tag.toString()).toList();
    }

    return <String>[];
  }

  int get _views => _postData?.views ?? (_arguments['views'] as int? ?? 0);

  int get _likes => _postData?.likes ?? (_arguments['likes'] as int? ?? 0);

  int get _commentsCount =>
      _postData?.commentsCount ?? (_arguments['comments'] as int? ?? 0);

  String get _repostedBy {
    final reposted = _postData?.repostedBy;
    final name = reposted?.username?.trim() ?? '';
    if (name.isNotEmpty) return name;

    return _arguments['repostedBy']?.toString() ?? '';
  }

  String get _dateLabel {
    final createdAt = _postData?.createdAt;
    if (createdAt == null) return 'Unknown date';

    final localDate = createdAt.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = _monthName(localDate.month);
    final year = localDate.year;
    final hour = localDate.hour % 12 == 0 ? 12 : localDate.hour % 12;
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1EF),
      body: SafeArea(
        child: Obx(() {
          if (_vm.isLoading.value && _vm.postDetail.value == null) {
            return const Center(child: Loder());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Post',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: CustomColors.darkGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColors.primaryOrange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  'Add Post ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _PostCard(
                  title: _title,
                  content: _content,
                  authorName: _authorName,
                  authorTitle: _authorTitle,
                  authorImage: _authorImage,
                  postImage: _postImage,
                  repostedBy: _repostedBy,
                  dateLabel: _dateLabel,
                  tags: _tags,
                  views: _views,
                  likes: _likes,
                  comments: _commentsCount,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _monthName(int month) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    if (month < 1 || month > months.length) return '';
    return months[month - 1];
  }
}

class _PostCard extends StatelessWidget {
  final String title;
  final String content;
  final String authorName;
  final String authorTitle;
  final String authorImage;
  final String postImage;
  final String repostedBy;
  final String dateLabel;
  final List<String> tags;
  final int views;
  final int likes;
  final int comments;

  const _PostCard({
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
    required this.postImage,
    required this.repostedBy,
    required this.dateLabel,
    required this.tags,
    required this.views,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    final hasAuthorImage = authorImage.trim().isNotEmpty;
    final hasPostImage = postImage.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (repostedBy.trim().isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF23B36B),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.repeat_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$repostedBy reposted',
                  style: TextStyle(
                    color: CustomColors.textGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Forum',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: hasAuthorImage
                    ? NetworkImage(authorImage)
                    : const AssetImage('assets/icons/person.png')
                          as ImageProvider,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$authorName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Forum',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF242424),
                    ),
                  ),
                  // if (authorTitle.trim().isNotEmpty) ...[
                  //   const SizedBox(height: 2),
                  //   Text(
                  //     authorTitle,
                  //     style: const TextStyle(
                  //       fontSize: 12,
                  //       color: Color(0xFF969696),
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF969696),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              height: 1.1,
              fontFamily: 'Forum',
              fontWeight: FontWeight.w400,
              color: Color(0xFF111111),
            ),
          ),
          if (content.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 20,
                height: 1.42,
                fontFamily: 'Roboto',
                color: Color(0xFF202020),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (hasPostImage) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                postImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E5DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: CustomColors.cardGray,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('$views Views'),
              _buildStatItem('$likes Likes'),
              _buildStatItem('$comments comments'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        color: CustomColors.textGray,
        fontFamily: 'Forum',
      ),
    );
  }
}
