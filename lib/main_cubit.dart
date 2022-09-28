import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';

import '../di/service_locator.dart';
import '../service/auth_service.dart';
import 'model/config.dart';

class MainCubit extends Cubit<String?> {

  MainCubit(super.initialState, BuildContext context) {
    getInitialRoute(context);
  }

  Future<void> getInitialRoute(BuildContext context) async {
    // init global config
    final config = getIt.get<Config>();
    await config.loadConfig(context);

    final AuthService authService = getIt.get<AuthService>();
    final bool isLoggedIn = await authService.isLoggedIn();
    emit(isLoggedIn ? HomeScreen.route : LoginScreen.route);
  }
}