import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/network/respone_handler.dart';
import 'package:kulyx/view_model/Community_forum/group_details_viewmodel.dart';
import 'package:kulyx/widgets/loder.dart';

class GroupDetailsScreen extends GetView<GroupDetailsViewmodel> {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.communityGroupDetails.value;
      final group = response.data?.data;

      if (response.status == Status.LOADING) {
        return Scaffold(body: const Center(child: Loder()));
      }

      if (response.status == Status.ERROR) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                response.message ?? 'Failed to load group details',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      if (group == null) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                response.message ?? 'Group details are not available right now',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      final theme = Theme.of(context);
      final creator = group.createdBy;
      final isJoined = group.isJoined == true;
      final isJoining = controller.isJoining.value;
      final memberCount = group.memberCount;

      final adminName = [creator?.firstName, creator?.lastName]
          .whereType<String>()
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .join(' ');

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _GroupDetailsAppBar(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(11),
                            ),
                            child: (group.image ?? '').isNotEmpty
                                ? Image.network(
                                    group.image!,
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/culinary_tagline.png',
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: -50,
                            child: Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F0E9),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (group.coverImage ?? '').isNotEmpty
                                          ? Image.network(
                                              group.coverImage!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/culinary_tagline.png',
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 50, 12, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name ?? 'Unnamed Group',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                fontFamily: 'Forum',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$memberCount members',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: isJoining
                                    ? null
                                    : controller.joinCurrentGroup,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: isJoined
                                      ? Colors.grey.shade400
                                      : const Color(0xFFEF6A16),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  isJoining
                                      ? 'Processing...'
                                      : (isJoined ? 'Leave' : 'Join'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'About this group',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Forum',
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (group.description ?? '').trim().isNotEmpty
                      ? group.description!
                      : 'This group is intended to connect members with shared interests and experiences.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Member highlights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Forum',
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                _HighlightTile(
                  icon: Icons.home,
                  title: group.status ?? 'Member status unavailable',
                  subtitle: group.groupAdmin?.isNotEmpty == true
                      ? 'Admins: ${group.groupAdmin!.join(', ')}'
                      : 'Role information unavailable',
                ),
                _HighlightTile(
                  icon: Icons.calendar_today_outlined,
                  title: group.createdAt != null
                      ? 'Created on ${_formatDate(group.createdAt!)}'
                      : 'Creation date unavailable',
                  subtitle: (group.groupType ?? '').isNotEmpty
                      ? 'Type: ${group.groupType}'
                      : 'Group type unavailable',
                ),
                _HighlightTile(
                  icon: Icons.people_alt_outlined,
                  title: isJoined ? 'You are a member' : 'Not joined yet',
                  subtitle: 'Tap join to become part of this group',
                ),
                const SizedBox(height: 18),
                Text(
                  'Admin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFF2F2F2),
                      backgroundImage: (creator?.profileImage ?? '').isNotEmpty
                          ? NetworkImage(creator!.profileImage!)
                          : null,
                      child: (creator?.profileImage ?? '').isNotEmpty
                          ? null
                          : const Icon(Icons.person_outline),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adminName.isNotEmpty ? adminName : 'Group owner',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            (creator?.bio ?? '').trim().isNotEmpty
                                ? creator!.bio!
                                : (creator?.username ?? 'Owner'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Owner',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5B6770)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupDetailsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: SizedBox(
              height: 32,
              width: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 24),
              ),
            ),
          ),

          const SizedBox(width: 8),
          const Text(
            'Group Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF6A16),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, size: 20),
                SizedBox(width: 4),
                Text('Add Group', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
