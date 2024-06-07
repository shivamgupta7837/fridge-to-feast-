import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/Apis/youtube_player_api.dart';
import 'package:fridge_to_feast/models/youtube_player_model.dart';

part 'youtube_player_state.dart';

class YoutubeCubit extends Cubit<YoutubeSearchingState> {
   final _obj = YoutubePlayerApi();
  YoutubeCubit() : super(YoutubeInitial());

  void getSearchedVideosFromYoutube({required String title})async{
    final data = await _obj.getVideoSearch(searchVideoTitle: title);
    try{
        emit(YoutubeSearchingLoadedState(data:data ));
      }catch(e){
        print("Getting error from YoutubeApi: $e");
      }
    
  }
}
