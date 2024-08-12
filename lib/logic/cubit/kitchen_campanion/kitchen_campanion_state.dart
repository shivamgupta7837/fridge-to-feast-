part of 'kitchen_campanion_cubit.dart';

sealed class KitchenCampanionState extends Equatable {
  const KitchenCampanionState();

  @override
  List<Object> get props => [];
}

final class KitchenCampanionInitial extends KitchenCampanionState {}

class KitchenCampanionEmptyState extends KitchenCampanionState {}

class KitchenCampanionLoadingState extends KitchenCampanionState {

}


// ignore: must_be_immutable
class KitchenCampanionLoadedState extends KitchenCampanionState {
   List<Chat> listOfChats = [];

  
   KitchenCampanionLoadedState({required this.listOfChats});
  @override
  List<Object> get props => [listOfChats];
}

class KitchenCampanionErrorState extends KitchenCampanionState {
  final String message;

  KitchenCampanionErrorState({required this.message});

  List<Object> get props=>[message];
}
