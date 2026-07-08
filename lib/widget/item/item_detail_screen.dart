
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/widget/item/item_detail_cubit.dart';
import 'package:intl/intl.dart';

import '../element/custom_button.dart';
import '../element/custom_image.dart';
import '../element/custom_key_value_column.dart';
import '../element/loading_overlay.dart';

class ItemDetailScreen extends StatelessWidget {
  late final Item? _initialItem;

  ItemDetailScreen({super.key, Item? item}) {
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

class _ItemDetailScreenContent extends StatefulWidget {
  const _ItemDetailScreenContent();

  @override
  State<_ItemDetailScreenContent> createState() =>
      _ItemDetailScreenContentState();
}

class _ItemDetailScreenContentState extends State<_ItemDetailScreenContent> {
  final BookingService _bookingService = getIt.get<BookingService>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _bookingError;
  bool _bookingSuccess = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _requestBooking(BuildContext context, String itemUuid) async {
    if (_startDate == null || _endDate == null) return;
    LoadingOverlay.of(context).show();
    final response =
        await _bookingService.bookItem(itemUuid, _startDate!, _endDate!);
    if (context.mounted) {
      LoadingOverlay.of(context).hide();
      setState(() {
        if (response.errorMessage != null) {
          _bookingError = response.errorMessage;
          _bookingSuccess = false;
        } else {
          _bookingError = null;
          _bookingSuccess = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Item? item;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.itemDetailScreen_title),
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
                          Text(
                              '${AppLocalizations.of(context)!.description}:'),
                          const SizedBox(width: 32),
                          Expanded(
                              child: Text(item?.description ?? '-',
                                  overflow: TextOverflow.visible)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  if (dataResponse.errorMessage != null) ...[
                    Text(
                      AppLocalizations.of(context)!
                          .errorMessage(dataResponse.errorMessage!),
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 30),
                  ],
                  if (item != null && !item!.isOwner) ...[
                    if (item!.requiresApproval) ...[
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!
                                .itemDetailScreen_approvalRequired,
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!
                            .itemDetailScreen_bookingStartDate),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.brown[300]),
                          onPressed: () => _selectStartDate(context),
                          child: Text(_startDate != null
                              ? DateFormat('dd.MM.yyyy').format(_startDate!)
                              : '-'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!
                            .itemDetailScreen_bookingEndDate),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.brown[300]),
                          onPressed: () => _selectEndDate(context),
                          child: Text(_endDate != null
                              ? DateFormat('dd.MM.yyyy').format(_endDate!)
                              : '-'),
                        ),
                      ],
                    ),
                    if (_bookingError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!
                            .errorMessage(_bookingError!),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    if (_bookingSuccess) ...[
                      const SizedBox(height: 8),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ],
                ]))),
            if (item != null && !item!.isOwner) ...[
              CustomButton(
                  AppLocalizations.of(context)!.itemDetailScreen_requestBooking,
                  Icons.calendar_today, () async {
                if (item?.uuid != null) {
                  await _requestBooking(context, item!.uuid!);
                }
              }),
            ],
          ]);
        }),
      ),
    );
  }
}
