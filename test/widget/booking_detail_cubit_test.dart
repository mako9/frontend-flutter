import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/widget/booking/booking_detail_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BookingService mockBookingService;
  late BookingDetailCubit bookingDetailCubit;

  final pending = ItemBooking(uuid: 'b1', status: BookingStatus.pending);
  final confirmed = ItemBooking(uuid: 'b1', status: BookingStatus.confirmed);
  final declined = ItemBooking(uuid: 'b1', status: BookingStatus.declined);
  final cancelled = ItemBooking(uuid: 'b1', status: BookingStatus.cancelled);

  final confirmedResponse = DataResponse<ItemBooking>(
    data: confirmed,
    errorMessage: null,
  );
  final declinedResponse = DataResponse<ItemBooking>(
    data: declined,
    errorMessage: null,
  );
  final cancelledResponse = DataResponse<ItemBooking>(
    data: cancelled,
    errorMessage: null,
  );

  setUpAll(() async {
    getServices();
    mockBookingService = MockBookingService();
    await getIt.unregister<BookingService>();
    getIt.registerLazySingleton<BookingService>(() => mockBookingService);
    bookingDetailCubit = BookingDetailCubit.ofInitialState(booking: pending);
  });

  test('when approving booking with success, then state is CONFIRMED', () async {
    when(mockBookingService.approveBooking(pending.uuid!))
        .thenAnswer((_) async => confirmedResponse);
    await bookingDetailCubit.approve();
    expect(bookingDetailCubit.state.data?.status, BookingStatus.confirmed);
  });

  test('when declining booking with success, then state is DECLINED', () async {
    bookingDetailCubit = BookingDetailCubit.ofInitialState(booking: pending);
    when(mockBookingService.declineBooking(pending.uuid!))
        .thenAnswer((_) async => declinedResponse);
    await bookingDetailCubit.decline();
    expect(bookingDetailCubit.state.data?.status, BookingStatus.declined);
  });

  test('when cancelling booking with success, then state is CANCELLED', () async {
    bookingDetailCubit = BookingDetailCubit.ofInitialState(booking: confirmed);
    when(mockBookingService.cancelBooking(confirmed.uuid!))
        .thenAnswer((_) async => cancelledResponse);
    await bookingDetailCubit.cancel();
    expect(bookingDetailCubit.state.data?.status, BookingStatus.cancelled);
  });
}
