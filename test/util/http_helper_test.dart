import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/config.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/util/http_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const path = 'user/me';
  const body = '{"test": "test"}';
  const bodyObject = {'test': 'test'};

  late http.Client mockClient;
  late HttpHelper httpHelper;
  late Uri url;

  setUpAll(() async {
    getServices();
    mockClient = MockClient();
    httpHelper = HttpHelper(client: mockClient);
    final config = getIt.get<Config>();
    url = Uri(scheme: config.backendScheme, host: config.backendHost, port: config.backendPort, path: '${config.backendBasePath}/$path');
  });

  test('when calling POST URL encoded request with success, then status 200 is returned', () async {
    when(mockClient.post(url, headers: {
      HttpHeaders.acceptHeader: HttpContentType.json.value,
      HttpHeaders.contentTypeHeader: HttpContentType.urlEncoded.value,
    }, encoding: Encoding.getByName('utf-8'), body: bodyObject)).thenAnswer((_) async => http.Response(body, 200));

    HttpDataResponse response = await httpHelper.request(url, method: HttpMethod.post, contentType: HttpContentType.urlEncoded, body: bodyObject);

    expect(response.status, HttpStatus.ok);
    expect(response.data, bodyObject);
  });

  test('when calling POST URL encoded request without success, then status 500 is returned', () async {
    when(mockClient.post(url, headers: {
      HttpHeaders.acceptHeader: ContentType.json.value,
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    }, encoding: Encoding.getByName('utf-8'), body: bodyObject)).thenThrow(Error());

    HttpDataResponse response = await httpHelper.request(url, method: HttpMethod.post, contentType: HttpContentType.urlEncoded, body: bodyObject);

    expect(response.status, HttpStatus.internalServerError);
    expect(response.data, null);
  });

  test('when calling GET request with failing request, then status 503 is returned', () async {
    when(mockClient.get(url, headers: httpHelper.httpHeaders(accessToken: 'some_token'))).thenThrow(Error());

    HttpDataResponse response = await httpHelper.request(url, accessToken: 'some_token');

    expect(response.status, HttpStatus.internalServerError);
    expect(response.data, null);
  });

  test('when calling POST request, then status 200 is returned', () async {
    when(mockClient.post(url, body: json.encode(bodyObject), headers: httpHelper.httpHeaders(accessToken: 'some_token'), encoding: Encoding.getByName('utf-8'))).thenAnswer((_) async => http.Response(body, 200));

    final response = await httpHelper.request(url, method: HttpMethod.post, body: bodyObject, accessToken: 'some_token');

    expect(response.status, HttpStatus.ok);
    expect(response.data, bodyObject);
  });

  test('when calling PATCH request, then status 200 is returned', () async {
    when(mockClient.patch(url, body: json.encode(bodyObject), headers: httpHelper.httpHeaders(accessToken: 'some_token'))).thenAnswer((_) async => http.Response(body, 200));

    final response = await httpHelper.request(url, method: HttpMethod.patch, body: bodyObject, accessToken: 'some_token');

    expect(response.status, HttpStatus.ok);
    expect(response.data, bodyObject);
  });

  test('when calling PUT request, then status 200 is returned', () async {
    when(mockClient.put(url, body: json.encode(bodyObject), headers: httpHelper.httpHeaders(accessToken: 'some_token'))).thenAnswer((_) async => http.Response(body, 200));

    final response = await httpHelper.request(url, method: HttpMethod.put, body: bodyObject, accessToken: 'some_token');

    expect(response.status, HttpStatus.ok);
    expect(response.data, bodyObject);
  });

  test('when calling DELETE request, then status 200 is returned', () async {
    when(mockClient.delete(url, headers: httpHelper.httpHeaders(accessToken: 'some_token'))).thenAnswer((_) async => http.Response('{}', 204));

    final response = await httpHelper.request(url, method: HttpMethod.delete, accessToken: 'some_token');

    expect(response.status, HttpStatus.noContent);
    expect(response.data, {});
  });
}