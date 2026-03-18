import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/dashboard/viewmodels/dashboard_viewmodel.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: viewModel.refreshDashboard,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
              () => viewModel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.value.isNotEmpty
                      ? Center(child: Text(viewModel.error.value))
                      : Column(
                          children: viewModel.stats
                              .map((stat) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _StatCard(
                                      title: stat.title,
                                      value: stat.value,
                                      icon: stat.icon,
                                    ),
                                  ))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF6A00)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFF6A00),
            ),
          ),
        ],
      ),
    );
  }
}
