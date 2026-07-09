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
    when(mockBookingService.getMyBookings()).thenAnswer((_) async => bookingResponse);
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
}
