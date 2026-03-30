import 'package:flutter/material.dart';
import 'package:kulyx/features/meal_planner/models/meal_planner_screen_model.dart';
import 'package:kulyx/widgets/images.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.item, this.onTap});

  final MealCategoryModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = item.imagePath.startsWith('http');

    return Material(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(7),

      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: isNetworkImage
                        ? Image.network(
                            item.imagePath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AssetsImages.vagitable,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            AssetsImages.vagitable,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
