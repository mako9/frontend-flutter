import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend_flutter/widget/element/custom_theme.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';
import 'package:frontend_flutter/main_cubit.dart';

import 'di/service_locator.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  getServices();

  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => MainCubit(null, context),
    child: const _MainScreenContent()
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, String?>(
    builder: (_, route) {
      if (route == null) {
        return const SizedBox.shrink();
      }
      FlutterNativeSplash.remove();
      return MaterialApp(
        title: 'Frontend Flutter',
        theme: customTheme,
        initialRoute: route,
        routes: {
          LoginScreen.route: (context) => const LoginScreen(key: Key('Login')),
          HomeScreen.route: (context) => const HomeScreen(key: Key('Home')),
        },
      );
    }
    );
  }
}
