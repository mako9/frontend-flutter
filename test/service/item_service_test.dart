
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/util/json_util.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RequestService mockRequestService;
  late ItemService itemService;

  final item = Item(
      uuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
      name: 'Test',
      street: 'street',
      houseNumber: '9',
      postalCode: '10001',
      city: 'city',
      isActive: true,
      communityUuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
      userUuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
      availability: null,
      availableUntil: DateTime.now(),
      description: 'test',
  );

  final jsonResponse = {
    'uuid': item.uuid,
    'name': item.name,
    'street': item.street,
    'houseNumber': item.houseNumber,
    'postalCode': item.postalCode,
    'city': item.city,
    'active': item.isActive,
    'communityUuid': item.communityUuid,
    'availability': item.availability,
    'availableUntil': JsonUtil.parseDateTime(item.availableUntil),
    'description': item.description,
  };

  final Map<String, dynamic> jsonPage = {
    'content': [
      item.toJson(),
      {
        'uuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A9',
        'name': 'test 2',
        'street': 'street',
        'houseNumber': '9',
        'postalCode': '36039',
        'city': 'city',
        'communityUuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
        'availability': 'otherFirst',
        'availableUntil': '20221224T12:12:12-2000',
        'description': 'test2',
      }
    ],
    'pageNumber': 0,
    'pageSize': 10,
    'lastPage': true,
    'firstPage': true,
    'totalPages': 1,
    'totalElements': 2
  };

  setUpAll(() async {
    getServices();
    mockRequestService = MockRequestService();
    await getIt.unregister<RequestService>();
    getIt.registerLazySingleton<RequestService>(() => mockRequestService);
    itemService = ItemService();
  });

  test('when getting all items of a community, then a page of items is returned', () async {
    when(mockRequestService.request('user/item/${item.communityUuid}', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
    final dataResponse = await itemService.getAllItemsOfCommunity(item.communityUuid!);
    final page = dataResponse.data;

    expect(dataResponse.errorMessage, null);
    expect(page?.content.length, (jsonPage['content'] as List).length);
    expect(page?.totalElements, jsonPage['totalElements']);
    expect(page?.totalPages, jsonPage['totalPages']);
    expect(page?.isFirstPage, jsonPage['firstPage']);
    expect(page?.isLastPage, jsonPage['lastPage']);
    expect(page?.pageNumber, jsonPage['pageNumber']);
    expect(page?.pageSize, jsonPage['pageSize']);
  });

  test('when getting all items of a community with error, then a error message is returned', () async {
    when(mockRequestService.request('user/item/${item.communityUuid}', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
        const HttpJsonResponse(status: HttpStatus.badRequest, json: null));
    final dataResponse = await itemService.getAllItemsOfCommunity(item.communityUuid!);

    expect(dataResponse.errorMessage, HttpStatus.badRequest.name);
    expect(dataResponse.data, null);
  });

  test('when getting my items, then a page of items is returned', () async {
    when(mockRequestService.request('user/item/my', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
    final dataResponse = await itemService.getMyItems();
    final page = dataResponse.data;

    expect(dataResponse.errorMessage, null);
    expect(page?.content.length, (jsonPage['content'] as List).length);
    expect(page?.totalElements, jsonPage['totalElements']);
    expect(page?.totalPages, jsonPage['totalPages']);
    expect(page?.isFirstPage, jsonPage['firstPage']);
    expect(page?.isLastPage, jsonPage['lastPage']);
    expect(page?.pageNumber, jsonPage['pageNumber']);
    expect(page?.pageSize, jsonPage['pageSize']);
  });

  test('when getting my items with error, then a error message is returned', () async {
    when(mockRequestService.request('user/item/my', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.notFound, json: null));
    final dataResponse = await itemService.getMyItems();

    expect(dataResponse.errorMessage, HttpStatus.notFound.name);
    expect(dataResponse.data, null);
  });

  test('when getting items owned by me, then a page of items is returned', () async {
    when(mockRequestService.request('user/item/owned', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
    final dataResponse = await itemService.getItemsOwnedByMe();
    final page = dataResponse.data;

    expect(dataResponse.errorMessage, null);
    expect(page?.content.length, (jsonPage['content'] as List).length);
    expect(page?.totalElements, jsonPage['totalElements']);
    expect(page?.totalPages, jsonPage['totalPages']);
    expect(page?.isFirstPage, jsonPage['firstPage']);
    expect(page?.isLastPage, jsonPage['lastPage']);
    expect(page?.pageNumber, jsonPage['pageNumber']);
    expect(page?.pageSize, jsonPage['pageSize']);
  });

  test('when getting my items with error, then a error message is returned', () async {
    when(mockRequestService.request('user/item/owned', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.unauthorized, json: null));
    final dataResponse = await itemService.getItemsOwnedByMe();

    expect(dataResponse.errorMessage, HttpStatus.unauthorized.name);
    expect(dataResponse.data, null);
  });

  test('when getting item, then a page of items is returned', () async {
    when(mockRequestService.request('user/item/${item.uuid}')).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonResponse));
    final dataResponse = await itemService.getItem(item.uuid!);
    final data = dataResponse.data;

    expect(dataResponse.errorMessage, null);
    expect(data?.uuid, item.uuid);
    expect(data?.name, item.name);
    expect(data?.street, item.street);
    expect(data?.houseNumber, item.houseNumber);
    expect(data?.postalCode, item.postalCode);
    expect(data?.communityUuid, item.communityUuid);
    expect(data?.isActive, item.isActive);
    expect(data?.description, item.description);
    expect(data?.isOwner, item.isOwner);
  });

  test('when getting item with error, then a error message is returned', () async {
    when(mockRequestService.request('user/item/${item.uuid}')).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.notFound, json: null));
    final dataResponse = await itemService.getItem(item.uuid!);

    expect(dataResponse.errorMessage, HttpStatus.notFound.name);
    expect(dataResponse.data, null);
  });
}