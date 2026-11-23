import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';

class BookingState {
  final DataPage<ItemBooking>? myBookings;
  final DataPage<ItemBooking>? lenderBookings;
  final String? errorMessage;

  BookingState({this.myBookings, this.lenderBookings, this.errorMessage});
}

class BookingCubit extends Cubit<DataResponse<BookingState>> {
  final BookingService _bookingService = getIt.get<BookingService>();

  BookingCubit(super.initialState) {
    loadMyBookings();
    loadLenderBookings();
  }

  factory BookingCubit.ofInitialState() {
    return BookingCubit(DataResponse.empty());
  }

  Future<void> loadMyBookings({int pageNumber = 0}) async {
    final response =
        await _bookingService.getMyBookings(pageNumber: pageNumber);
    emit(DataResponse(
      data: BookingState(
          myBookings: response.data,
          lenderBookings: state.data?.lenderBookings),
      errorMessage: response.errorMessage,
    ));
  }

  /// The requests other neighbours made for my items. Kept in the same state as my own bookings and
  /// merged field-by-field, because whichever of the two loads answers last is the one that writes the
  /// state - a whole-state replace would blank out the page that answered first.
  Future<void> loadLenderBookings({int pageNumber = 0}) async {
    final response =
        await _bookingService.getReceivedBookings(pageNumber: pageNumber);
    emit(DataResponse(
      data: BookingState(
          myBookings: state.data?.myBookings, lenderBookings: response.data),
      errorMessage: response.errorMessage,
    ));
  }
}
