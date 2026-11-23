import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';

class BookingDetailCubit extends Cubit<DataResponse<ItemBooking>> {
  final BookingService _bookingService = getIt.get<BookingService>();

  BookingDetailCubit(super.initialState);

  factory BookingDetailCubit.ofInitialState({required ItemBooking booking}) {
    return BookingDetailCubit(DataResponse(data: booking, errorMessage: null));
  }

  Future<void> approve() async {
    final uuid = state.data?.uuid;
    if (uuid == null) return;
    final response = await _bookingService.approveBooking(uuid);
    emit(response);
  }

  Future<void> decline() async {
    final uuid = state.data?.uuid;
    if (uuid == null) return;
    final response = await _bookingService.declineBooking(uuid);
    emit(response);
  }

  Future<void> cancel() async {
    final uuid = state.data?.uuid;
    if (uuid == null) return;
    final response = await _bookingService.cancelBooking(uuid);
    emit(response);
  }

  /// "It is back with me again." Either party can say it: the borrower confirming they handed it back
  /// is as true a statement as the owner confirming they got it, which is the rule the backend applies.
  Future<void> markReturned() async {
    final uuid = state.data?.uuid;
    if (uuid == null) return;
    final response = await _bookingService.returnBooking(uuid);
    emit(response);
  }
}
