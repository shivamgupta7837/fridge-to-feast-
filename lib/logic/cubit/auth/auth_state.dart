part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}
final class AuthAuthenticated extends AuthState {
  final String message;
  const AuthAuthenticated({required this.message});
    List<Object> get props => [message];
}
final class AuthUnAuthenticated extends AuthState {
  final String message;
const AuthUnAuthenticated({required this.message});
    List<Object> get props => [message];

}
final class AuthLoading extends AuthState {}
