import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_model.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> loadUser() async {
    await UserService.init();
    emit(UserLoaded(user: UserService.user));
  }

  Future<void> addCoins(int coins) async {
    await UserService.addCoin(coins: coins);
    emit(UserLoaded(user: UserService.user));
  }

  Future<void> purchaseTopic(Category topic) async {
    await UserService.purchaseTopic(topic: topic);
    emit(UserLoaded(user: UserService.user));
  }

  bool isTopicUnlocked(String title) {
    return UserService.isTopicUnlocked(title);
  }
}
