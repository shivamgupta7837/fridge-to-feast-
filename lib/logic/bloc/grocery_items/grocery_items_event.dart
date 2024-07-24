part of 'grocery_items_bloc.dart';

sealed class GroceryItemsEvent extends Equatable {
  const GroceryItemsEvent();

  @override
  List<Object> get props => [];
}


class AddGroceryItemsEvent extends GroceryItemsEvent {
  final String item;
  final String expiryDate;
  final int id;
  final int quantity;
  
  const AddGroceryItemsEvent( {required  this.item,required this.expiryDate,required this.id, required this.quantity});

  List<Object> get props => [item,expiryDate,id,quantity];
  
}

class DeleteGroceryItemsEvent extends GroceryItemsEvent {
  final int id;

  DeleteGroceryItemsEvent({required this.id});
  List<Object> get props => [id];

}

// ignore: must_be_immutable
class UpdateGroceryItemsEvent extends GroceryItemsEvent {
  final String updateitem;
  final String updateExpiryDate;
  final int id;
  int index;
  int quantity;
  UpdateGroceryItemsEvent( {required this.id,required  this.updateitem,required this.index,required this.updateExpiryDate,required this.quantity,});

  List<Object> get props => [updateitem,updateExpiryDate,index,id,quantity];
}

class ReadGroceryItemsEvent extends GroceryItemsEvent {
  
}


