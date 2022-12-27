import 'package:frontend_flutter/model/config.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/service/storage_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';

import '../di/service_locator.dart';

class RequestService {
  final _config = getIt.get<Config>();
  final _storageService = getIt.get<StorageService>();
  final _authService = getIt.get<AuthService>();
  late HttpHelper _httpHelper;

  RequestService({HttpHelper? httpHelper}) {
    _httpHelper = httpHelper ?? HttpHelper();
  }

  Future<HttpJsonResponse> request(String path, {HttpMethod method = HttpMethod.get, Object? body, Map<String, String>? queryParameters, bool needsAuth = true}) async {
    String? accessToken;
    if (needsAuth) {
      accessToken = await _storageService.readToken(TokenType.accessToken);
      if (accessToken == null) {
        return const HttpJsonResponse(status: HttpStatus.unauthorized, json: null, errorMessage: null);
      }
    }
    final uri = _getUri(path, queryParameters: queryParameters);
    HttpJsonResponse response = await _httpHelper.request(uri, method: method, body: body, accessToken: accessToken);
    if (response.status == HttpStatus.unauthorized) {
      accessToken = await _authService.refresh();
      if (accessToken == null) {
        return const HttpJsonResponse(status: HttpStatus.unauthorized, json: null, errorMessage: null);
      }
      response = await _httpHelper.request(uri, method: method, body: body, accessToken: accessToken);
    }
    return response;
  }

  Uri _getUri(String path, {Map<String, String>? queryParameters}) {
    return Uri(scheme: _config.backendScheme, host: _config.backendHost, port: _config.backendPort, path: '${_config.backendBasePath}/$path', queryParameters: queryParameters);
  }
}