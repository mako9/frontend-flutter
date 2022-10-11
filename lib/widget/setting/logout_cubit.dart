import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/user.dart';

import '../../di/service_locator.dart';
import '../../service/auth_service.dart';
import '../../service/user_service.dart';

class LogoutCubit extends Cubit<bool> {
  final AuthService _authService = getIt.get<AuthService>();

  LogoutCubit(super.initialState);

  Future<void> logout() async {
    await _authService.logout();
    emit(true);
  }
}