import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';
import 'package:kulyx/features/meal_planner/viewmodels/index.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/widgets/app_snackbar.dart';
import 'package:kulyx/widgets/images.dart';

class TrendingCard extends GetView<MealPlannerUiController> {
  const TrendingCard({super.key, required this.item, this.onTap});

  final TrendingProductModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String? badge = item.badgeLabel;

    return Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppSnackbar.show('Opening product ${item.id}');
                      Get.toNamed(
                        AppRoutes.productDetails,
                        arguments: <String, dynamic>{
                          'productId': item.id,
                          'productName': item.name,
                          'imageUrl': item.imageUrl,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: AspectRatio(
                          aspectRatio: 1.3,
                          // aspectRatio: 1.15,
                          child: item.imageUrl.isNotEmpty
                              ? Image.network(
                                  item.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AssetsImages.glassJar,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  AssetsImages.glassJar,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 12,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badge == 'New'
                              ? const Color(0xFF2FA84F)
                              : const Color(0xFFFFB11B),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(0),
                            bottomRight: const Radius.circular(17),
                            topRight: const Radius.circular(17),
                            bottomLeft: const Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Obx(() {
                      final isWishlisted = controller.isWishlisted(item.id);
                      final isToggling = controller.isTogglingWishlist(item.id);

                      return GestureDetector(
                        onTap: isToggling
                            ? null
                            : () {
                                controller.toggleWishlist(item.id);
                              },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            color: const Color.fromARGB(1, 142, 142, 147),
                          ),
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted
                                ? const Color(0xFFFF6A00)
                                : Colors.white,
                            size: 16,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            item.categoryName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF585757),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        Text(
                          item.unitSoldCount > 0
                              ? '${item.unitSoldCount} units sold'
                              : '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF15B2A),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            final isFilled = index < item.averageRating.floor();
                            final isHalf =
                                index == item.averageRating.floor() &&
                                item.averageRating % 1 >= 0.5;

                            return Padding(
                              padding: const EdgeInsets.only(right: 1),
                              child: Icon(
                                isFilled
                                    ? Icons.star
                                    : isHalf
                                    ? Icons.star_half
                                    : Icons.star_outline,
                                size: 13,
                                color: isFilled || isHalf
                                    ? const Color(0xFFFFBF00)
                                    : const Color(0xFFFFBF00),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.averageRating.toStringAsFixed(1)} (${item.reviewCount})',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8D8D8D),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DA${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF232323),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (item.mrp > item.price)
                          Text(
                            'DA${item.mrp.toStringAsFixed(item.mrp % 1 == 0 ? 0 : 2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        const Spacer(),
                        Obx(() {
                          final isAdding = controller.isAddingToCart(item.id);
                          return Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: isAdding
                                  ? null
                                  : () => controller.onTrendingBagPressed(item),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
