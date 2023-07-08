import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/models/meal.dart';
import 'package:meals_viewer/providers/favourite_providers.dart';

class MealDetailsScreen extends ConsumerStatefulWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    final favouriteMeals = ref.watch(favouriteProviders);

    bool isfavourite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meal.title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final result = ref
                  .read(favouriteProviders.notifier)
                  .onFavouriteMealStatus(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(
                    result
                        ? "Meal added to favourite"
                        : "Meal removed from favourite",
                  ),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween(
                    begin: 0.6,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isfavourite ? Icons.star : Icons.star_border,
                key: ValueKey(
                    isfavourite), // Key parameter is needed to tell the flutter that the data inside the widget updates to perform animation
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                height: 350,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: animationController,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ingredients",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 0.8,
                    ),
                    for (final ingredient in meal.ingredients)
                      Text(
                        ingredient,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Steps",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 0.8,
                    ),
                    for (final step in meal.steps)
                      Text(
                        step,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Stuff Included",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 0.8,
                    ),
                    Text(
                      "1) GlutenFree",
                      style: TextStyle(
                          color: meal.isGlutenFree ? Colors.green : Colors.red,
                          fontSize: 20),
                    ),
                    Text(
                      "2) LactoseFree",
                      style: TextStyle(
                          color: meal.isLactoseFree ? Colors.green : Colors.red,
                          fontSize: 20),
                    ),
                    Text(
                      "3) Vegan",
                      style: TextStyle(
                          color: meal.isVegan ? Colors.green : Colors.red,
                          fontSize: 20),
                    ),
                    Text(
                      "4) Vegeterian",
                      style: TextStyle(
                          color: meal.isVegetarian ? Colors.green : Colors.red,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              builder: (context, child) {
                return FadeTransition(
                  opacity: Tween(
                    begin: 0.5,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                        parent: animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
