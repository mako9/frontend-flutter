import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/widget/booking/booking_cubit.dart';
import 'package:frontend_flutter/widget/booking/booking_detail_screen.dart';
import 'package:frontend_flutter/widget/element/custom_paginated_list.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';
import 'package:frontend_flutter/widget/item/item_card_view.dart';
import 'package:intl/intl.dart';

import '../../model/community.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../community/community_edit_screen.dart';
import '../element/custom_button.dart';
import '../item/item_edit_screen.dart';
import 'my_area_cubit.dart';

class MyAreaScreen extends StatelessWidget {
  const MyAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MyAreaCubit.ofInitialState()),
        BlocProvider(create: (_) => BookingCubit.ofInitialState()),
      ],
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
  final List<bool> _selectedToggle = <bool>[true, false, false];
  bool _isInitialized = false;
  int _index = 0;
  Map<ItemCategory, List<Item>>? _groupedItems;
  DataPage<Community>? _communityPage;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    minWidth: 100.0,
                  ),
                  isSelected: _selectedToggle,
                  children: [
                    Text(AppLocalizations.of(context)!.myAreaScreen_myItems),
                    Text(AppLocalizations.of(context)!
                        .myAreaScreen_myCommunities),
                    Text(
                        AppLocalizations.of(context)!.myAreaScreen_myBookings),
                  ],
                ),
                const SizedBox(height: 12),
                if (dataResponse.errorMessage != null) ...[
                  Text(AppLocalizations.of(context)!
                      .errorMessage(dataResponse.errorMessage!))
                ] else if (_index == 0) ...[
                  Expanded(
                      child: ItemCardView(
                          _groupedItems, _errorMessage, (firstIndex, secondIndex) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemEditScreen(
                                item: _groupedItems?.values
                                    .elementAt(firstIndex)
                                    .elementAt(secondIndex))));
                  }))
                ] else if (_index == 1) ...[
                  CustomPaginatedList(_communityPage!, onElementTap: (index) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityEditScreen(
                                community: _communityPage?.content[index])));
                  }, onPageChangeTap: (index) {
                    context
                        .read<MyAreaCubit>()
                        .loadCommunitiesOwnedByMe(pageNumber: index);
                  }),
                  const Spacer(),
                ] else ...[
                  Expanded(child: _BookingsList()),
                ],
                const SizedBox(height: 16.0),
                if (_index == 0) ...[
                  CustomButton(
                      AppLocalizations.of(context)!.myAreaScreen_createItem,
                      Icons.add_circle, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemEditScreen()));
                  })
                ] else if (_index == 1) ...[
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
          })),
    );
  }
}

class _BookingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, DataResponse<BookingState>>(
      builder: (_, response) {
        final bookings = response.data?.myBookings?.content ?? [];
        if (bookings.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.emptyList));
        }
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return ListTile(
              title: Text(
                  '${_formatDate(booking.startAt)} - ${_formatDate(booking.endAt)}'),
              subtitle: Text(_statusLabel(context, booking.status)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailScreen(
                      booking: booking,
                      isOwner: false,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String _statusLabel(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppLocalizations.of(context)!.bookingStatus_pending;
      case BookingStatus.confirmed:
        return AppLocalizations.of(context)!.bookingStatus_confirmed;
      case BookingStatus.declined:
        return AppLocalizations.of(context)!.bookingStatus_declined;
      case BookingStatus.cancelled:
        return AppLocalizations.of(context)!.bookingStatus_cancelled;
    }
  }
}
