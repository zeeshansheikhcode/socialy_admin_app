part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}
class UserLoadedState extends UserState {
  final UserModel? userModel;
 const UserLoadedState({this.userModel});
 @override
  List<Object> get props => [userModel!];
  
}

class UserErrorState extends UserState {
  final String? errorMessage;
  const UserErrorState(this.errorMessage);
   @override
  List<Object> get props => [errorMessage!];
}
