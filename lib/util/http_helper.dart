import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete
}

enum HttpContentType {
  json('application/json'),
  urlEncoded('application/x-www-form-urlencoded'),
  octetStream('application/octet-stream'),
  multipartFormData('multipart/form-data');

  const HttpContentType(this.value);

  final String value;
}

class HttpHelper {
  late http.Client client;

  HttpHelper({http.Client? client}) {
    this.client = client ?? http.Client();
  }

  Future<HttpDataResponse> request(Uri uri, {
    HttpMethod method = HttpMethod.get,
    HttpContentType contentType = HttpContentType.json,
    HttpContentType acceptType = HttpContentType.json,
    dynamic body,
    String? accessToken,
  }) async {
    final headers = httpHeaders(contentType: contentType, acceptType: acceptType, accessToken: accessToken);
    var data = body;
    if (contentType == HttpContentType.json) {
      data = json.encode(body);
    }

    http.Response response;
    try {
      switch (method) {
        case HttpMethod.post:
          response = await client
              .post(uri, headers: headers, body: data, encoding: Encoding.getByName('utf-8'));
          break;
        case HttpMethod.patch:
          response = await client
              .patch(uri, headers: headers, body: data);
          break;
        case HttpMethod.put:
          response = await client
              .put(uri, headers: headers, body: data);
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
      return HttpDataResponse(status: HttpStatus.internalServerError, data: null, errorMessage: error.toString());
    }

    HttpDataResponse httpDataResponse = _parseResponse(response, acceptType: acceptType);
    debugPrint('$uri: ${httpDataResponse.toString()}');

    return httpDataResponse;
  }

  Future<HttpDataResponse> multipartRequest(Uri uri, Uint8List bytes, String imageExtension, String accessToken) async {
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(httpHeaders(contentType: HttpContentType.multipartFormData, accessToken: accessToken));
     request.files.add(http.MultipartFile.fromBytes('file', bytes, contentType: MediaType('image', imageExtension)));
     try {
       final response = await request.send();
       return HttpDataResponse(
         status: HttpStatus.fromValue(response.statusCode),
         data: null,
         errorMessage: response.reasonPhrase,
       );
     } catch (error) {
       debugPrint('Error during request: ${error.toString()}');
       return HttpDataResponse(status: HttpStatus.internalServerError, data: null, errorMessage: error.toString());
     }
  }

  Map<String, String> httpHeaders({
    HttpContentType contentType = HttpContentType.json,
    HttpContentType acceptType = HttpContentType.json,
    String? accessToken,
  }) {
    var headers = {
      HttpHeaders.contentTypeHeader: contentType.value,
      HttpHeaders.acceptHeader: acceptType.value,
    };
    if (accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }
    return headers;
  }

  HttpDataResponse _parseResponse(http.Response response, { HttpContentType acceptType = HttpContentType.json }) {
    final status = HttpStatus.fromValue(response.statusCode);

    HttpDataResponse httpDataResponse = HttpDataResponse(status: status, data: null, errorMessage: response.reasonPhrase);

    if (status.isSuccessful()) {
      try {
        dynamic data;
        switch (acceptType) {
          case HttpContentType.json:
            data = convert.jsonDecode(response.body);
            break;
          case HttpContentType.octetStream:
            data = response.bodyBytes;
            break;
          default:
            data = response.body;
        }
        httpDataResponse = HttpDataResponse(status: status, data: data, errorMessage: null);
      } catch (exception) {
        debugPrint('Data not parsed: ${exception.toString()}');
      }
    }

    return httpDataResponse;
  }
}