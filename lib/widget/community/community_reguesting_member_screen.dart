import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/community/community_requesting_member_cubit.dart';
import 'package:frontend_flutter/widget/element/custom_paginated_list.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';

import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../model/user.dart';
import '../element/custom_button.dart';

class CommunityRequestingMemberScreen extends StatelessWidget {
  late final String _communityUuid;

  CommunityRequestingMemberScreen(String communityUuid, {super.key}) {
    _communityUuid = communityUuid;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CommunityRequestingMemberCubit.ofInitialState(_communityUuid),
      child: _CommunityRequestingMemberScreenStateful(_communityUuid),
    );
  }
}

class _CommunityRequestingMemberScreenStateful extends StatefulWidget {
  late final String _communityUuid;

  _CommunityRequestingMemberScreenStateful(String communityUuid) {
    _communityUuid = communityUuid;
  }

  @override
  State<StatefulWidget> createState() {
    return _CommunityRequestingMemberScreenState();
  }
}

//ignore: must_be_immutable
class _CommunityRequestingMemberScreenState
    extends State<_CommunityRequestingMemberScreenStateful> {
  final List<String> _selectedUserUuids = List.empty(growable: true);

  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .communityRequestingMemberScreen_title),
      ),
      body: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.topCenter,
          child: BlocBuilder<CommunityRequestingMemberCubit,
              DataResponse<DataPage<User>>>(builder: (_, dataResponse) {
            final page = dataResponse.data;
            if (_isInitialized) {
              LoadingOverlay.of(context).hide();
            } else {
              LoadingOverlay.of(context).show();
              _isInitialized = true;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 24),
                if (dataResponse.errorMessage != null) ...[
                  Text(AppLocalizations.of(context)!
                      .errorMessage(dataResponse.errorMessage!))
                ] else if (page != null) ...[
                  CustomPaginatedList(
                    page,
                    isMultiselectList: true,
                    onPageChangeTap: (index) {
                      context
                          .read<CommunityRequestingMemberCubit>()
                          .loadRequestingMember(widget._communityUuid,
                              pageNumber: index);
                    },
                    onElementTap: (index) {
                      final uuid = dataResponse.data?.content[index].uuid;
                      if (uuid == null) return;
                      setState(() {
                        if (_selectedUserUuids.contains(uuid)) {
                          _selectedUserUuids.remove(uuid);
                        } else {
                          _selectedUserUuids.add(uuid);
                        }
                      });
                    },
                  )
                ],
                const Spacer(),
                Column(
                  children: [
                    CustomButton(
                        AppLocalizations.of(context)!
                            .communityRequestingMemberScreen_acceptRequests,
                        Icons.check_circle, () async {
                      await context
                          .read<CommunityRequestingMemberCubit>()
                          .approveRequests(
                              widget._communityUuid, _selectedUserUuids);
                      _selectedUserUuids.clear();
                    }, isEnabled: _selectedUserUuids.isNotEmpty),
                    const SizedBox(height: 16),
                    CustomButton(
                        AppLocalizations.of(context)!
                            .communityRequestingMemberScreen_declineRequests,
                        Icons.cancel, () async {
                      await context
                          .read<CommunityRequestingMemberCubit>()
                          .declineRequests(
                              widget._communityUuid, _selectedUserUuids);
                      _selectedUserUuids.clear();
                    }, isEnabled: _selectedUserUuids.isNotEmpty),
                  ],
                ),
              ],
            );
          })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
