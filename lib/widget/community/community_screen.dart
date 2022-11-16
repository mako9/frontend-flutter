import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/community/community_edit_screen.dart';
import 'package:frontend_flutter/widget/element/custom_paginated_list.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';

import '../../model/community.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../element/custom_button.dart';
import 'community_cubit.dart';
import 'community_detail_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityCubit.ofInitialState(),
      child: _CommunityScreenContent(),
    );
  }
}

//ignore: must_be_immutable
class _CommunityScreenContent extends StatelessWidget {
  _CommunityScreenContent();

  final List<bool> _selectedToggle = <bool>[true, false];
  bool _isInitialized = false;
  int _index = 0;
  DataPage<Community>? _page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.topCenter,
          child: BlocBuilder<CommunityCubit, DataResponse<DataPage<Community>>>(
              builder: (_, dataResponse) {
            _page = dataResponse.data;
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
                ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    _index = index;
                    LoadingOverlay.of(context).show();
                    switch (index) {
                      case 0:
                        context.read<CommunityCubit>().loadMyCommunities();
                        break;
                      case 1:
                        context.read<CommunityCubit>().loadAllCommunities();
                        break;
                    }
                    for (int i = 0; i < _selectedToggle.length; i++) {
                      _selectedToggle[i] = i == index;
                    }
                  },
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 150.0,
                  ),
                  isSelected: _selectedToggle,
                  children: [
                    Text(AppLocalizations.of(context)!
                        .communityScreen_myCommunities),
                    Text(AppLocalizations.of(context)!
                        .communityScreen_allCommunities),
                  ],
                ),
                const SizedBox(height: 12),
                if (dataResponse.errorMessage != null) ...[
                  Text(AppLocalizations.of(context)!
                      .errorMessage(dataResponse.errorMessage!))
                ] else if (_page != null) ...[
                  CustomPaginatedList(_page!, onElementTap: (index) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityDetailScreen(
                                community: _page!.content[index]))).then((_) {
                      switch (_index) {
                        case 0:
                          context.read<CommunityCubit>().loadMyCommunities();
                          break;
                        case 1:
                          context.read<CommunityCubit>().loadAllCommunities();
                          break;
                      }
                    });
                  }, onPageChangeTap: (index) {
                    context
                        .read<CommunityCubit>()
                        .loadMyCommunities(pageNumber: index);
                  })
                ],
                const Spacer(),
                CustomButton(
                    AppLocalizations.of(context)!
                        .communityScreen_createCommunity,
                    Icons.add_circle, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityEditScreen()));
                }),
              ],
            );
          })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
