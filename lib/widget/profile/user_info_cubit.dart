import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/user.dart';

import '../../di/service_locator.dart';
import '../../service/user_service.dart';

class UserInfoCubit extends Cubit<DataResponse<User>> {
  final UserService _userService = getIt.get<UserService>();

  UserInfoCubit(super.initialState) {
    loadUser();
  }

  factory UserInfoCubit.ofInitialState() {
    return UserInfoCubit(DataResponse.empty());
  }

  Future<void> loadUser() async {
    final dataResponse = await _userService.getUser();
    emit(dataResponse);
  }

  Future<void> updateUser(User user) async {
    final dataResponse = await _userService.updateUser(user);
    emit(dataResponse);
  }
}