import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/widget/booking/booking_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BookingService mockBookingService;
  late BookingCubit bookingCubit;

  final booking = ItemBooking(
    uuid: 'b1',
    itemUuid: 'i1',
    userUuid: 'u1',
    status: BookingStatus.pending,
  );

  final bookingPage = DataPage<ItemBooking>(
    content: [booking],
    isFirstPage: true,
    isLastPage: true,
    pageNumber: 0,
    pageSize: 20,
    totalElements: 1,
    totalPages: 1,
  );

  final bookingResponse = DataResponse<DataPage<ItemBooking>>(
    data: bookingPage,
    errorMessage: null,
  );

  final errorResponse = DataResponse<DataPage<ItemBooking>>(
    data: null,
    errorMessage: 'error',
  );

  setUpAll(() async {
    getServices();
    mockBookingService = MockBookingService();
    await getIt.unregister<BookingService>();
    getIt.registerLazySingleton<BookingService>(() => mockBookingService);
    when(mockBookingService.getMyBookings())
        .thenAnswer((_) async => bookingResponse);
    // the cubit loads both pages on construction, so both need a stub before it is built
    when(mockBookingService.getReceivedBookings())
        .thenAnswer((_) async => bookingResponse);
    bookingCubit = BookingCubit(DataResponse.empty());
  });

  test('when loading my bookings with success, then state contains bookings', () async {
    await bookingCubit.loadMyBookings();
    expect(bookingCubit.state.data?.myBookings?.content, [booking]);
  });

  test('when loading my bookings fails, then state has error', () async {
    when(mockBookingService.getMyBookings()).thenAnswer((_) async => errorResponse);
    await bookingCubit.loadMyBookings();
    expect(bookingCubit.state.errorMessage, 'error');
  });

  // the lender's view is a second page, not a replacement: switching to it must not blank out the
  // bookings the same user made as a borrower
  test('when loading lender bookings, then both pages are kept', () async {
    final lenderBooking = ItemBooking(
      uuid: 'b2',
      itemUuid: 'i1',
      userUuid: 'u2',
      status: BookingStatus.pending,
      isItemOwner: true,
    );
    when(mockBookingService.getMyBookings())
        .thenAnswer((_) async => bookingResponse);
    when(mockBookingService.getReceivedBookings()).thenAnswer((_) async =>
        DataResponse<DataPage<ItemBooking>>(
            data: DataPage<ItemBooking>(
                content: [lenderBooking],
                isFirstPage: true,
                isLastPage: true,
                pageNumber: 0,
                pageSize: 20,
                totalElements: 1,
                totalPages: 1),
            errorMessage: null));

    // both are fired from the constructor and can answer in either order, so the test lets them overlap
    await Future.wait([
      bookingCubit.loadMyBookings(),
      bookingCubit.loadLenderBookings(),
    ]);

    expect(bookingCubit.state.data?.lenderBookings?.content, [lenderBooking]);
    expect(bookingCubit.state.data?.myBookings?.content, [booking]);
  });

  test('when loading lender bookings fails, then state has error', () async {
    when(mockBookingService.getReceivedBookings())
        .thenAnswer((_) async => errorResponse);

    await bookingCubit.loadLenderBookings();

    expect(bookingCubit.state.errorMessage, 'error');
  });
}
