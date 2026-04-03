import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/lms/models/treding_product_dataModel.dart'
    as lms_model;
import 'package:kulyx/features/lms/viewmodels/lms_viewmodel.dart';
import 'package:kulyx/widgets/loder.dart';

class LmsView extends StatelessWidget {
  const LmsView({super.key});

  String _priceText(double? price) {
    if (price == null) return 'DA0';
    return 'DA${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)}';
  }

  String _mrpText(int? mrp) {
    if (mrp == null) return '';
    return 'DA$mrp';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<TrendingProductsViewModel>()
        ? Get.find<TrendingProductsViewModel>()
        : Get.put(TrendingProductsViewModel());

    return Container(
      color: const Color.fromARGB(1, 225, 225, 225),
      child: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Trending Products',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.loadMoreTrendingProducts,
                          child: const Text(
                            'Show More',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Error message at top if any
                  if (controller.error.value.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Error: ${controller.error.value}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  // Products Grid or Empty
                  if (controller.products.isEmpty &&
                      !controller.isLoading.value)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.error.value.isNotEmpty
                              ? 'Failed to load products'
                              : 'No products found',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator.noSpinner(
                        onRefresh: controller.refreshPage,
                        child: GridView.builder(
                          itemCount: controller.products.length,
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 280,
                              ),
                          itemBuilder: (context, index) {
                            final lms_model.Product item =
                                controller.products[index];
                            final lms_model.Variant? primaryVariant =
                                item.variants != null &&
                                    item.variants!.isNotEmpty
                                ? item.variants!.first
                                : null;
                            final imageUrl =
                                primaryVariant?.images != null &&
                                    primaryVariant!.images!.isNotEmpty
                                ? (primaryVariant.images!.first.url ?? '')
                                : '';
                            final category = item.category?.name ?? 'Category';
                            final soldCount =
                                item.totalUnitsSold ??
                                item.soldCount ??
                                primaryVariant?.soldCount ??
                                0;
                            final rating = (item.averageRating ?? 0)
                                .toDouble()
                                .clamp(0, 5);
                            final reviewCount = item.reviewCount ?? 0;
                            final price = primaryVariant?.price?.toDouble();
                            final mrp = primaryVariant?.mrp?.toInt();

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AspectRatio(
                                        aspectRatio: 1.3,
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      color:
                                                          Colors.grey.shade200,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              )
                                            : Container(
                                                color: Colors.grey.shade200,
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            category,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF585757),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        if (soldCount > 0)
                                          Text(
                                            '$soldCount units sold',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFFF15B2A),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.name ?? 'Unnamed Product',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        ...List.generate(5, (starIndex) {
                                          final isFilled =
                                              starIndex < rating.floor();
                                          final isHalf =
                                              starIndex == rating.floor() &&
                                              rating % 1 >= 0.5;

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 1,
                                            ),
                                            child: Icon(
                                              isFilled
                                                  ? Icons.star
                                                  : isHalf
                                                  ? Icons.star_half
                                                  : Icons.star_outline,
                                              size: 12,
                                              color: const Color(0xFFFFBF00),
                                            ),
                                          );
                                        }),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${rating.toStringAsFixed(1)} ($reviewCount)',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF8D8D8D),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          _priceText(price),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF232323),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (mrp != null &&
                                            price != null &&
                                            mrp > price)
                                          Text(
                                            _mrpText(mrp),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF999999),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        const Spacer(),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6A00),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Loder(),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
