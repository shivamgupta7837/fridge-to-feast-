import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/models/my_recipies_model.dart';

part 'my_recipes_state.dart';

class MyRecipesCubit extends Cubit<MyRecipesState> {
  List<MyRecipiesModel> list = [];
  MyRecipesCubit() : super(MyRecipesInitial());

  void addDataFromGeminiResponse({required String data,required String title}){
    list.add(MyRecipiesModel(title: title, recipe: data));

    emit(MyRecipesLoadedState(data: List.from(list)));
  }

  List<MyRecipiesModel> readGeminiResponse(){
    if(list.isEmpty){
      return [];
    }
     return list;
  }
}
