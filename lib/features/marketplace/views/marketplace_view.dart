import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/viewmodels/marketplace_viewmodel.dart';

class MarketplaceView extends StatelessWidget {
  const MarketplaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketplaceViewModel viewModel = Get.find<MarketplaceViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Market Place',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E4E4)),
              ),
              child: TextField(
                onChanged: viewModel.search,
                enableInteractiveSelection: false,
                contextMenuBuilder: (_, _) => const SizedBox.shrink(),
                decoration: const InputDecoration(
                  hintText: 'Search products',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => viewModel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.value.isNotEmpty
                      ? Center(child: Text(viewModel.error.value))
                      : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.92,
                          children: viewModel.filteredProducts
                              .map((product) => _ProductCard(
                                    name: product.name,
                                    price: product.price,
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.name, required this.price});

  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/images/meal_planer_shop_now.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              color: Color(0xFFFF6A00),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
