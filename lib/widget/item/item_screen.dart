import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../model/data_response.dart';
import '../../model/item.dart';
import 'item_card_view.dart';
import 'item_cubit.dart';
import 'item_detail_screen.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemCubit.ofInitialState(),
      child: const _ItemScreenContent(),
    );
  }
}

//ignore: must_be_immutable
class _ItemScreenContent extends StatelessWidget {
  const _ItemScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, DataResponse<Map<ItemCategory, List<Item>>>>(
        builder: (_, dataResponse) {
      return PlatformScaffold(
        body: ItemCardView(
            dataResponse.data,
            dataResponse.errorMessage,
            ((firstIndex, secondIndex) => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(
                              item: dataResponse.data?.values.elementAt(firstIndex)
                                  .elementAt(secondIndex))))
                })),
      );
    });
  }
}
