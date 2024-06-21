part of 'auth_cubit.dart';
// TODO: handle intialization state.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class  AuthInital extends AuthState{}
final class AuthAuthenticatedState extends AuthState {
  
}
final class AuthErrorState extends AuthState {
  final String message;
const AuthErrorState({required this.message});
    List<Object> get props => [message];

}
final class AuthLoadingState extends AuthState {}
