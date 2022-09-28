import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(false),
      child: const _LoginScreenContent()
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, bool>(
        builder: (_, loginSuccess) {
          if (loginSuccess) {
            Navigator.pushNamed(
              context,
              HomeScreen.route,
            );
          }
          return Scaffold(
            body: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You are not logged in, login here:',
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      context.read<LoginCubit>().login();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        } // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}