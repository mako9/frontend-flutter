import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/booking_date_range.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';

class BookingService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _itemPath = 'user/item';

  Future<DataResponse<ItemBooking>> bookItem(
      String itemUuid, DateTime startAt, DateTime endAt) async {
    final body = {
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt.toUtc().toIso8601String(),
    };
    final response = await _requestService.request(
      '$_itemPath/$itemUuid/booking',
      method: HttpMethod.post,
      body: body,
    );
    return _bookingFromResponse(response);
  }

  Future<DataResponse<DataPage<ItemBooking>>> getMyBookings(
      {int pageNumber = 0}) async {
    final response = await _requestService.request(
      '$_itemPath/booking',
      queryParameters: {
        'pageSize': '20',
        'pageNumber': pageNumber.toString()
      },
    );
    return _bookingPageFromResponse(response);
  }

  Future<DataResponse<DataPage<ItemBooking>>> getBookingsForItem(
      String itemUuid,
      {int pageNumber = 0}) async {
    final response = await _requestService.request(
      '$_itemPath/$itemUuid/booking',
      queryParameters: {
        'pageSize': '20',
        'pageNumber': pageNumber.toString()
      },
    );
    return _bookingPageFromResponse(response);
  }

  Future<DataResponse<ItemBooking>> getBooking(String bookingUuid) async {
    final response =
        await _requestService.request('$_itemPath/booking/$bookingUuid');
    return _bookingFromResponse(response);
  }

  Future<DataResponse<ItemBooking>> approveBooking(String bookingUuid) async {
    final response = await _requestService.request(
      '$_itemPath/booking/$bookingUuid/approve',
      method: HttpMethod.patch,
    );
    return _bookingFromResponse(response);
  }

  Future<DataResponse<ItemBooking>> declineBooking(String bookingUuid) async {
    final response = await _requestService.request(
      '$_itemPath/booking/$bookingUuid/decline',
      method: HttpMethod.patch,
    );
    return _bookingFromResponse(response);
  }

  Future<DataResponse<ItemBooking>> cancelBooking(String bookingUuid) async {
    final response = await _requestService.request(
      '$_itemPath/booking/$bookingUuid/cancel',
      method: HttpMethod.patch,
    );
    return _bookingFromResponse(response);
  }

  /// The bookings other neighbours made for my items.
  Future<DataResponse<DataPage<ItemBooking>>> getReceivedBookings(
      {int pageNumber = 0}) async {
    final response = await _requestService.request(
      '$_itemPath/booking/received',
      queryParameters: {
        'pageSize': '20',
        'pageNumber': pageNumber.toString()
      },
    );
    return _bookingPageFromResponse(response);
  }

  /// Marks the item back with its owner. Either side can do it, which is why there is no owner check
  /// here: the borrower confirming a handover is as true a statement as the owner doing it.
  Future<DataResponse<ItemBooking>> returnBooking(String bookingUuid) async {
    final response = await _requestService.request(
      '$_itemPath/booking/$bookingUuid/return',
      method: HttpMethod.patch,
    );
    return _bookingFromResponse(response);
  }

  /// The days of this item that are already booked, so the picker can refuse them.
  Future<DataResponse<List<BookingDateRange>>> getBookingDates(
      String itemUuid) async {
    final response =
        await _requestService.request('$_itemPath/$itemUuid/booking/dates');
    final json = response.getData();
    List<BookingDateRange>? ranges;
    if (json != null) {
      ranges = List<BookingDateRange>.from(
          (json as List).map((e) => BookingDateRange.fromJson(e)));
    }
    return DataResponse.fromHttpResponse(ranges, response);
  }

    DataResponse<ItemBooking> _bookingFromResponse(HttpDataResponse response) {
    final json = response.getData();
    ItemBooking? booking;
    if (json != null) booking = ItemBooking.fromJson(json);
    return DataResponse.fromHttpResponse(booking, response);
  }

  DataResponse<DataPage<ItemBooking>> _bookingPageFromResponse(
      HttpDataResponse response) {
    final json = response.getData();
    DataPage<ItemBooking>? page;
    if (json != null) page = DataPage.fromJson(json, ItemBooking.fromJson);
    return DataResponse.fromHttpResponse(page, response);
  }
}
