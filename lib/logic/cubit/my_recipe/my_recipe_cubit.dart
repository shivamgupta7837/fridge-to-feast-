import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/models/my_recipies_model.dart';

part 'my_recipe_state.dart';

class MyRecipeCubit extends Cubit<MyRecipeState> {
  final List<MyRecipiesModel> recipeList = [];

  MyRecipeCubit() : super(MyRecipeInitial()) {
    emit(MyRecipeEmptyState());
  }

  void addRecipes({required String recipe, required String title}) {
    recipeList.add(MyRecipiesModel(
      title: title.toString(),
      recipe: _removeSymbols(recipe.toString()),
    ));
    try {
      // print("title before emit: $title");
      emit(MyRecipeLoadedState(recipesList: List.from(recipeList)));
      // print("title after emit: $title");
    } catch (e) {
      emit(MyRecipeErrorState(message: e.toString()));
    }
  }

  void deleteRecipes(int index) {
recipeList.removeAt(index);
    try {
      emit(MyRecipeLoadedState(recipesList: List.from(recipeList)));
    } catch (e) {
      emit(MyRecipeErrorState(message: e.toString()));
    }
  }

  String _removeSymbols(String geminiResponse) {
    return geminiResponse.replaceAll('#', '').replaceAll('*', '');
  }
}
