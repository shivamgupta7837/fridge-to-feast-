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
  final String quantityMeasurementUnits;

  
  const AddGroceryItemsEvent({required this.quantityMeasurementUnits,  required  this.item,required this.expiryDate,required this.id, required this.quantity});

  List<Object> get props => [item,expiryDate,id,quantity,quantityMeasurementUnits];
  
}

class DeleteGroceryItemsEvent extends GroceryItemsEvent {
  final Item itemName;
  final int id;

  const DeleteGroceryItemsEvent({required this.itemName,required this.id});
  List<Object> get props => [itemName,id];

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


