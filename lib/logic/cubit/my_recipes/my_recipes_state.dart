part of 'my_recipes_cubit.dart';

sealed class MyRecipesState extends Equatable {
  const MyRecipesState();

  @override
  List<Object> get props => [];
}

final class MyRecipesInitial extends MyRecipesState {}

class MyRecipesEmptyState extends MyRecipesState {}

class MyRecipesLoadingState extends MyRecipesState {}

class MyRecipesLoadedState extends MyRecipesState {
 final List<MyRecipiesModel> data;

 MyRecipesLoadedState({required this.data});
 List<Object> get props => [data];
}

class MyRecipesErrorState extends MyRecipesState {
  final String message;
 MyRecipesErrorState({required this.message});

  List<Object> get props=>[message];
}


