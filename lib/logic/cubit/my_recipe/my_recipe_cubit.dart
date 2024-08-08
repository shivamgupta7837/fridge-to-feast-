import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/models/my_recipies_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/kitchen_campanion_database/my_recipies_firestore.dart';

part 'my_recipe_state.dart';

class MyRecipeCubit extends Cubit<MyRecipeState> {
  final List<MyRecipiesModel> _recipeList = [];
   List<MyRecipiesModel> _getRecipiesList = [];
  final _myRecipesFirestore = MyRecipesFirestore();

  MyRecipeCubit() : super(MyRecipeInitial()) {
    emit(MyRecipeEmptyState());
  }

  void addRecipes(
      {required String recipe,
      required String title,
      required String date,
      required int id}) {

    try {
      _recipeList.add(MyRecipiesModel(
        title: title.toString(),
        recipe: _removeSymbols(recipe.toString()),
        date: date,
        id: id,
      ));

      emit(MyRecipeLoadedState(recipesList: List.from(_recipeList)));

      _myRecipesFirestore.saveChatsToDataBase(
          recipies: MyRecipiesModel(
        title: title.toString(),
        recipe: _removeSymbols(recipe.toString()),
        date: date,
        id: id,
      ));
    } catch (e) {
      
      emit(MyRecipeErrorState(message: e.toString()));
    }
  }

  void deleteRecipes(int id,MyRecipiesModel recipe) {

    try {
    _getRecipiesList.removeWhere((item) => item.id == id);
      emit(MyRecipeLoadedState(recipesList: List.from(_getRecipiesList)));
    _myRecipesFirestore.deleteDataFromDataBase(item: recipe);
    } catch (e) {
      
      print("some error: $e");
      emit(MyRecipeErrorState(message: e.toString()));
    }
  }

  String _removeSymbols(String geminiResponse) {
    return geminiResponse.replaceAll('#', '').replaceAll('*', '');
  }

    void getRecipiesFromDataBase()async{
    
        emit(MyRecipeLoadingState());
    try {
      _getRecipiesList.clear();
      _getRecipiesList = await _myRecipesFirestore.getChatsFromDataBase();
      if (_getRecipiesList.isEmpty) {
        emit(MyRecipeEmptyState());
      } else {
        emit(MyRecipeLoadedState(recipesList: List.from(_getRecipiesList)));
      }
    } catch (e) {
      emit(MyRecipeErrorState(message: e.toString()));
    }
  }
}
