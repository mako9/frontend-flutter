import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/element/custom_button.dart';
import 'package:frontend_flutter/widget/profile/user_info_cubit.dart';

import '../../model/data_response.dart';
import '../../model/user.dart';
import '../element/custom_text_form_field.dart';
import '../element/loading_overlay.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoCubit.ofInitialState(),
      child: LoadingOverlay(child: _ProfileScreenContent()),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  _ProfileScreenContent();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileScreen_title),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.profileScreen_headline,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
           Expanded(
             child: BlocBuilder<UserInfoCubit, DataResponse<User>>(
              builder: (_, dataResponse) {
                LoadingOverlay.of(context).hide();
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        CustomTextFormField(AppLocalizations.of(context)!.profileScreen_firstName, initialValue: dataResponse.data?.firstName, controller: _firstNameController),
                      ]),
                      Row(children: [
                        CustomTextFormField(AppLocalizations.of(context)!.profileScreen_lastName, initialValue: dataResponse.data?.lastName, controller: _lastNameController),
                      ]),
                      Row(children: [
                        CustomTextFormField(AppLocalizations.of(context)!.profileScreen_mail, initialValue: dataResponse.data?.mail),
                      ]),
                      Row(
                        children: [
                          CustomTextFormField(AppLocalizations.of(context)!.profileScreen_street, initialValue: dataResponse.data?.street, controller: _streetController),
                          CustomTextFormField(AppLocalizations.of(context)!.profileScreen_houseNumber, initialValue: dataResponse.data?.houseNumber, controller: _houseNumberController),
                        ],
                      ),
                      Row(
                        children: [
                          CustomTextFormField(AppLocalizations.of(context)!.profileScreen_postalCode, initialValue: dataResponse.data?.postalCode, controller: _postalCodeController),
                          CustomTextFormField(AppLocalizations.of(context)!.profileScreen_city, initialValue: dataResponse.data?.city, controller: _cityController),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (dataResponse.errorMessage != null) ...[
                        Text(
                          AppLocalizations.of(context)!.errorMessage(dataResponse.errorMessage!),
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 30),
                      ],
                      CustomButton(AppLocalizations.of(context)!.save, Icons.save, () {
                        final updatedUser = User(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          street: _streetController.text,
                          houseNumber: _houseNumberController.text,
                          postalCode: _postalCodeController.text,
                          city: _cityController.text
                        );
                        LoadingOverlay.of(context).show();
                        context.read<UserInfoCubit>().updateUser(updatedUser);
                      }),
                    ]
                );
              }
             )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}