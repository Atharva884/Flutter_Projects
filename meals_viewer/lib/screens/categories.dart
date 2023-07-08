import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/models/Category.dart';
import 'package:meals_viewer/models/meal.dart';
import 'package:meals_viewer/providers/meal_category_providers.dart';
import 'package:meals_viewer/screens/meals.dart';
import 'package:meals_viewer/widgets/categories_item.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.moreFilteredMeals,
  });
  final List<Meal> moreFilteredMeals;

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 1,
    );

    animationController.forward();
  }

  // Dispose the controller to delete the animationController from the device memory once the animation is done.
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    // Filtering Meals
    final filteredMeals = widget.moreFilteredMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return AnimatedBuilder(
      animation: animationController,
      child: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        children: categories
            .map(
              (category) => CategoriesItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              ),
            )
            .toList(),

        // Alternative Solution
        // for(final category in availableCategories)
        //   Text(category.title)
      ),
      builder: (context, child) => FadeTransition(
        opacity: Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        ),
        child: child,
      ),
    );
  }
}
