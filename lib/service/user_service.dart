import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../model/user.dart';
import '../util/http_helper.dart';

class UserService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _userPath = 'user/me';

  Future<DataResponse<User>> getUser() async {
    final response = await _requestService.request(_userPath);
    return _evaluateResponse(response);
  }

  Future<DataResponse<User>> updateUser(User user) async {
    final response = await _requestService.request(_userPath, method: HttpMethod.patch, body: user);
    return _evaluateResponse(response);
  }

  Future<DataResponse<User>> _evaluateResponse(HttpDataResponse response) async {
    final json = response.getData();
    User? user;
    if (json != null) { user = User.fromJson(json); }
    return DataResponse.fromHttpResponse(user, response);
  }
}
