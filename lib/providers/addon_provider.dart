import 'package:add_boat/data/meal_addons.dart';
import 'package:add_boat/data/other_rec.dart';
import 'package:add_boat/data/transp_addons.dart';
import 'package:add_boat/models/addon_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransportationProviderNotifier extends StateNotifier<List<AddOnsModel>> {
  TransportationProviderNotifier() : super([]) {
    loadData();
  }

  void loadData() {
    state = transpAddOnsList;
  }

  void toggleTranspReq(AddOnsModel adnM) {
    final newStatus = !adnM.isChosen;
    state = [
      for (AddOnsModel adn in state)
        if (adn.id == adnM.id) adn.copyWith(isChosen: newStatus) else adn
    ];
  }
}

//
class MealsProvider extends StateNotifier<List<AddOnsModel>> {
  MealsProvider()
      : super(mealAddOnsList); // Ensure mealAddOnsList is defined somewhere

  void toggleMealReq(AddOnsModel ml) {
    final newStatus = !ml.isChosen;
    print(
        'Toggling meal: ${ml.name}, new status: $newStatus, count: ${ml.count}'); // Debug print

    state = [
      for (AddOnsModel adn in state)
        if (adn.id == ml.id) adn.copyWith(isChosen: newStatus) else adn
    ];
  }

  int count = 0;
  void updateMealCount(AddOnsModel mod) {
    print(
        'Updating meal count for id: ${mod.id}, new count: ${mod.count}'); // Debug print

    state = [
      for (AddOnsModel adn in state)
        if (adn.id == mod.id) adn.copyWith(count: adn.count + 1) else adn
    ];
    final updatedMod = state.firstWhere((adn) => adn.id == mod.id);
    print("The count is now: ${updatedMod.isChosen} for ${updatedMod.name}");
  }

  void decrementMealCount(AddOnsModel mod) {
    print(
        'Decrementing meal count for id: ${mod.id}, new count: ${mod.count}'); // Debug print

    state = [
      for (AddOnsModel adn in state)
        if (adn.id == mod.id) adn.copyWith(count: adn.count - 1) else adn
    ];
  }
}

///
class OtherRecommendationNotifier extends StateNotifier<List<AddOnsModel>> {
  OtherRecommendationNotifier()
      : super(
            otherRecommendationList); // Ensure otherRecommendationsList is defined somewhere

  void toggleOtherRecSelection(AddOnsModel adon) {
    final newStatus = !adon.isChosen;

    state = [
      for (AddOnsModel adn in state)
        if (adn.id == adon.id) adn.copyWith(isChosen: newStatus) else adn
    ];
  }
}

final transportationProvider =
    StateNotifierProvider<TransportationProviderNotifier, List<AddOnsModel>>(
  (ref) => TransportationProviderNotifier(),
);

final mealsProvider = StateNotifierProvider<MealsProvider, List<AddOnsModel>>(
  (ref) => MealsProvider(),
);

final otherRecommsProvider =
    StateNotifierProvider<OtherRecommendationNotifier, List<AddOnsModel>>(
        (ref) => OtherRecommendationNotifier());
