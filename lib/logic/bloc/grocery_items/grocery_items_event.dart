part of 'grocery_items_bloc.dart';

sealed class GroceryItemsEvent extends Equatable {
  const GroceryItemsEvent();

  @override
  List<Object> get props => [];
}


class AddGroceryItemsEvent extends GroceryItemsEvent {
  final String item;
  final String expiryDate;
  
  AddGroceryItemsEvent( {required  this.item,required this.expiryDate,});

  List<Object> get props => [item,expiryDate];
  
}

class DeleteGroceryItemsEvent extends GroceryItemsEvent {
  final int index;

  DeleteGroceryItemsEvent({required this.index});
  List<Object> get props => [index];

}

// ignore: must_be_immutable
class UpdateGroceryItemsEvent extends GroceryItemsEvent {
  final String updateitem;
  final String updateExpiryDate;
  int index;
  UpdateGroceryItemsEvent({required  this.updateitem,required this.index,required this.updateExpiryDate});

  List<Object> get props => [updateitem,updateExpiryDate,index];
}

class ReadGroceryItemsEvent extends GroceryItemsEvent {
  
}
