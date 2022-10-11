import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';

import '../../model/community.dart';
import '../../model/data_page.dart';
import 'community_cubit.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => CommunityPageCubit(null),
       child: const _CommunityScreenContent(),
    );
  }
}

class _CommunityScreenContent extends StatelessWidget {
  const _CommunityScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(60.0),
          alignment: Alignment.topCenter,
          child: BlocBuilder<CommunityPageCubit, DataPage<Community>?>(
            builder: (_, communityPage) {
              if (communityPage == null) {
                LoadingOverlay.of(context).show();
                return const Text("empty page");
              }
              LoadingOverlay.of(context).hide();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Text(
                    'Communities',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: communityPage.content.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                                title: Text(communityPage.content[index].name!),
                            ));
                      }),
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(onPressed: (communityPage.pageNumber - 1 <= 0) ? null : () {
                          LoadingOverlay.of(context).show();
                          context.read<CommunityPageCubit>().loadOwnCommunity(communityPage.pageNumber - 1);
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
                            TextFormField(initialValue: (communityPage.pageNumber + 1).toString(), keyboardType: TextInputType.number,
                                onFieldSubmitted: (value) {
                                  if (int.parse(value) < 0 || int.parse(value) > communityPage.totalPages) {
                                    return;
                                  }
                                  LoadingOverlay.of(context).show();
                                  context.read<CommunityPageCubit>().loadOwnCommunity(int.parse(value) - 1);
                                })),
                            const SizedBox(width: 12),
                            Text('of ${communityPage.totalPages.toString()} pages')
                          ],
                        ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(onPressed: (communityPage.pageNumber + 1 >= communityPage.totalPages) ? null : () {
                          if (communityPage.pageNumber + 1 > communityPage.totalPages) { return; }
                          LoadingOverlay.of(context).show();
                          context.read<CommunityPageCubit>().loadOwnCommunity(communityPage.pageNumber + 1);
                        }, child: const Icon(Icons.navigate_next)),
                      ],
                    )
                  ),
                ],
              );
            }
          )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}