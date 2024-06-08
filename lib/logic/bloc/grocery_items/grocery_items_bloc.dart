import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';

part 'grocery_items_event.dart';
part 'grocery_items_state.dart';

class GroceryItemsBloc extends Bloc<GroceryItemsEvent, GroceryItemsState> {
  List newList = [];
  GroceryItemsBloc() : super(GroceryItemsInitial()) {
    on<AddGroceryItemsEvent>(addItems);
    on<DeleteGroceryItemsEvent>(deleteItems);
    on<UpdateGroceryItemsEvent>(updateItems);

  }


  Future<void> addItems(AddGroceryItemsEvent event,Emitter<GroceryItemsState> emit)async{
    Map<String,dynamic> itemsMap = {
      "item":event.item,
      "expiry-date":event.expiryDate
    };
     newList.add(itemsMap);
    emit(GroceryItemsLoadedState(listOfItems: List.from(newList)));
  }

  Future<void> deleteItems(DeleteGroceryItemsEvent event,Emitter<GroceryItemsState> emit)async{
    newList.removeAt(event.index);
    emit(GroceryItemsLoadedState(listOfItems: List.from(newList))); 
  }


  Future<void> updateItems(UpdateGroceryItemsEvent event,Emitter<GroceryItemsState> emit)async{
    for (int i=0;i<newList.length;i++) {
      if(i == event.index){
        newList[i]["item"]=event.updateitem;
        newList[i]["expiry-date"]=event.updateExpiryDate;
      }
    }
    print(newList);
    emit(GroceryItemsLoadedState(listOfItems: List.from(newList))); 
  }

}
