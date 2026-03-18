import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/auth/viewmodels/auth_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu, size: 20, color: Color(0xFF555555)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.restaurant_menu,
                        color: Color(0xFFFF6A00),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'CULINARY',
                        style: TextStyle(
                          color: Color(0xFFFF6A00),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => Text(
                          authViewModel.userName.value.isEmpty
                              ? 'Hi, User'
                              : 'Hi, ${authViewModel.userName.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6A00),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: authViewModel.logout,
                    icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE1E1E1)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for anything',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF555555)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const <Widget>[
                  _CategoryChip(label: 'All', highlighted: true),
                  _CategoryChip(label: 'Groceries & Ingredients'),
                  _CategoryChip(label: 'Kitchen Essentials'),
                  _CategoryChip(label: 'Cookware'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF2D2D2D), Color(0xFF101010)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Discover Culinary Treasures\nfrom Around the World',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Shop unique handpicked ingredients and premium kitchen tools.',
                    style: TextStyle(color: Color(0xFFD8D8D8), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shop by Categories',
              style: TextStyle(
                fontSize: 23,
                color: Color(0xFF262626),
                fontWeight: FontWeight.w400,
                fontFamily: 'Forum',
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: const <Widget>[
                _CategoryCard(icon: Icons.shopping_basket, label: 'Ingredients'),
                _CategoryCard(icon: Icons.local_dining, label: 'Recipes'),
                _CategoryCard(icon: Icons.kitchen, label: 'Equipment'),
                _CategoryCard(icon: Icons.book, label: 'Cookbooks'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFFF6A00) : Colors.white,
        border: Border.all(color: highlighted ? const Color(0xFFFF6A00) : const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: highlighted ? Colors.white : const Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: const Color(0xFFFF6A00), size: 40),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
