part of 'user_cubit.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final User user;
  UserLoaded({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
