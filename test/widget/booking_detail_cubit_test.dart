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

  group('approve', () {
    test('when approving with success, then status becomes CONFIRMED',
        () async {
      when(mockBookingService.approveBooking(pending.uuid!))
          .thenAnswer((_) async => confirmedResponse);

      await bookingDetailCubit.approve();

      expect(bookingDetailCubit.state.data?.status, BookingStatus.confirmed);
    });

    test('when approving with error, then state has error', () async {
      when(mockBookingService.approveBooking(pending.uuid!)).thenAnswer(
          (_) async =>
              DataResponse<ItemBooking>(data: null, errorMessage: 'error'));

      await bookingDetailCubit.approve();

      expect(bookingDetailCubit.state.errorMessage, 'error');
    });
  });

  group('decline', () {
    test('when declining with success, then status becomes DECLINED', () async {
      when(mockBookingService.declineBooking(pending.uuid!))
          .thenAnswer((_) async => declinedResponse);

      await bookingDetailCubit.decline();

      expect(bookingDetailCubit.state.data?.status, BookingStatus.declined);
    });
  });

  group('cancel', () {
    test('when cancelling with success, then status becomes CANCELLED',
        () async {
      when(mockBookingService.cancelBooking(pending.uuid!))
          .thenAnswer((_) async => cancelledResponse);

      await bookingDetailCubit.cancel();

      expect(bookingDetailCubit.state.data?.status, BookingStatus.cancelled);
    });
  });

  test('when marking returned with success, then state is RETURNED', () async {
    final returned = ItemBooking(uuid: 'b1', status: BookingStatus.returned);
    when(mockBookingService.returnBooking(pending.uuid!)).thenAnswer(
        (_) async =>
            DataResponse<ItemBooking>(data: returned, errorMessage: null));

    await bookingDetailCubit.markReturned();

    expect(bookingDetailCubit.state.data?.status, BookingStatus.returned);
  });

  // An error response carries no booking, so "emit whatever came back" would blank the state - and every
  // action starts by reading the uuid out of the state, which would leave the screen able to do nothing at
  // all for the rest of its life. The retry is what proves the difference: had the booking been wiped, the
  // second tap would be a silent no-op.
  test('a failed action keeps the booking and a retry still reaches the server',
      () async {
    final returned = ItemBooking(uuid: 'b1', status: BookingStatus.returned);
    final answers = [
      DataResponse<ItemBooking>(data: null, errorMessage: 'error'),
      DataResponse<ItemBooking>(data: returned, errorMessage: null),
    ];
    when(mockBookingService.returnBooking(pending.uuid!))
        .thenAnswer((_) async => answers.removeAt(0));

    await bookingDetailCubit.markReturned();

    expect(bookingDetailCubit.state.errorMessage, 'error');
    expect(bookingDetailCubit.state.data?.uuid, 'b1');

    await bookingDetailCubit.markReturned();

    expect(bookingDetailCubit.state.errorMessage, isNull);
    expect(bookingDetailCubit.state.data?.status, BookingStatus.returned);
  });
}
