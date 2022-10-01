import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/user.dart';

import '../../di/service_locator.dart';
import '../../service/user_service.dart';

class UserInfoCubit extends Cubit<User?> {
  final UserService _userService = getIt.get<UserService>();
  User? _user;

  UserInfoCubit(super.initialState) {
    loadUser();
  }

  Future<void> loadUser() async {
    _user = await _userService.getUser();
    emit(_user);
  }

  Future<void> updateUser(User user) async {
    _user = await _userService.updateUser(user);
    emit(_user);
  }
}