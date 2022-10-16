import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/element/custom_button.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';

import '../profile/profile_screen.dart';
import 'logout_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => LogoutCubit(false),
     child: _SettingsScreenContent(),
    );
  }
}

class _SettingsScreenContent extends StatelessWidget {
  _SettingsScreenContent();

  final List<IconData> _listIcons = [Icons.person, Icons.security];

  @override
  Widget build(BuildContext context) {
    final List<String> listTitles = [
      AppLocalizations.of(context)!.settingsScreen_profileSettings,
      AppLocalizations.of(context)!.settingsScreen_securitySettings,
    ];
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(60.0),
          alignment: Alignment.topCenter,
          child: BlocListener(
            bloc: BlocProvider.of<LogoutCubit>(context),
            listener: (BuildContext context, bool isLoggedOut) {
              if (isLoggedOut) {
                Navigator.pop(context);
                Navigator.pushNamed(context, LoginScreen.route);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
               ListView.builder(
                  shrinkWrap: true,
                  itemCount: listTitles.length,
                  itemBuilder: (context, index) {
                return Card(
                child: ListTile(
                onTap: () {
                  MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) => const ProfileScreen());
                  switch (index) {
                    case 1:
                      return;
                    default:
                      break;
                  }
                  Navigator.push(
                    context,
                      pageRoute
                  );
                },
                title: Text(listTitles[index]),
                leading: Icon(_listIcons[index])));
                }),
                const Spacer(),
                CustomButton('Logout', Icons.logout, () {
                  context.read<LogoutCubit>().logout();
                }),
              ],
            ),
          )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}