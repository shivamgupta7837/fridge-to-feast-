

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/keys/api_keys.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:fridge_to_feast/models/my_recipies_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/kitchen_campanion_database/kitchen_campanion_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'kitchen_campanion_state.dart';

class KitchenCampanionCubit extends Cubit<KitchenCampanionState> {
  List<Chat> chats = [];
  List<MyRecipiesModel> recipeList = [];
  bool loading = false;
  final KitchenCampanionFirestore _kitchenCampanionFirestore =
      KitchenCampanionFirestore();
  final _key = ApiKey();
  KitchenCampanionCubit() : super(KitchenCampanionInitial()) {
    emit(KitchenCampanionEmptyState());
  }

  void sendmessage(
      {required String message,
      required String promt,
      required DateTime date}) {
    try {
      chats.add(
          Chat(timestamp: date.toString(), sender: promt, message: message));
      emit(KitchenCampanionLoadedState(listOfChats: List.from(chats)));
      _kitchenCampanionFirestore.saveChatsToDataBase(chats:  Chat(timestamp: date.toString(), sender: promt, message: message));
    } catch (e) {
      emit(KitchenCampanionErrorState(message: e.toString()));
    }
  }

  void getGeminiResponse(
      {required String messageToGemini,
      required String promt,
      required String date,
      typingStatus}) async {
    try {
    
      final model = GenerativeModel(
          model: 'gemini-1.5-flash', apiKey: _key.getGeminiKey());
      final content = [Content.text(messageToGemini)];
      final response = await model.generateContent(content);
      chats.add(Chat(
          timestamp: date.toString(),
          sender: promt,
          message: _removeSymbols(response.text!.toString())));
      emit(KitchenCampanionLoadedState(listOfChats: List.from(chats)));
       _kitchenCampanionFirestore.saveChatsToDataBase(chats:  Chat(timestamp: date.toString(), sender: promt, message: _removeSymbols(response.text!.toString())));
  
    } catch (e) {
      emit(KitchenCampanionErrorState(message: e.toString()));
    }
  }

  String _removeSymbols(String geminiResponse) {
    return geminiResponse.replaceAll('#', '').replaceAll('*', '');
  }


  void getDataFromDataBase()async{
    emit(KitchenCampanionLoadingState());
    try {
      chats.clear();
      chats = await _kitchenCampanionFirestore.getChatsFromDataBase();
      if (chats.isEmpty) {
        emit(KitchenCampanionEmptyState());
      } else {
        chats.reversed;
        emit(KitchenCampanionLoadedState(listOfChats: List.from(chats)));
      }
    } catch (e) {
      emit(KitchenCampanionErrorState(message: e.toString()));
    }
  }
}
