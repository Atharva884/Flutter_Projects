import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/models/meal.dart';

class FavouritesNotifier extends StateNotifier<List<Meal>> {
  // Here we need to initialize empty list of favourites meal
  FavouritesNotifier() : super([]);

  // Point to be remembered:
  // immutable properties

  bool onFavouriteMealStatus(Meal meal) {
    bool isMealAdded = state.contains(meal);

    if (isMealAdded) {
      // As we they are immutable, where() is used to filter the list based on the condition.
      // So, If meal id matches, that meal will be removed from the list. 
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      // ...(Spread Operator) --> To pull the items from the existing list and add them into new list + adding new meal
      state = [...state, meal];
      return true;
    }
  }
}

final favouriteProviders =
    StateNotifierProvider<FavouritesNotifier, List<Meal>>(
  (ref) => FavouritesNotifier(),
);
