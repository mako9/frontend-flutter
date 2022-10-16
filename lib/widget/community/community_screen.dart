import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';

import '../../model/community.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import 'community_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(60.0),
          alignment: Alignment.topCenter,
          child: BlocBuilder<CommunityCubit, DataResponse<DataPage<Community>>>(
            builder: (_, dataResponse) {
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
                  const SizedBox(height: 30),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
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
                      Text(AppLocalizations.of(context)!.communityScreen_myCommunities),
                      Text(AppLocalizations.of(context)!.communityScreen_allCommunities),
                    ],
                  ),
                  if (dataResponse.errorMessage != null) ...[
                    Text(AppLocalizations.of(context)!.errorMessage(dataResponse.errorMessage!))]
                  else if (page != null && page.content.isNotEmpty) ...[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataResponse.data?.content.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                                  title: Text(page.content[index].name!),
                              ));
                        }),
                    const Spacer(),
                    if (page.content.length > 10) ...[
                      SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(onPressed: (page.pageNumber - 1 <= 0) ? null : () {
                                LoadingOverlay.of(context).show();
                                context.read<CommunityCubit>().loadMyCommunities(pageNumber: page.pageNumber - 1);
                              }, child: const Icon(Icons.navigate_before)),
                              const SizedBox(width: 12),
                              Flexible(child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      width: 24,
                                      child:
                                      TextFormField(initialValue: (page.pageNumber + 1).toString(), keyboardType: TextInputType.number,
                                          onFieldSubmitted: (value) {
                                            if (int.parse(value) < 0 || int.parse(value) > page.totalPages) {
                                              return;
                                            }
                                            LoadingOverlay.of(context).show();
                                            context.read<CommunityCubit>().loadMyCommunities(pageNumber: int.parse(value) - 1);
                                          })),
                                  const SizedBox(width: 12),
                                  Text(AppLocalizations.of(context)!.communityScreen_ofPages(page.totalPages))
                                ],
                              ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(onPressed: (page.pageNumber + 1 >= page.totalPages) ? null : () {
                                if (page.pageNumber + 1 > page.totalPages) { return; }
                                LoadingOverlay.of(context).show();
                                context.read<CommunityCubit>().loadMyCommunities(pageNumber: page.pageNumber + 1);
                              }, child: const Icon(Icons.navigate_next)),
                            ],
                          )
                      ),
                    ]
                  ]
                ],
              );
            }
          )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}