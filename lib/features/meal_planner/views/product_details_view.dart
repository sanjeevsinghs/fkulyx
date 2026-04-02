import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/product_details_controller.dart';
import 'package:kulyx/features/meal_planner/views/widgets/product_details_common.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade500),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
          onPressed: Get.back,
        ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 130, 0),
          child: const Text(
            'Product Details',
            style: TextStyle(
              fontFamily: 'Forum',
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6A00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final Map<String, dynamic> product = controller.productData;
        final List<Map<String, dynamic>> images = controller.images;
        final String displayImage = controller.displayImage;

        return ListView(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 28),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.08,
                    child: displayImage.isNotEmpty
                        ? Image.network(
                            displayImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 54,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (BuildContext context, int index) {
                      final String thumb = controller.valueAsString(
                        images[index]['url'],
                      );
                      final bool selected =
                          index == controller.selectedImageIndex.value;

                      return GestureDetector(
                        onTap: () => controller.selectImage(index),
                        child: Container(
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFFFF6A00)
                                  : Colors.grey.shade300,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            thumb,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(color: Colors.grey[200]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Text(
                  '${controller.soldCount} units sold',
                  style: const TextStyle(
                    color: Color(0xFFFF6A00),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.share, size: 17, color: Color(0xFFFF6A00)),
                const SizedBox(width: 4),
                const Text(
                  'Share',
                  style: TextStyle(
                    color: Color(0xFFFF6A00),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              controller.name,
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: <Widget>[
                Text(
                  controller.avgRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                ProductRatingStars(rating: controller.avgRating, size: 18),
                const SizedBox(width: 7),
                Text(
                  '(${controller.reviewCount} ratings)',
                  style: const TextStyle(color: Colors.black54),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: controller.stock > 0
                        ? const Color(0xFF2E9F49)
                        : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    controller.stock > 0 ? '✓ In Stock' : 'Out of Stock',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Text(
                  'Seller: ${controller.sellerName}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  'Product ID: ${_shortProductId(controller.productId)}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Text(
                  _formatPrice('DA', controller.price),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _formatPrice('DA', controller.mrp),
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${controller.discount}%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Quantity',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: controller.selectedQuantity.value,
                    underline: const SizedBox.shrink(),
                    items: List<int>.generate(10, (int i) => i + 1)
                        .map(
                          (int quantity) => DropdownMenuItem<int>(
                            value: quantity,
                            child: Text(quantity.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        controller.selectQuantity(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (controller.colorValues.isNotEmpty) ...<Widget>[
              const Text(
                'Colours:',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: controller.colorValues.map((dynamic entry) {
                  final Map<String, dynamic> map = entry is Map<String, dynamic>
                      ? entry
                      : <String, dynamic>{};
                  final String label = controller.valueAsString(
                    map['displayValue'],
                  );

                  return Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label.isNotEmpty
                          ? label.characters.first.toUpperCase()
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
            if (controller.sizeValues.isNotEmpty) ...<Widget>[
              const Text(
                'Size:',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                children: controller.sizeValues.map((dynamic entry) {
                  final Map<String, dynamic> map = entry is Map<String, dynamic>
                      ? entry
                      : <String, dynamic>{};
                  final String label = controller.valueAsString(
                    map['displayValue'],
                  );
                  final bool selected = label == controller.selectedSize.value;

                  return GestureDetector(
                    onTap: () => controller.selectSize(label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFFFEEE1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFFF6A00)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFFF6A00)
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
            const Text(
              'BEST OFFERS FOR YOU!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 9),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Get 5% off site-wide',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'No minimum spend',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Apply >',
                          style: TextStyle(
                            color: Color(0xFFFF6A00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Get DA30 off on your first order',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Min. DA150',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Apply >',
                          style: TextStyle(
                            color: Color(0xFFFF6A00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF6A00),
                      side: const BorderSide(color: Color(0xFFFF6A00)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Chat with Seller',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Product Details',
              style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...controller.variantAttrs.map((dynamic entry) {
              final Map<String, dynamic> map = entry is Map<String, dynamic>
                  ? entry
                  : <String, dynamic>{};
              return ProductSpecRow(
                label: controller.valueAsString(map['attributeName']),
                value: controller.valueAsString(map['displayValue']),
              );
            }),
            if (controller.variantAttrs.isEmpty)
              ProductSpecRow(
                label: 'Description',
                value: controller.valueAsString(
                  product['description'],
                  fallback: '-',
                ),
              ),
            const SizedBox(height: 14),
            const Text(
              'About Product',
              style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (controller.aboutList.isNotEmpty)
              ...controller.aboutList.map(
                (dynamic item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('•  ', style: TextStyle(fontSize: 17)),
                      Expanded(
                        child: Text(
                          controller.valueAsString(item),
                          style: const TextStyle(fontSize: 14, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('•  ', style: TextStyle(fontSize: 17)),
                    Expanded(
                      child: Text(
                        controller.valueAsString(
                          product['description'],
                          fallback: 'No additional details available.',
                        ),
                        style: const TextStyle(fontSize: 14, height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            const Text(
              'Product information',
              style: TextStyle(fontSize: 34, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            const Text(
              'Technical Details',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...controller.specifications.map((dynamic entry) {
              final Map<String, dynamic> map = entry is Map<String, dynamic>
                  ? entry
                  : <String, dynamic>{};
              return Column(
                children: <Widget>[
                  ProductSpecRow(
                    label: controller.valueAsString(map['key']),
                    value: controller.valueAsString(map['value']),
                  ),
                  Divider(color: Colors.grey.shade300, height: 8),
                ],
              );
            }),
            if (controller.specifications.isEmpty)
              ProductSpecRow(
                label: 'Brand',
                value: controller.valueAsString(
                  product['brandId'],
                  fallback: '-',
                ),
              ),
            const SizedBox(height: 14),
            const Text('Product Review', style: TextStyle(fontSize: 33)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    controller.avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProductRatingStars(rating: controller.avgRating, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    'Customer Rating (${controller.reviewCount})',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            ...controller.ratingRows.map((List<dynamic> row) {
              final String star = row[0].toString();
              final int count = row[1] as int;
              final int safeTotal = controller.reviewCount == 0
                  ? 1
                  : controller.reviewCount;
              final double ratio = count / safeTotal;
              final int percent = controller.reviewCount == 0
                  ? 0
                  : ((count / controller.reviewCount) * 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 70,
                      child: Text(
                        '$star ★★★★★'.substring(0, 6),
                        style: const TextStyle(color: Color(0xFFE6B422)),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          value: ratio,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 74,
                      child: Text(
                        '$percent% ($count)',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),
            Text(
              'Customer Feedback (${controller.reviews.length})',
              style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 9),
            if (controller.reviews.isEmpty)
              const Text(
                'No reviews yet',
                style: TextStyle(color: Colors.black54),
              )
            else
              ...controller.reviews.map((dynamic entry) {
                final Map<String, dynamic> review =
                    entry is Map<String, dynamic> ? entry : <String, dynamic>{};
                final Map<String, dynamic> user =
                    review['user'] is Map<String, dynamic>
                    ? review['user'] as Map<String, dynamic>
                    : <String, dynamic>{};
                final String username = controller.valueAsString(
                  user['username'],
                  fallback: 'User',
                );
                final String text = controller.valueAsString(
                  review['comment'],
                  fallback: '-',
                );
                final double rate = controller.valueAsDouble(
                  review['rating'],
                  fallback: 0,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 19,
                            backgroundColor: Colors.grey.shade300,
                            child: Text(
                              username.characters.first.toUpperCase(),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            username,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ProductRatingStars(rating: rate),
                      const SizedBox(height: 4),
                      Text(text, style: const TextStyle(height: 1.4)),
                    ],
                  ),
                );
              }),
          ],
        );
      }),
    );
  }

  String _formatPrice(String currency, double value) {
    final int decimals = value % 1 == 0 ? 0 : 2;
    return '$currency${value.toStringAsFixed(decimals)}';
  }

  String _shortProductId(String productId) {
    if (productId.isEmpty) return '-';
    final int end = productId.length < 8 ? productId.length : 8;
    return productId.substring(0, end).toUpperCase();
  }
}
