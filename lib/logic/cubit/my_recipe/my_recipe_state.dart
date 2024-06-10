part of 'my_recipe_cubit.dart';

sealed class MyRecipeState extends Equatable {
  const MyRecipeState();

  @override
  List<Object> get props => [];
}

final class MyRecipeInitial extends MyRecipeState {}


class MyRecipeEmptyState extends MyRecipeState {}

class MyRecipeLoadingState extends MyRecipeState {}

class MyRecipeLoadedState extends MyRecipeState {
   List<MyRecipiesModel> recipesList =[];
   MyRecipeLoadedState({required this.recipesList});
  List<Object> get props => [recipesList];
}



class MyRecipeErrorState extends MyRecipeState {
  final String message;

 MyRecipeErrorState({required this.message});

  List<Object> get props=>[message];
}
