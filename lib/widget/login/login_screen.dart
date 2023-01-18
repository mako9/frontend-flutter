import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';
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
      child: const LoadingOverlay(child: _LoginScreenContent()),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24.0),
        child: BlocListener(
          bloc: BlocProvider.of<LoginCubit>(context),
          listener: (BuildContext context, bool isLoggedIn) {
            LoadingOverlay.of(context).hide();
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
              const SizedBox(height: 60),
              Image.asset('assets/image/quokka_logo.png', height: 200, width: 200),
              const SizedBox(height: 24),
              Text(AppLocalizations.of(context)!.appName,
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(AppLocalizations.of(context)!.loginScreen_headline,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 60),
              CustomButton(AppLocalizations.of(context)!.loginScreen_login, Icons.login, () {
                LoadingOverlay.of(context).show();
                context.read<LoginCubit>().login();
              }),
              const SizedBox(height: 60),
            ],
          ),
        ),
      )
    );
  } // This trailing comma makes auto-formatting nicer for build methods.
}