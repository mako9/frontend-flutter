
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RequestService mockRequestService;
  late CommunityService communityService;

  const jsonPage = {
    'content': [
      {
        'uuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
        'name': 'test',
        'street': 'street',
        'houseNumber': '9',
        'postalCode': '36039',
        'city': 'city',
        'adminUuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
        'radius': 10
      },
      {
        'uuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A9',
        'name': 'test 2',
        'street': 'street',
        'houseNumber': '9',
        'postalCode': '36039',
        'city': 'city',
        'adminUuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
        'radius': 10
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
    communityService = CommunityService();
  });

  test('when getting all communities, then a page of communities is returned', () async {
    when(mockRequestService.request('user/community', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
    final dataResponse = await communityService.getAllCommunities();
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

  test('when getting all communities with error, then null returned', () async {
    when(mockRequestService.request('user/community', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.badGateway, json: null));
    final dataResponse = await communityService.getAllCommunities();

    expect(null, dataResponse.data);
    expect(HttpStatus.badGateway.name, dataResponse.errorMessage);
  });

  test('when getting my communities, then a page of communities is returned', () async {
    when(mockRequestService.request('user/community/my', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
    final dataResponse = await communityService.getMyCommunities();
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

  test('when getting my communities with error, then null returned', () async {
    when(mockRequestService.request('user/community/my', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.getMyCommunities();

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });
}