import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend_flutter/widget/item/item_detail_cubit.dart';

import '../../model/data_response.dart';
import '../../model/item.dart';
import '../element/custom_button.dart';
import '../element/custom_image.dart';
import '../element/custom_key_value_column.dart';
import '../element/loading_overlay.dart';

class ItemDetailScreen extends StatelessWidget {
  late final Item? _initialItem;

  ItemDetailScreen({Key? key, Item? item}) : super(key: key) {
    _initialItem = item;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemDetailCubit.ofInitialState(item: _initialItem),
      child: const LoadingOverlay(child: _ItemDetailScreenContent()),
    );
  }
}

class _ItemDetailScreenContent extends StatelessWidget {
  const _ItemDetailScreenContent();

  @override
  Widget build(BuildContext context) {
    Item? item;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title:
            PlatformText(AppLocalizations.of(context)!.itemDetailScreen_title),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        alignment: Alignment.topCenter,
        child: BlocBuilder<ItemDetailCubit, DataResponse<Item>>(
            builder: (_, dataResponse) {
          if (dataResponse.data != null) {
            item = dataResponse.data;
          }
          LoadingOverlay.of(context).hide();
          return Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                    CustomImage(item?.imageData),
                    const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                        color: Colors.brown[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(children: [
                      Row(children: [
                        CustomKeyValueColumn(
                            AppLocalizations.of(context)!.name, item?.name),
                      ]),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.street,
                              item?.street),
                          const SizedBox(width: 32),
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.houseNumber,
                              item?.houseNumber),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.postalCode,
                              item?.postalCode),
                          const SizedBox(width: 32),
                          CustomKeyValueColumn(
                              AppLocalizations.of(context)!.city, item?.city),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlatformText(
                              '${AppLocalizations.of(context)!.description}:'),
                          const SizedBox(width: 32),
                          Expanded(
                              child: PlatformText(item?.description ?? '-',
                                  overflow: TextOverflow.visible)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  if (dataResponse.errorMessage != null) ...[
                    PlatformText(
                      AppLocalizations.of(context)!
                          .errorMessage(dataResponse.errorMessage!),
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 30),
                  ],
                ]))),
            CustomButton(
                AppLocalizations.of(context)!.itemDetailScreen_rentItem,
                Icons.cached, () async {
              // TODO
              debugPrint('Not implemented yet.');
            }),
          ]);
        }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
