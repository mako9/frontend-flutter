import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RequestService mockRequestService;
  late BookingService bookingService;

  const bookingUuid = 'booking-uuid';
  const itemUuid = 'item-uuid';
  const userUuid = 'user-uuid';

  final Map<String, dynamic> bookingJson = {
    'uuid': bookingUuid,
    'itemUuid': itemUuid,
    'userUuid': userUuid,
    'status': 'confirmed',
    'startAt': null,
    'endAt': null,
    'createdAt': null,
    'cancelledBy': null,
    'cancelledAt': null,
  };

  final Map<String, dynamic> bookingPageJson = {
    'content': [bookingJson],
    'pageNumber': 0,
    'pageSize': 20,
    'firstPage': true,
    'lastPage': true,
    'totalPages': 1,
    'totalElements': 1,
  };

  setUpAll(() async {
    getServices();
    mockRequestService = MockRequestService();
    await getIt.unregister<RequestService>();
    getIt.registerLazySingleton<RequestService>(() => mockRequestService);
    bookingService = BookingService();
  });

  test('when booking item with success, then returns booking response', () async {
    final startAt = DateTime(2024, 1, 10, 9, 0);
    final endAt = DateTime(2024, 1, 10, 17, 0);
    when(mockRequestService.request(
      'user/item/$itemUuid/booking',
      method: HttpMethod.post,
      body: {
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
      },
    )).thenAnswer((_) async =>
        HttpDataResponse(status: HttpStatus.ok, data: bookingJson));

    final response = await bookingService.bookItem(itemUuid, startAt, endAt);

    expect(response.errorMessage, null);
    expect(response.data?.uuid, bookingUuid);
    expect(response.data?.itemUuid, itemUuid);
    expect(response.data?.status, BookingStatus.confirmed);
  });

  test('when booking item with error, then returns error message', () async {
    final startAt = DateTime(2024, 1, 10, 9, 0);
    final endAt = DateTime(2024, 1, 10, 17, 0);
    when(mockRequestService.request(
      'user/item/$itemUuid/booking',
      method: HttpMethod.post,
      body: {
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
      },
    )).thenAnswer((_) async =>
        const HttpDataResponse(status: HttpStatus.badRequest, data: null));

    final response = await bookingService.bookItem(itemUuid, startAt, endAt);

    expect(response.errorMessage, HttpStatus.badRequest.name);
    expect(response.data, null);
  });

  test('when getting my bookings with success, then returns page of bookings', () async {
    when(mockRequestService.request(
      'user/item/booking',
      queryParameters: {'pageSize': '20', 'pageNumber': '0'},
    )).thenAnswer((_) async =>
        HttpDataResponse(status: HttpStatus.ok, data: bookingPageJson));

    final response = await bookingService.getMyBookings();
    final page = response.data;

    expect(response.errorMessage, null);
    expect(page?.content.length, 1);
    expect(page?.content.first.uuid, bookingUuid);
    expect(page?.totalElements, 1);
    expect(page?.isFirstPage, true);
    expect(page?.isLastPage, true);
  });

  test('when getting my bookings with error, then returns error message', () async {
    when(mockRequestService.request(
      'user/item/booking',
      queryParameters: {'pageSize': '20', 'pageNumber': '0'},
    )).thenAnswer((_) async =>
        const HttpDataResponse(status: HttpStatus.unauthorized, data: null));

    final response = await bookingService.getMyBookings();

    expect(response.errorMessage, HttpStatus.unauthorized.name);
    expect(response.data, null);
  });

  test('when approving booking with success, then returns updated booking', () async {
    final confirmedJson = Map<String, dynamic>.from(bookingJson)
      ..['status'] = 'confirmed';
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/approve',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        HttpDataResponse(status: HttpStatus.ok, data: confirmedJson));

    final response = await bookingService.approveBooking(bookingUuid);

    expect(response.errorMessage, null);
    expect(response.data?.uuid, bookingUuid);
    expect(response.data?.status, BookingStatus.confirmed);
  });

  test('when approving booking with error, then returns error message', () async {
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/approve',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        const HttpDataResponse(status: HttpStatus.notFound, data: null));

    final response = await bookingService.approveBooking(bookingUuid);

    expect(response.errorMessage, HttpStatus.notFound.name);
    expect(response.data, null);
  });

  test('when declining booking with success, then returns updated booking', () async {
    final declinedJson = Map<String, dynamic>.from(bookingJson)
      ..['status'] = 'declined';
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/decline',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        HttpDataResponse(status: HttpStatus.ok, data: declinedJson));

    final response = await bookingService.declineBooking(bookingUuid);

    expect(response.errorMessage, null);
    expect(response.data?.uuid, bookingUuid);
    expect(response.data?.status, BookingStatus.declined);
  });

  test('when declining booking with error, then returns error message', () async {
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/decline',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        const HttpDataResponse(status: HttpStatus.notFound, data: null));

    final response = await bookingService.declineBooking(bookingUuid);

    expect(response.errorMessage, HttpStatus.notFound.name);
    expect(response.data, null);
  });

  test('when cancelling booking with success, then returns updated booking', () async {
    final cancelledJson = Map<String, dynamic>.from(bookingJson)
      ..['status'] = 'cancelled';
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/cancel',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        HttpDataResponse(status: HttpStatus.ok, data: cancelledJson));

    final response = await bookingService.cancelBooking(bookingUuid);

    expect(response.errorMessage, null);
    expect(response.data?.uuid, bookingUuid);
    expect(response.data?.status, BookingStatus.cancelled);
  });

  test('when cancelling booking with error, then returns error message', () async {
    when(mockRequestService.request(
      'user/item/booking/$bookingUuid/cancel',
      method: HttpMethod.patch,
    )).thenAnswer((_) async =>
        const HttpDataResponse(status: HttpStatus.notFound, data: null));

    final response = await bookingService.cancelBooking(bookingUuid);

    expect(response.errorMessage, HttpStatus.notFound.name);
    expect(response.data, null);
  });
}
