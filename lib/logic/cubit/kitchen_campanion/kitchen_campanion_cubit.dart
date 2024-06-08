import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/Apis/api_keys.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'kitchen_campanion_state.dart';

class KitchenCampanionCubit extends Cubit<KitchenCampanionState> {
  List<KitchenCampanionModel> newList = [];
  final _key = ApiKey();
  KitchenCampanionCubit() : super(KitchenCampanionInitial()){
    emit(KitchenCampanionEmptyState());
  }

  void sendmessage(
      {required String message, required bool promt, required DateTime date}) {
    newList.add(
        KitchenCampanionModel(message: message, isPrompt: promt, date: date));
    emit(KitchenCampanionLoadedState(user: List.from(newList)));
  }

  void geminiResponse({required String messageToGemini}) async {
    try {
      // emit(KitchenCampanionLoadingState());
      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: _key.getGeminiKey());
      final content = [Content.text(messageToGemini)];
      final response = await model.generateContent(content);
      newList.add(KitchenCampanionModel(
          message: removeSymbols(response.text.toString()),
          isPrompt: false,
          date: DateTime.now()));
      emit(KitchenCampanionLoadedState(user: List.from(newList)));
    } catch (e) {
      emit(KitchenCampanionErrorState(message: e.toString()));
    }
  }

  String removeSymbols(String geminiResponse) {
  return geminiResponse.replaceAll('#', '').replaceAll('*', '');
}

}
