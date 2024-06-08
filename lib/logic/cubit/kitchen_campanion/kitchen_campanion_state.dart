part of 'kitchen_campanion_cubit.dart';

sealed class KitchenCampanionState extends Equatable {
  const KitchenCampanionState();

  @override
  List<Object> get props => [];
}

final class KitchenCampanionInitial extends KitchenCampanionState {}

class KitchenCampanionEmptyState extends KitchenCampanionState {}

class KitchenCampanionLoadingState extends KitchenCampanionState {}

class KitchenCampanionLoadedState extends KitchenCampanionState {
  final List<KitchenCampanionModel> user ;
  const KitchenCampanionLoadedState({required this.user});
  List<Object> get props => [user];
}



class KitchenCampanionErrorState extends KitchenCampanionState {
  final String message;

  KitchenCampanionErrorState({required this.message});

  List<Object> get props=>[message];
}
