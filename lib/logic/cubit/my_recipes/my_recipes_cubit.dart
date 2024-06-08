import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_recipes_state.dart';

class MyRecipesCubit extends Cubit<MyRecipesState> {
  MyRecipesCubit() : super(MyRecipesInitial());
}
