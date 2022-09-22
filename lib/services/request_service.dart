import 'dart:convert' as convert;
import 'dart:io';

import 'package:frontend_flutter/models/config.dart';
import 'package:frontend_flutter/models/http_json_response.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/services/storage_service.dart';
import 'package:http/http.dart' as http;

import '../di/service_locator.dart';

enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete
}

class RequestService {
  final _config = getIt.get<Config>();
  final _storageService = getIt.get<StorageService>();
  final _authService = getIt.get<AuthService>();

  Future<HttpJsonResponse> request(String path, {HttpMethod method = HttpMethod.get, Object? body, bool needsAuth = true}) async {
    String? accessToken;
    if (needsAuth) {
      accessToken = await _storageService.readToken(TokenType.accessToken);
      if (accessToken == null) {
        return const HttpJsonResponse(status: HttpStatus.unauthorized, json: null);
      }
    }
    HttpJsonResponse response = await _request(path, method: method, body: body, accessToken: accessToken);
    if (response.status == HttpStatus.unauthorized) {
      accessToken = await _authService.refresh();
      response = await _request(path, method: method, body: body, accessToken: accessToken);
    }
    return response;
  }

  Future<HttpJsonResponse> _request(String path, {HttpMethod method = HttpMethod.get, Object? body, String? accessToken}) async {
    final url = Uri.parse('${_config.backendBaseUrl}/$path');

    final headers = _httpHeaders(accessToken);
    http.Response response;
    try {
      switch (method) {
        case HttpMethod.post:
          response = await http
              .post(url, headers: headers, body: body);
          break;
        case HttpMethod.patch:
          response = await http
              .patch(url, headers: headers, body: body);
          break;
        case HttpMethod.put:
          response = await http
              .put(url, headers: headers, body: body);
          break;
        case HttpMethod.delete:
          response = await http
              .post(url, headers: headers);
          break;
        default:
          response = await http
              .get(url, headers: headers);
          break;
      }
    } catch (error) {
      print('Error during request: ${error.toString()}');
      return const HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null);
    }

    final status = HttpStatus.fromValue(response.statusCode);

    HttpJsonResponse httpJsonResponse = HttpJsonResponse(status: status, json: null);

    if (status.isSuccessful()) {
      final jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      httpJsonResponse = HttpJsonResponse(status: status, json: jsonResponse);
    }
    print('$path: ${httpJsonResponse.toString()}');

    return httpJsonResponse;
  }

  Map<String, String> _httpHeaders(String? accessToken) {
      var headers = {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.acceptHeader: ContentType.json.value,
      };
      if (accessToken != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      }
      return headers;
  }
}