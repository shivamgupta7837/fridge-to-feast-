import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/grocery_list_firestore.dart';

part 'grocery_items_event.dart';
part 'grocery_items_state.dart';

class GroceryItemsBloc extends Bloc<GroceryItemsEvent, GroceryItemsState> {
  List<Item> _list = [];
  final _fireStore = GroceryListFireStore();
  GroceryItemsBloc() : super(GroceryItemsInitial()) {
    on<AddGroceryItemsEvent>(addItems);
    on<DeleteGroceryItemsEvent>(deleteItems);
    on<UpdateGroceryItemsEvent>(updateItems);
    on<ReadGroceryItemsEvent>(getItems);
  }

  Future<void> addItems(
      AddGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    _list.add(Item(
        groceryId: event.id,
        expiryDate: event.expiryDate,
        itemName: event.item,
        quantity: event.quantity));
    emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));
    _fireStore.saveGroceryToDataBase(
        items: Item(
            groceryId: event.id,
            expiryDate: event.expiryDate,
            itemName: event.item,
            quantity: event.quantity));
  }

  Future<void> deleteItems(
      DeleteGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    // _list.removeWhere((item) => item.groceryId == event.id);
    _fireStore.deleteDataFromDataBase(id:event.id);
    // emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));
  }

  Future<void> updateItems(
      UpdateGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    //   if (event.index < newList.length) {
    //    	[
    // 	{
    // 		"grocery_id": event.id,
    // 		"expiry_date": {
    // 			"seconds": event.updateExpiryDate,
    // 			"nanoseconds": 0000000
    // 		},
    // 		"item_name": event.updateitem
    // 	},
    // ];
    //     emit(GroceryItemsLoadedState(listOfItems: List.from(newList)));
    //   } else {
    //     emit(GroceryItemsErrorState(message: "Index out of range"));
    //   }
  }

  Future<void> getItems(
      ReadGroceryItemsEvent event, Emitter<GroceryItemsState> emit) async {
    emit(GroceryItemsLoadingState());
    try {
      _list = await _fireStore.getDataFromDataBase();
      if (_list.isEmpty) {
        emit(GroceryItemsEmptyState());
      } else {
        _list.reversed;
        emit(GroceryItemsLoadedState(listOfItems: List.from(_list)));
      }
    } catch (e) {
      emit(GroceryItemsErrorState(message: e.toString()));
    }
  }
}
