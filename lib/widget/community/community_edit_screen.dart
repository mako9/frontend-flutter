import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/widget/community/community_edit_cubit.dart';
import 'package:frontend_flutter/widget/element/custom_button.dart';

import '../../model/data_response.dart';
import '../element/custom_text_form_field.dart';
import '../element/loading_overlay.dart';

class CommunityEditScreen extends StatelessWidget {
  late final Community? initialCommunity;

  CommunityEditScreen({Key? key, Community? community}) : super(key: key) {
    initialCommunity = community;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CommunityEditCubit.ofInitialState(community: initialCommunity),
      child: LoadingOverlay(child: _CommunityEditScreenStateful()),
    );
  }
}

class _CommunityEditScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommunityEditScreenState();
  }
}

class _CommunityEditScreenState extends State<_CommunityEditScreenStateful> {
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _radiusController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _canCommunityBeJoined = true;

  @override
  Widget build(BuildContext context) {
    Community? community;
    return BlocBuilder<CommunityEditCubit, DataResponse<Community>>(
        builder: (_, dataResponse) {
      if (dataResponse.data != null) community = dataResponse.data;
      LoadingOverlay.of(context).hide();
      return StatefulBuilder(builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(community == null
                ? AppLocalizations.of(context)!.communityEditScreen_title_create
                : AppLocalizations.of(context)!
                    .communityEditScreen_title_create),
          ),
          body: Container(
            padding: const EdgeInsets.all(30.0),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Row(children: [
                        CustomTextFormField(AppLocalizations.of(context)!.name,
                            initialValue: community?.name,
                            controller: _nameController),
                      ]),
                      Row(
                        children: [
                          CustomTextFormField(
                              AppLocalizations.of(context)!.street,
                              initialValue: community?.street,
                              controller: _streetController),
                          CustomTextFormField(
                              AppLocalizations.of(context)!.houseNumber,
                              initialValue: community?.houseNumber,
                              controller: _houseNumberController),
                        ],
                      ),
                      Row(
                        children: [
                          CustomTextFormField(
                              AppLocalizations.of(context)!.postalCode,
                              initialValue: community?.postalCode,
                              controller: _postalCodeController),
                          CustomTextFormField(
                              AppLocalizations.of(context)!.city,
                              initialValue: community?.city,
                              controller: _cityController),
                        ],
                      ),
                      Row(children: [
                        CustomTextFormField(
                            AppLocalizations.of(context)!
                                .communityEditScreen_radius,
                            initialValue: community?.radius.toString(),
                            controller: _radiusController),
                        CustomTextFormField(
                            AppLocalizations.of(context)!
                                .communityEditScreen_latitude,
                            initialValue: community?.latitude.toString(),
                            controller: _latitudeController),
                        CustomTextFormField(
                            AppLocalizations.of(context)!
                                .communityEditScreen_longitude,
                            initialValue: community?.longitude.toString(),
                            controller: _longitudeController),
                      ]),
                      const SizedBox(height: 24),
                      Row(children: [
                        Text(
                          AppLocalizations.of(context)!
                              .communityEditScreen_canBeJoined,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const Spacer(),
                        Switch.adaptive(
                            activeColor: Colors.brown[300],
                            value: _canCommunityBeJoined,
                            onChanged: (value) {
                              setState(() {
                                _canCommunityBeJoined = value;
                              });
                            }),
                      ]),
                      const SizedBox(height: 30),
                      if (dataResponse.errorMessage != null) ...[
                        Text(
                          AppLocalizations.of(context)!
                              .errorMessage(dataResponse.errorMessage!),
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 30),
                      ],
                      const Spacer(),
                      CustomButton(
                          AppLocalizations.of(context)!.save, Icons.save,
                          () async {
                        LoadingOverlay.of(context).show();
                        final updatedCommunity = Community(
                          uuid: community?.uuid,
                          name: _nameController.text,
                          street: _streetController.text,
                          houseNumber: _houseNumberController.text,
                          postalCode: _postalCodeController.text,
                          city: _cityController.text,
                          radius: int.parse(_radiusController.text),
                          canBeJoined: _canCommunityBeJoined,
                        );
                        LoadingOverlay.of(context).show();
                        if (community == null) {
                          await context
                              .read<CommunityEditCubit>()
                              .createCommunity(updatedCommunity);
                        } else {
                          await context
                              .read<CommunityEditCubit>()
                              .updateCommunity(updatedCommunity);
                        }
                        if (mounted) {
                          LoadingOverlay.of(context).hide();
                          Navigator.pop(context);
                        }
                      }),
                    ]))
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      });
    });
  }
}
