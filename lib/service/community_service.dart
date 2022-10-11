import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../model/community.dart';
import '../model/data_page.dart';

class CommunityService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _communityPath = 'user/community';

  Future<DataPage<Community>?> getMyCommunities(int pageNumber) async {
    final response = await _requestService.request('$_communityPath/own', queryParameters: { 'pageNumber': pageNumber.toString() });
    final json = await _evaluateResponse(response);
    if (json == null) { return null; }
    return DataPage<Community>.fromJson(json, Community.fromJson);
  }

  Future<Map<String, dynamic>?> _evaluateResponse(HttpJsonResponse response) async {
    final json = response.json;
    if (response.status.isSuccessful()) {
      return json;
    } else {
      return null;
    }
  }
}
