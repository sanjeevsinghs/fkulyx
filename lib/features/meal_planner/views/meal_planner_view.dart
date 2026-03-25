import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/meal_planner_ui_controller.dart';
import 'package:kulyx/features/meal_planner/views/widgets/category_card.dart';
import 'package:kulyx/features/meal_planner/views/widgets/category_chip.dart';

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

      if (uiController.isLoading.value || screen == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        color: const Color(0xFFFFFEFE),
        child: SafeArea(
          child: SingleChildScrollView(
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
                        onPressed: () {},
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
                  height: 40,
                  padding: const EdgeInsets.only(left: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: TextField(
                    enableInteractiveSelection: false,
                    contextMenuBuilder: (_, _) => const SizedBox.shrink(),
                    decoration: InputDecoration(
                      hintText: screen.searchPlaceholder,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF999999),
                      ),
                      border: InputBorder.none,
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: screen.filters.length,
                    itemBuilder: (context, index) {
                      return CategoryChip(filter: screen.filters[index]);
                    },
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(screen.hero.imagePath, fit: BoxFit.cover),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Color(0xCC000000), Color(0x55000000)],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              ElevatedButton(
                                onPressed: () => {},
                                 style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(50, 241, 236, 227),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(screen.hero.buttonText,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Forum',
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_outward_outlined, size: 14, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  screen.categorySectionTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF262626),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Forum',
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  itemCount: uiController.visibleCategories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.98,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      item: uiController.visibleCategories[index],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
