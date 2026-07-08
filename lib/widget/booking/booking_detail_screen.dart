import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/widget/booking/booking_detail_cubit.dart';
import 'package:frontend_flutter/widget/element/custom_button.dart';
import 'package:frontend_flutter/widget/element/custom_key_value_column.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';
import 'package:intl/intl.dart';

class BookingDetailScreen extends StatelessWidget {
  final ItemBooking booking;
  final bool isOwner;

  const BookingDetailScreen(
      {super.key, required this.booking, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingDetailCubit.ofInitialState(booking: booking),
      child: LoadingOverlay(child: _BookingDetailScreenContent(isOwner: isOwner)),
    );
  }
}

class _BookingDetailScreenContent extends StatelessWidget {
  final bool isOwner;
  const _BookingDetailScreenContent({required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.bookingDetailScreen_title)),
      body: BlocBuilder<BookingDetailCubit, DataResponse<ItemBooking>>(
        builder: (_, response) {
          final booking = response.data;
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusChip(context, booking?.status),
                const SizedBox(height: 16),
                CustomKeyValueColumn(
                    AppLocalizations.of(context)!.bookingDetailScreen_from,
                    booking?.startAt != null
                        ? DateFormat('dd.MM.yyyy').format(booking!.startAt!)
                        : '-'),
                const SizedBox(height: 8),
                CustomKeyValueColumn(
                    AppLocalizations.of(context)!.bookingDetailScreen_to,
                    booking?.endAt != null
                        ? DateFormat('dd.MM.yyyy').format(booking!.endAt!)
                        : '-'),
                if (response.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)!
                          .errorMessage(response.errorMessage!),
                      style: const TextStyle(color: Colors.red)),
                ],
                const Spacer(),
                if (isOwner &&
                    booking?.status == BookingStatus.pending) ...[
                  CustomButton(
                      AppLocalizations.of(context)!.bookingDetailScreen_approve,
                      Icons.check, () async {
                    LoadingOverlay.of(context).show();
                    await context.read<BookingDetailCubit>().approve();
                    if (context.mounted) {
                      LoadingOverlay.of(context).hide();
                      Navigator.pop(context);
                    }
                  }),
                  const SizedBox(height: 8),
                  CustomButton(
                      AppLocalizations.of(context)!.bookingDetailScreen_decline,
                      Icons.close, () async {
                    LoadingOverlay.of(context).show();
                    await context.read<BookingDetailCubit>().decline();
                    if (context.mounted) {
                      LoadingOverlay.of(context).hide();
                      Navigator.pop(context);
                    }
                  }),
                ],
                if ((booking?.status == BookingStatus.pending ||
                        booking?.status == BookingStatus.confirmed) &&
                    booking?.startAt != null &&
                    booking!.startAt!.isAfter(DateTime.now())) ...[
                  const SizedBox(height: 8),
                  CustomButton(
                      AppLocalizations.of(context)!.bookingDetailScreen_cancel,
                      Icons.cancel, () async {
                    LoadingOverlay.of(context).show();
                    await context.read<BookingDetailCubit>().cancel();
                    if (context.mounted) {
                      LoadingOverlay.of(context).hide();
                      Navigator.pop(context);
                    }
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(BuildContext context, BookingStatus? status) {
    final label = switch (status) {
      BookingStatus.pending =>
        AppLocalizations.of(context)!.bookingStatus_pending,
      BookingStatus.confirmed =>
        AppLocalizations.of(context)!.bookingStatus_confirmed,
      BookingStatus.declined =>
        AppLocalizations.of(context)!.bookingStatus_declined,
      BookingStatus.cancelled =>
        AppLocalizations.of(context)!.bookingStatus_cancelled,
      null => '-',
    };
    final color = switch (status) {
      BookingStatus.pending => Colors.orange,
      BookingStatus.confirmed => Colors.green,
      BookingStatus.declined => Colors.red,
      BookingStatus.cancelled => Colors.grey,
      null => Colors.grey,
    };
    return Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: color);
  }
}
