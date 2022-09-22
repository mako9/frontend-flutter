import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/services/request_service.dart';

import '../models/user.dart';

class UserService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _userPath = 'users/me';

  Future<User?> getUser() async {
    final response = await _requestService.request(_userPath);
    final json = response.json;
    if (response.status.isSuccessful() && json != null) {
      return User.fromJson(json);
    } else {
      return null;
    }
  }
}
