import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../service/auth_service.dart';

class LoginCubit extends Cubit<bool> {
  final AuthService _authService = getIt.get<AuthService>();

  LoginCubit(super.initialState);

  Future<void> login() async {
    bool loginSuccess = await _authService.authenticate();
    emit(loginSuccess);
  }
}