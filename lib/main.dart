import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/widgets/home_screen.dart';
import 'package:frontend_flutter/widgets/login_screen.dart';

import 'di/service_locator.dart';
import 'models/config.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  getServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _initialAsync(BuildContext context) async {
    // init global config
    final config = getIt.get<Config>();
    await config.loadConfig(context);

    final AuthService authService = getIt.get<AuthService>();
    final bool isLoggedIn = await authService.isLoggedIn();
    return isLoggedIn ? '/' : '/login';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _initialAsync(context),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox.shrink();
          }
          FlutterNativeSplash.remove();
          return MaterialApp(
            title: 'Frontend Flutter',
            theme: ThemeData(
              // Define the default brightness and colors.
              brightness: Brightness.dark,
              primaryColor: Colors.brown[300],
              indicatorColor: Colors.white,

              // Define the default font family.
              fontFamily: 'Georgia',
            ),
            initialRoute: snapshot.data,
            routes: {
              '/login': (context) => const LoginScreen(),
              '/': (context) => const HomeScreen(),
            },
          );
        }
    );
  }
}
