// recipe_data.dart



// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:prj1/models/model.dart';

ValueNotifier<List<Recipe>> recipenotifier = ValueNotifier([]);
ValueNotifier<List<Recipe>> favoriteNotifier=ValueNotifier([]);
String? currentuser;

  
Future<void> addRecipe(Recipe values) async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');
  await recipeBox.add(values);
}

Future<List<Recipe>> getRecipes() async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');
  return recipeBox.values.toList();
}

Future<int> getKey(Recipe recipiesToGetKey) async {
  var recipeBox = await Hive.openBox<Recipe>('recipes');
  var key =
      recipeBox.keyAt(recipeBox.values.toList().indexOf(recipiesToGetKey));
  return key;
}

Future<void> updateRecipe(Recipe rrecipe, int key) async {
  var recipeBox = await Hive.openBox<Recipe>('recipes');
  await recipeBox.put(key, rrecipe);
}

Future<void> deleteRecipe(int key) async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');

  if (recipeBox.isEmpty) {
    
    return;
  }

  if (key < 0 || key >= recipeBox.length) {
     
    return;
  }

  await recipeBox.deleteAt(key);
}

Future<void> fetchRecipesByCategory({required String categoryofFood}) async {
  final box = await Hive.openBox<Recipe>('recipes');

  final categryList = box.values
      .toList()
      .where(
          (food) => food.category.toLowerCase() == categoryofFood.toLowerCase())
      .toList();
  recipenotifier.value = categryList.toList();
  // ignore: invalid_use_of_protected_member
  recipenotifier.notifyListeners();
}
 
 Future<void> getFavorites() async {
  final box = await Hive.openBox<Recipe>('recipes');
  // ignore: non_constant_identifier_names
  final FavoriteList = box.values
      .where((food) => food.favoritesUserIds.contains(FirebaseAuth.instance.currentUser!.uid))
      .toList();
  favoriteNotifier.value = FavoriteList;
}

Future<void> addAndRemoveFavorite(Recipe recipe) async {
  final currentUserId =FirebaseAuth.instance.currentUser!.uid; 
  if (recipe.favoritesUserIds.contains(currentUserId)) {
    recipe.favoritesUserIds.remove(currentUserId);
  } else {
    recipe.favoritesUserIds.add(currentUserId);
  }
 
  
  
  await updateRecipe(recipe, await getKey(recipe));
  await getFavorites();
}