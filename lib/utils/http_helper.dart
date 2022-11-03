import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:http/http.dart' as http;

enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete
}

class HttpHelper {
  late http.Client client;

  HttpHelper({http.Client? client}) {
    this.client = client ?? http.Client();
  }

  Future<HttpJsonResponse> urlEncodedPostRequest(String url, {Map<String, String>? body}) async {
    final uri = Uri.parse(url);

    final headers = {
      HttpHeaders.acceptHeader: ContentType.json.value,
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    http.Response response;
    try {
      response = await client
          .post(uri, headers: headers, encoding: Encoding.getByName('utf-8'), body: body);
    } catch (error) {
      debugPrint('Error during request: ${error.toString()}');
      return HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null, errorMessage: error.toString());
    }

    HttpJsonResponse httpJsonResponse = _parseResponse(response);
    debugPrint('$url: ${httpJsonResponse.toString()}');

    return httpJsonResponse;
  }

  Future<HttpJsonResponse> request(Uri uri, {HttpMethod method = HttpMethod.get, Object? body, String? accessToken}) async {
    final headers = httpHeaders(accessToken);
    final jsonData = json.encode(body);

    http.Response response;
    try {
      switch (method) {
        case HttpMethod.post:
          response = await client
              .post(uri, headers: headers, body: jsonData);
          break;
        case HttpMethod.patch:
          response = await client
              .patch(uri, headers: headers, body: jsonData);
          break;
        case HttpMethod.put:
          response = await client
              .put(uri, headers: headers, body: jsonData);
          break;
        case HttpMethod.delete:
          response = await client
              .delete(uri, headers: headers);
          break;
        default:
          response = await client
              .get(uri, headers: headers);
          break;
      }
    } catch (error) {
      debugPrint('Error during request: ${error.toString()}');
      return HttpJsonResponse(status: HttpStatus.serviceUnavailable, json: null, errorMessage: error.toString());
    }

    HttpJsonResponse httpJsonResponse = _parseResponse(response);
    debugPrint('$uri: ${httpJsonResponse.toString()}');

    return httpJsonResponse;
  }

  Map<String, String> httpHeaders(String? accessToken) {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    };
    if (accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }
    return headers;
  }

  HttpJsonResponse _parseResponse(http.Response response) {
    final status = HttpStatus.fromValue(response.statusCode);

    HttpJsonResponse httpJsonResponse = HttpJsonResponse(status: status, json: null, errorMessage: response.reasonPhrase);

    if (status.isSuccessful()) {
      final jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      httpJsonResponse = HttpJsonResponse(status: status, json: jsonResponse, errorMessage: response.reasonPhrase);
    }

    return httpJsonResponse;
  }
}