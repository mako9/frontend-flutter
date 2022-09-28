import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/user.dart';

import '../../di/service_locator.dart';
import '../../service/user_service.dart';

class UserInfoCubit extends Cubit<User?> {
  final UserService _userService = getIt.get<UserService>();

  UserInfoCubit(super.initialState) {
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await _userService.getUser();
    emit(user);
  }
}