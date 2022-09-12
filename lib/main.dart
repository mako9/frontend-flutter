import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/widgets/home_screen.dart';
import 'package:frontend_flutter/widgets/login_screen.dart';

import 'models/config.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _initialAsync(BuildContext context) async {
    // init global config
    await Config().loadConfig(context);

    final AuthService authService = AuthService();
    final bool isLoggedIn = await authService.isLoggedIn();
    return isLoggedIn ? '/home' : '/';
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
            initialRoute: snapshot.data,
            routes: {
              '/': (context) => const LoginScreen(title: 'Login'),
              '/home': (context) => const HomeScreen(title: 'Home'),
            },
          );
        }
    );
  }
}
