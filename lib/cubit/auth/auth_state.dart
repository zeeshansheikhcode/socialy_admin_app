part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  final bool isAuthenticated;
  const AuthLoadedState(this.isAuthenticated);
  @override
  List<Object> get props => [isAuthenticated];
}

class AuthErrorState extends AuthState {
   final String errormessage;
  const AuthErrorState(this.errormessage);
   @override
  List<Object> get props => [errormessage];
}