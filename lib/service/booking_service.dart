import 'package:frontend_flutter/di/service_locator.dart';
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
