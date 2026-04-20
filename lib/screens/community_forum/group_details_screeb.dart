import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/network/respone_handler.dart';
import 'package:kulyx/view_model/Community_forum/group_details_viewmodel.dart';

class GroupDetailsScreen extends GetView<GroupDetailsViewmodel> {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.communityGroupDetails.value;

      if (response.status == Status.LOADING) {
        return const Scaffold(
          appBar: _GroupDetailsAppBar(),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (response.status == Status.ERROR) {
        return Scaffold(
          appBar: const _GroupDetailsAppBar(),
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

      final group = response.data?.data?.member?.groupId;
      final creator = response.data?.data?.member?.groupId;

      return Scaffold(
        appBar: const _GroupDetailsAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((group?.coverImage ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    group!.coverImage!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderBanner(),
                  ),
                )
              else
                _placeholderBanner(),
              const SizedBox(height: 16),
              Text(
                group?.name ?? 'Group',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Type: ${group?.groupType ?? 'N/A'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                group?.description ?? 'No description available',
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 16),
              Text(
                'Joined: ${response.data?.data?.isJoined == true ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: 14),
              ),
              if ((creator?.name ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Created in: ${creator?.name}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _placeholderBanner() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.groups_2_outlined, size: 44),
    );
  }
}

class _GroupDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _GroupDetailsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Group Details'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
