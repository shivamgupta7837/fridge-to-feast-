part of 'grocery_items_bloc.dart';

sealed class GroceryItemsEvent extends Equatable {
  const GroceryItemsEvent();

  @override
  List<Object> get props => [];
}


// ignore: must_be_immutable
class AddGroceryItemsEvent extends GroceryItemsEvent {
  final String item;
  final String expiryDate;
  final int id;
   int quantity;
   String quantityMeasurementUnits;

  
   AddGroceryItemsEvent( {required this.quantityMeasurementUnits, required this.quantity,  required  this.item,required this.expiryDate,required this.id});

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
  final String quantityMeasurementUnits;
  UpdateGroceryItemsEvent( {required this.id,required  this.updateitem,required this.index,required this.updateExpiryDate,required this.quantity,required this.quantityMeasurementUnits});

  List<Object> get props => [updateitem,updateExpiryDate,index,id,quantity,quantityMeasurementUnits];
}

// class AddQuantityMeasurementUnitsEvent extends GroceryItemsEvent{
//   final String quantityMeasurementUnits;
//   AddQuantityMeasurementUnitsEvent({required this.quantityMeasurementUnits}); 
//   List<Object> get props => [quantityMeasurementUnits];
// }

class ReadGroceryItemsEvent extends GroceryItemsEvent {
  
}


