import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/auth/viewmodels/auth_viewmodel.dart';

class MealPlannerView extends StatelessWidget {
  const MealPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();

    return Container(
      color: const Color(0xFFFFFEFE),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.menu,
                      size: 20,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Image(
                    image: AssetImage('assets/images/culinary_tagline.png'),
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6A00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed:(){},
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color:Colors.black, width: 1),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for anything',
                    hintStyle: TextStyle(fontSize: 16, color: Color(0xFF999999)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    suffixIcon: Icon(Icons.search, color: Colors.black, size: 20),
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
                  _CategoryCard(
                    icon: Icons.shopping_basket,
                    label: 'Ingredients',
                  ),
                  _CategoryCard(icon: Icons.local_dining, label: 'Recipes'),
                  _CategoryCard(icon: Icons.kitchen, label: 'Equipment'),
                  _CategoryCard(icon: Icons.book, label: 'Cookbooks'),
                ],
              ),
            ],
          ),
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
        border: Border.all(
          color: highlighted
              ? const Color(0xFFFF6A00)
              : const Color(0xFFE0E0E0),
        ),
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
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
