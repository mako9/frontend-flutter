import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/widget/element/custom_paginated_list.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';
import 'package:frontend_flutter/widget/item/item_card_view.dart';

import '../../model/community.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../community/community_edit_screen.dart';
import '../element/custom_button.dart';
import '../item/item_edit_screen.dart';
import 'my_area_cubit.dart';

class MyAreaScreen extends StatelessWidget {
  const MyAreaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAreaCubit.ofInitialState(),
      child: _MyAreaScreenContent(),
    );
  }
}

class _MyAreaScreenContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAreaScreenContentState();
  }

}

//ignore: must_be_immutable
class _MyAreaScreenContentState extends State<_MyAreaScreenContent> {

  final List<bool> _selectedToggle = <bool>[true, false];
  bool _isInitialized = false;
  int _index = 0;
  Map<ItemCategory, List<Item>>? _groupedItems;
  DataPage<Community>? _communityPage;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.topCenter,
          child: BlocBuilder<MyAreaCubit, DataResponse<MyAreaState>>(
              builder: (_, dataResponse) {
                _groupedItems = dataResponse.data?.items;
            _communityPage = dataResponse.data?.communities;
            _errorMessage = dataResponse.errorMessage;
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
                    setState(() {
                      _index = index;
                      for (int i = 0; i < _selectedToggle.length; i++) {
                        _selectedToggle[i] = i == index;
                      }
                    });
                  },
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 150.0,
                  ),
                  isSelected: _selectedToggle,
                  children: [
                    Text(AppLocalizations.of(context)!
                        .myAreaScreen_myItems),
                    Text(AppLocalizations.of(context)!
                        .myAreaScreen_myCommunities),
                  ],
                ),
                const SizedBox(height: 12),
                if (dataResponse.errorMessage != null) ...[
                  Text(AppLocalizations.of(context)!
                      .errorMessage(dataResponse.errorMessage!))
                ] else if (_index == 0) ...[
                  Expanded(child: ItemCardView(_groupedItems, _errorMessage, (firstIndex, secondIndex) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemEditScreen(item: _groupedItems?.values.elementAt(firstIndex).elementAt(secondIndex))
                        )
                    );
                  })
                  )
                ] else ...[
                CustomPaginatedList(_communityPage!, onElementTap: (index) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityEditScreen(community: _communityPage?.content[index])
                      )
                  );
                }, onPageChangeTap: (index) {
                context
                    .read<MyAreaCubit>()
                    .loadCommunitiesOwnedByMe(pageNumber: index);
                }),
                  const Spacer(),
                ],
                const SizedBox(height: 16.0),
                if (_index == 0) ...[
                  CustomButton(
                      AppLocalizations.of(context)!
                          .myAreaScreen_createItem,
                      Icons.add_circle, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemEditScreen()));
                  })
                ] else ...[
                  CustomButton(
                      AppLocalizations.of(context)!
                          .myAreaScreen_createCommunity,
                      Icons.add_circle, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityEditScreen()));
                  })
                ],
              ],
            );
          })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
