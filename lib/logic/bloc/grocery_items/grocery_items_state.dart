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
   final List<Item> listOfItems;
   const GroceryItemsLoadedState({required this.listOfItems});

     @override
       List<Object> get props => [listOfItems];
}

class GroceryItemsErrorState extends GroceryItemsState {
final String message;
const GroceryItemsErrorState({required this.message});

@override
  List<Object> get props => [message];
}
