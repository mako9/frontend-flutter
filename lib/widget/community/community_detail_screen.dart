import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/widget/community/community_detail_cubit.dart';

import '../../model/data_response.dart';
import '../../model/user.dart';
import '../element/custom_key_value_column.dart';
import '../element/custom_paginated_list.dart';
import '../element/loading_overlay.dart';
import 'community_edit_screen.dart';

class CommunityDetailScreen extends StatelessWidget {
  late final Community? initialCommunity;

  CommunityDetailScreen({Key? key, Community? community}) : super(key: key) {
    initialCommunity = community;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CommunityDetailCubit.ofInitialState(community: initialCommunity),
      child: const LoadingOverlay(child: _CommunityDetailScreenContent()),
    );
  }
}

class _CommunityDetailScreenContent extends StatelessWidget {
  const _CommunityDetailScreenContent();

  @override
  Widget build(BuildContext context) {
    Community? community;
    DataPage<User>? member;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.communityDetailScreen_title),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        alignment: Alignment.topCenter,
        child: BlocBuilder<CommunityDetailCubit,
            DataResponse<CommunityDetailState>>(builder: (_, dataResponse) {
          if (dataResponse.data?.community != null) {
            community = dataResponse.data!.community;
          }
          if (dataResponse.data?.communityMember != null) {
            member = dataResponse.data!.communityMember;
          }
          LoadingOverlay.of(context).hide();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                        color: Colors.brown[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(children: [
                      Row(children: [
                        CustomKeyValueColumn(AppLocalizations.of(context)!.name,
                            community?.name),
                        if (community?.isAdmin == true) ... [
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommunityEditScreen(
                                            community: community)));
                              },
                              icon: const Icon(Icons.edit))
                        ]
                      ]),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.street,
                              community?.street),
                          const SizedBox(width: 32),
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.houseNumber,
                              community?.houseNumber),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.postalCode,
                              community?.postalCode),
                          const SizedBox(width: 32),
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.city,
                              community?.city),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        CustomKeyValueColumn(
                            AppLocalizations.of(context)!
                                .communityEditScreen_radius,
                            community?.radius.toString()),
                        const SizedBox(width: 32),
                        CustomKeyValueColumn(
                            AppLocalizations.of(context)!
                                .communityEditScreen_latitude,
                            community?.latitude.toString()),
                        const SizedBox(width: 32),
                        CustomKeyValueColumn(
                            AppLocalizations.of(context)!
                                .communityEditScreen_longitude,
                            community?.longitude.toString()),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        CustomKeyValueColumn(
                            AppLocalizations.of(context)!
                                .communityDetailScreen_admin,
                            '${community?.adminLastName}, ${community?.adminFirstName}'),
                      ]),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),
                Text(AppLocalizations.of(context)!.communityDetailScreen_member,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (member != null) ...[
                  CustomPaginatedList(member!)
                ],
                if (dataResponse.errorMessage != null) ...[
                  Text(
                    AppLocalizations.of(context)!
                        .errorMessage(dataResponse.errorMessage!),
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 30),
                ],
                const Spacer(),
              ]);
        }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
