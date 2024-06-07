part of 'youtube_player_cubit.dart';

sealed class YoutubeSearchingState extends Equatable {
  const YoutubeSearchingState();

  @override
  List<Object> get props => [];
}

final class YoutubeInitial extends YoutubeSearchingState {}


class YoutubeSearchingEmptyState extends YoutubeSearchingState {}

class YoutubeSearchingLoadingState extends YoutubeSearchingState {}

class YoutubeSearchingLoadedState extends YoutubeSearchingState {
 final YoutubePlayerModel data;

 YoutubeSearchingLoadedState({required this.data});
 List<Object> get props => [data];
}

class ErrorYoutubeSearchingState extends YoutubeSearchingState {}

