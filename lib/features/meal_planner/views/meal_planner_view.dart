import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/index.dart';
import 'package:kulyx/features/meal_planner/views/widgets/index.dart';

class MealPlannerView extends StatelessWidget {
  const MealPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final MealPlannerUiController uiController =
        Get.isRegistered<MealPlannerUiController>()
        ? Get.find<MealPlannerUiController>()
        : Get.put(MealPlannerUiController());

    return Obx(() {
      final screen = uiController.screen.value;
      final bool isLoading =
          uiController.isLoading.value ||
          uiController.isCheckingCartCount.value ||
          uiController.isCartActionLoading.value;

      if (screen == null) {
        return const Scaffold(
          backgroundColor: Color(0xFFFFFEFE),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFFFFEFE),
        body: Stack(
          children: <Widget>[
            Container(
              color: const Color(0xFFFFFEFE),
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(14),
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
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 228, 228, 228),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.menu,
                              size: 20,
                              color: Color(0xFF555555),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Image(
                            image: AssetImage(
                              'assets/images/culinary_tagline.png',
                            ),
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
                            child: Obx(() {
                              final cartCount =
                                  uiController.cartUniqueItems.value;

                              return Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            await uiController
                                                .openCartByApiCount();
                                          },
                                    icon: const Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  if (cartCount > 0)
                                    Positioned(
                                      top: -5,
                                      right: -3,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE00B0B),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$cartCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                screen.searchPlaceholder,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: screen.filters.length,
                          itemBuilder: (context, index) {
                            return CategoryChip(filter: screen.filters[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image.asset(
                                        screen.hero.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              Color(0xCC000000),
                                              Color(0x55000000),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              screen.hero.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Forum',
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              screen.hero.subtitle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xFFE5E5E5),
                                                fontFamily: 'Roboto',
                                                fontSize: 10,
                                              ),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                    50,
                                                    241,
                                                    236,
                                                    227,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      screen.hero.buttonText,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Forum',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Icon(
                                                      Icons
                                                          .arrow_outward_outlined,
                                                      size: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                screen.categorySectionTitle,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF262626),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Forum',
                                ),
                              ),
                              GridView.builder(
                                itemCount:
                                    uiController.visibleCategories.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      // crossAxisCount: crossAxisCount,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 140,
                                    ),
                                itemBuilder: (context, index) {
                                  return CategoryCard(
                                    item: uiController.visibleCategories[index],
                                  );
                                },
                              ),

                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'Trending This Week (${uiController.trendingProducts.length})',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF262626),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Forum',
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6A00),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Text(
                                        'Shop More',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              if (uiController.trendingProducts.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE8E8E8),
                                    ),
                                  ),
                                  child: Text(
                                    uiController.trendingError.value.isNotEmpty
                                        ? uiController.trendingError.value
                                        : 'No trending products found',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF666666),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                )
                              else
                                GridView.builder(
                                  itemCount:
                                      uiController.trendingProducts.length > 4
                                      ? 4
                                      : uiController.trendingProducts.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        // childAspectRatio: 0.63,
                                        mainAxisExtent: 280,
                                      ),
                                  itemBuilder: (context, index) {
                                    return TrendingCard(
                                      item:
                                          uiController.trendingProducts[index],
                                    );
                                  },
                                ),
                              Container(
                                height: 450,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/kitchenware.png',
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                      const Text(
                                        'Get 20% Discount',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black26,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40,
                                          right: 40,
                                        ),
                                        child: Text(
                                          'Get 20% Off Your First Order!',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'Forum',
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        'Sign up today and enjoy a special 20% discount on your first purchase.',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            248,
                                            247,
                                            247,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.deepOrange,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Explore More',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepOrange,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'Super Flash Sale',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF262626),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Forum',
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6A00),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Text(
                                        'Shop More',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (uiController.trendingProducts.isNotEmpty)
                                GridView.builder(
                                  itemCount:
                                      uiController.trendingProducts.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        // childAspectRatio: 0.63,
                                        mainAxisExtent: 280,
                                      ),
                                  itemBuilder: (context, index) {
                                    return TrendingCard(
                                      item:
                                          uiController.trendingProducts[index],
                                    );
                                  },
                                ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Our Top Featured Products',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF262626),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Forum',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: screen.filters.length,
                                  itemBuilder: (context, index) {
                                    return CategoryChip(
                                      filter: screen.filters[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.14),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        height: 42,
                        width: 42,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6A00),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
