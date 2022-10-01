import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_cubit.dart';

import '../element/custom_button.dart';

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
    return Scaffold(
      body: Center(
        child: BlocListener(
          bloc: BlocProvider.of<LoginCubit>(context),
          listener: (BuildContext context, bool isLoggedIn) {
              if (isLoggedIn) {
                  Navigator.pushNamed(
                  context,
                  HomeScreen.route,
                  );
                }
            },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You are not logged in, login here:',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              CustomButton('Login', Icons.login, () {
                context.read<LoginCubit>().login();
              }),
            ],
          ),
        ),
      )
    );
  } // This trailing comma makes auto-formatting nicer for build methods.
}