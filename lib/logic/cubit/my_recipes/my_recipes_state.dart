part of 'my_recipes_cubit.dart';

sealed class MyRecipesState extends Equatable {
  const MyRecipesState();

  @override
  List<Object> get props => [];
}

final class MyRecipesInitial extends MyRecipesState {}
