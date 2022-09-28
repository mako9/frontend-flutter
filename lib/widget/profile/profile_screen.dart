import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';
import 'package:frontend_flutter/widget/profile/user_info_cubit.dart';

import '../../model/user.dart';
import 'logout_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        BlocProvider(
          create: (_) => LogoutCubit(false),
        ),
        BlocProvider(
          create: (_) => UserInfoCubit(null),
        ),
      ], child: const _ProfileScreenContent()
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener(
          bloc: BlocProvider.of<LogoutCubit>(context),
          listener: (BuildContext context, bool isLoggedOut) {
            if (isLoggedOut) {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.route);
            }
          },
          child: ListView(
          children: <Widget>[
            const Text(
              'User info:',
            ),
            const SizedBox(height: 30),
            BlocBuilder<UserInfoCubit, User?>(
              builder: (_, user) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text(user?.firstName ?? "Undefined"),
                    Text(user?.lastName ?? "Undefined"),
                    Text(user?.mail ?? "Undefined"),
                    Text(user?.street ?? "Undefined"),
                    Text(user?.houseNumber ?? "Undefined"),
                    Text(user?.postalCode ?? "Undefined"),
                    Text(user?.city ?? "Undefined"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            context.read<LogoutCubit>().logout();
                          },
                          child: const Text('Logout'),
                        )
                      ]
                    )
                  ]
                );
              }
            ),
          ],
        ),
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}