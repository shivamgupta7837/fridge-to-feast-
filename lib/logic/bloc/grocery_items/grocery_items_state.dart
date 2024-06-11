part of 'grocery_items_bloc.dart';

sealed class GroceryItemsState extends Equatable {
  const GroceryItemsState();
  
  @override
  List<Object> get props => [];
}

final class GroceryItemsInitial extends GroceryItemsState {}

class GroceryItemsEmptyState extends GroceryItemsState {
  
}

class GroceryItemsLoadingState extends GroceryItemsState {

}

class GroceryItemsLoadedState extends GroceryItemsState {
   final List<Map<String,dynamic>> listOfItems;
   const GroceryItemsLoadedState({required this.listOfItems});

   
     List<Object> get props => [listOfItems];
}

class GroceryItemsErrorState extends GroceryItemsState {
final String message;
GroceryItemsErrorState({required this.message});

List<Object> get props => [message];
}
