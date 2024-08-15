import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/grocery_list_firestore.dart';

part 'grocery_items_event.dart';
part 'grocery_items_state.dart';

class GroceryItemsBloc extends Bloc<GroceryItemsEvent, GroceryItemsState> {
  List<Item> _list = [];
  final _fireStore = GroceryListFireStore();
   String unit = "";
  GroceryItemsBloc() : super(GroceryItemsInitial()) {
    on<AddGroceryItemsEvent>(addItems);
    on<DeleteGroceryItemsEvent>(deleteItems);
    on<UpdateGroceryItemsEvent>(updateItems);
    on<ReadGroceryItemsEvent>(getItems);
    // on<AddQuantityMeasurementUnitsEvent>(addQuantityMeasurementUnits);
  }


  // Future<void>addQuantityMeasurementUnits(AddQuantityMeasurementUnitsEvent event, Emitter<GroceryItemsState> emit)async{
    
  //   emit(GroceryItemsUnitLoadedState(unit: event.quantityMeasurementUnits));
  // }

  Future<void> addItems(
      AddGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    try{
      _list.add(Item(
        groceryId: event.id,
        expiryDate: event.expiryDate,
        itemName: event.item,
        quantity: event.quantity!, units: event.quantityMeasurementUnits!));
    emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));
    _fireStore.saveGroceryToDataBase(
        items: Item(
            groceryId: event.id,
            expiryDate: event.expiryDate,
            itemName: event.item,
            quantity: event.quantity!,
            units: event.quantityMeasurementUnits!));
    }catch(e){
      emit(GroceryItemsErrorState(message: e.toString()));
    }
  }

  Future<void> deleteItems(
      DeleteGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
   try{ _list.removeWhere((item) => item.groceryId == event.id);
    _fireStore.deleteDataFromDataBase(item: event.itemName);
    emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));}
    catch(e){
      emit(GroceryItemsErrorState(message: e.toString()));
    }
  }

  Future<void> updateItems(
      UpdateGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
       try{
         _list.removeWhere((item) => item.groceryId == event.id);
        _list.insert(event.index, Item(
        groceryId: event.id,
        expiryDate: event.updateExpiryDate,
        itemName: event.updateitem,
        quantity: event.quantity,
        units: event.quantityMeasurementUnits));

        emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));

        _fireStore.updateDataFromDataBase(item:  Item(
        groceryId: event.id,
        expiryDate: event.updateExpiryDate,
        itemName: event.updateitem,
        quantity: event.quantity,units: event.quantityMeasurementUnits),id: event.id,index: event.index);
       }catch(e){
        emit(GroceryItemsErrorState(message: e.toString()));
       }
  }

  Future<void> getItems(
      ReadGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    emit(GroceryItemsLoadingState());
    try {
      _list.clear();
      _list = await _fireStore.getDataFromDataBase();
      if (_list.isEmpty) {
        emit(GroceryItemsEmptyState());
      } else {
        _list.reversed;
        emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));
      }
    } catch (e) {
      debugPrint("grocery items bloc");
      emit(GroceryItemsErrorState(message: e.toString()));
    }
  }
}
