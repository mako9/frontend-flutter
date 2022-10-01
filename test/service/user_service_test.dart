
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/service/user_service.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RequestService mockRequestService;
  late UserService userService;

  setUpAll(() async {
    getServices();
    mockRequestService = MockRequestService();
    await getIt.unregister<RequestService>();
    getIt.registerLazySingleton<RequestService>(() => mockRequestService);
    userService = UserService();
  });

  test('when getting valid response, then user is returned', () async {
    final json = {
      'uuid': 'uuid',
      'firstName': 'first',
      'lastName': 'last',
      'mail': 'test@test@test.tld',
      'street': 'street',
      'houseNumber': '9',
      'postalCode': '36039',
      'city': 'city',
      'roles': ['USER'],
    };

    when(mockRequestService.request('users/me')).thenAnswer((_) async =>
    HttpJsonResponse(status: HttpStatus.ok, json: json));
    final user = await userService.getUser();

    expect(user?.uuid, json['uuid']);
    expect(user?.firstName, json['firstName']);
    expect(user?.lastName, json['lastName']);
    expect(user?.mail, json['mail']);
    expect(user?.street, json['street']);
    expect(user?.houseNumber, json['houseNumber']);
    expect(user?.postalCode, json['postalCode']);
    expect(user?.city, json['city']);
  });

  test('when getting invalid response, then user is returned', () async {
    when(mockRequestService.request('users/me')).thenAnswer((_) async =>
        const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null));
    final user = await userService.getUser();

    expect(user, null);
  });
}