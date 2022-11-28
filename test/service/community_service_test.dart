
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RequestService mockRequestService;
  late CommunityService communityService;

  final community = Community(
      uuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
      name: 'Test',
      street: 'street',
      houseNumber: '9',
      postalCode: '10001',
      city: 'city',
      radius: 10,
      latitude: 0.0,
      longitude: 0.0,
      isAdmin: true,
      adminUuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
      adminFirstName: 'first',
      adminLastName: 'last');

  final jsonResponse = {
    'uuid': community.uuid,
    'name': community.name,
    'street': community.street,
    'houseNumber': community.houseNumber,
    'postalCode': community.postalCode,
    'city': community.city,
    'adminUuid': community.adminUuid,
    'radius': community.radius,
    'latitude': community.latitude,
    'longitude': community.longitude,
    'admin': true,
    'adminFirstName': community.adminFirstName,
    'adminLastName': community.adminFirstName
  };

  final Map<String, dynamic> jsonPage = {
    'content': [
      community.toJson(),
      {
        'uuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A9',
        'name': 'test 2',
        'street': 'street',
        'houseNumber': '9',
        'postalCode': '36039',
        'city': 'city',
        'adminUuid': 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
        'radius': 10,
        'latiutde': 5,
        'longitude': 8.0932,
        'adminFirstName': 'otherFirst',
        'adminLastName': 'otherLast'
      }
    ],
    'pageNumber': 0,
    'pageSize': 10,
    'lastPage': true,
    'firstPage': true,
    'totalPages': 1,
    'totalElements': 2
  };

  final List<String> userUuids = [
    'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
    'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A9',
  ];

  final List<Map<String, dynamic>> userList = [
      {
        'uuid': userUuids[0],
        'firstName': '1',
        'lastName': '1',
      },
    {
      'uuid': userUuids[1],
      'firstName': '2',
      'lastName': '2',
      }
  ];

  final Map<String, dynamic> memberJsonPage = {
    'content': userList,
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
        HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
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
        HttpJsonResponse(status: HttpStatus.ok, json: jsonPage));
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

  test('when creating a community successfully, then new community is returned', () async {
    when(mockRequestService.request('user/community', method: HttpMethod.post, body: community)).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonResponse));
    final dataResponse = await communityService.createCommunity(community);

    expect(community.uuid, dataResponse.data?.uuid);
    expect(community.name, dataResponse.data?.name);
    expect(community.street, dataResponse.data?.street);
    expect(community.houseNumber, dataResponse.data?.houseNumber);
    expect(community.postalCode, dataResponse.data?.postalCode);
    expect(community.city, dataResponse.data?.city);
    expect(community.adminUuid, dataResponse.data?.adminUuid);
    expect(community.isAdmin, dataResponse.data?.isAdmin);
    expect(community.radius, dataResponse.data?.radius);
    expect(community.latitude, dataResponse.data?.latitude);
    expect(community.longitude, dataResponse.data?.longitude);
    expect(null, dataResponse.errorMessage);
  });

  test('when creating a community unsuccessfully, then error is returned', () async {
    when(mockRequestService.request('user/community', method: HttpMethod.post, body: community)).thenAnswer((_) async =>
        const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.createCommunity(community);

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });

  test('when editing a community successfully, then edited community is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}', method: HttpMethod.patch, body: community)).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonResponse));
    final dataResponse = await communityService.updateCommunity(community);

    expect(community.uuid, dataResponse.data?.uuid);
    expect(community.name, dataResponse.data?.name);
    expect(community.street, dataResponse.data?.street);
    expect(community.houseNumber, dataResponse.data?.houseNumber);
    expect(community.postalCode, dataResponse.data?.postalCode);
    expect(community.city, dataResponse.data?.city);
    expect(community.adminUuid, dataResponse.data?.adminUuid);
    expect(community.isAdmin, dataResponse.data?.isAdmin);
    expect(community.radius, dataResponse.data?.radius);
    expect(community.latitude, dataResponse.data?.latitude);
    expect(community.longitude, dataResponse.data?.longitude);
    expect(null, dataResponse.errorMessage);
  });

  test('when editing a community unsuccessfully, then error is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}', method: HttpMethod.patch, body: community)).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.badRequest, json: null));
    final dataResponse = await communityService.updateCommunity(community);

    expect(null, dataResponse.data);
    expect(HttpStatus.badRequest.name, dataResponse.errorMessage);
  });

  test('when getting a community successfully, then community is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}')).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: jsonResponse));
    final dataResponse = await communityService.getCommunity(community.uuid!);

    expect(community.uuid, dataResponse.data?.uuid);
    expect(community.name, dataResponse.data?.name);
    expect(community.street, dataResponse.data?.street);
    expect(community.houseNumber, dataResponse.data?.houseNumber);
    expect(community.postalCode, dataResponse.data?.postalCode);
    expect(community.city, dataResponse.data?.city);
    expect(community.adminUuid, dataResponse.data?.adminUuid);
    expect(community.isAdmin, dataResponse.data?.isAdmin);
    expect(community.radius, dataResponse.data?.radius);
    expect(community.latitude, dataResponse.data?.latitude);
    expect(community.longitude, dataResponse.data?.longitude);
    expect(null, dataResponse.errorMessage);
  });

  test('when getting a community unsuccessfully, then error is returned', () async {
    when(mockRequestService.request('user/community/unknown')).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.notFound, json: null));
    final dataResponse = await communityService.getCommunity('unknown');

    expect(null, dataResponse.data);
    expect(HttpStatus.notFound.name, dataResponse.errorMessage);
  });

  test('when getting community member successfully, then page of user is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/member', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: memberJsonPage));
    final dataResponse = await communityService.getCommunityMember(community.uuid!);
    final page = dataResponse.data!;

    expect(dataResponse.errorMessage, null);
    expect(page.content.length, (jsonPage['content'] as List).length);
    expect(page.totalElements, jsonPage['totalElements']);
    expect(page.totalPages, jsonPage['totalPages']);
    expect(page.isFirstPage, jsonPage['firstPage']);
    expect(page.isLastPage, jsonPage['lastPage']);
    expect(page.pageNumber, jsonPage['pageNumber']);
    expect(page.pageSize, jsonPage['pageSize']);
  });

  test('when getting a community member unsuccessfully, then error is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/member', queryParameters: {'pageSize': '10', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.badRequest, json: null));
    final dataResponse = await communityService.getCommunityMember(community.uuid!);

    expect(null, dataResponse.data);
    expect(HttpStatus.badRequest.name, dataResponse.errorMessage);
  });

  test('when getting requesting member successfully, then page of user is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/requesting-member', queryParameters: {'pageSize': '15', 'pageNumber':'0'})).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.ok, json: memberJsonPage));
    final dataResponse = await communityService.getRequestingMember(community.uuid!);
    final page = dataResponse.data!;

    expect(dataResponse.errorMessage, null);
    expect(page.content.length, (jsonPage['content'] as List).length);
    expect(page.totalElements, jsonPage['totalElements']);
    expect(page.totalPages, jsonPage['totalPages']);
    expect(page.isFirstPage, jsonPage['firstPage']);
    expect(page.isLastPage, jsonPage['lastPage']);
    expect(page.pageNumber, jsonPage['pageNumber']);
    expect(page.pageSize, jsonPage['pageSize']);
  });

  test('when getting a requesting member unsuccessfully, then error is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/requesting-member', queryParameters: {'pageSize': '15', 'pageNumber':'0'})).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.badRequest, json: null));
    final dataResponse = await communityService.getRequestingMember(community.uuid!);

    expect(null, dataResponse.data);
    expect(HttpStatus.badRequest.name, dataResponse.errorMessage);
  });

  test('when joining a community successfully, then status 204 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/join')).thenAnswer((_) async =>
        const HttpJsonResponse(status: HttpStatus.noContent, json: null));
    final dataResponse = await communityService.joinCommunity(community.uuid.toString());

    expect(null, dataResponse.data);
    expect(null, dataResponse.errorMessage);
  });

  test('when joining a community unsuccessfully, then status 503 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/join')).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.joinCommunity(community.uuid.toString());

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });

  test('when leaving a community successfully, then status 204 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/leave')).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.noContent, json: null));
    final dataResponse = await communityService.leaveCommunity(community.uuid.toString());

    expect(null, dataResponse.data);
    expect(null, dataResponse.errorMessage);
  });

  test('when leaving a community unsuccessfully, then status 503 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/leave')).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.leaveCommunity(community.uuid.toString());

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });

  test('when approving community join requests successfully, then list of approved members is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/request/approve', method: HttpMethod.post, body: userUuids)).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.noContent, json: userList));
    final dataResponse = await communityService.approveJoinRequests(community.uuid.toString(), userUuids);

    expect(dataResponse.errorMessage, null);
    expect(dataResponse.data?.length, userUuids.length);
    expect(dataResponse.data?[0].uuid, userUuids[0]);
    expect(dataResponse.data?[1].uuid, userUuids[1]);
  });

  test('when joining a community unsuccessfully, then status 503 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/request/approve', method: HttpMethod.post, body: userUuids)).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.approveJoinRequests(community.uuid.toString(), userUuids);

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });

  test('when declining community join requests successfully, then list of approved members is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/request/decline', method: HttpMethod.post, body: userUuids)).thenAnswer((_) async =>
        HttpJsonResponse(status: HttpStatus.noContent, json: userList));
    final dataResponse = await communityService.declineJoinRequest(community.uuid.toString(), userUuids);

    expect(dataResponse.errorMessage, null);
    expect(dataResponse.data?.length, userUuids.length);
    expect(dataResponse.data?[0].uuid, userUuids[0]);
    expect(dataResponse.data?[1].uuid, userUuids[1]);
  });

  test('when declining a community unsuccessfully, then status 503 is returned', () async {
    when(mockRequestService.request('user/community/${community.uuid}/request/decline', method: HttpMethod.post, body: userUuids)).thenAnswer((_) async =>
    const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final dataResponse = await communityService.declineJoinRequest(community.uuid.toString(), userUuids);

    expect(null, dataResponse.data);
    expect(HttpStatus.serviceUnavailable.name, dataResponse.errorMessage);
  });
}