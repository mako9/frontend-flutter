import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../model/community.dart';
import '../model/data_page.dart';

class CommunityService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _communityPath = 'user/community';

  Future<DataResponse<DataPage<Community>>> getAllCommunities({int pageNumber = 0}) async {
    final response = await _requestService.request(_communityPath, queryParameters: _paginationParams(pageNumber));
    final json = response.getJson();
    DataPage<Community>? page;
    if (json != null) { page = DataPage.fromJson(json, Community.fromJson); }
    return DataResponse.fromHttpResponse(page, response);
  }

  Future<DataResponse<DataPage<Community>>> getMyCommunities({int pageNumber = 0}) async {
    final response = await _requestService.request('$_communityPath/my', queryParameters: _paginationParams(pageNumber));
    final json = response.getJson();
    DataPage<Community>? page;
    if (json != null) { page = DataPage.fromJson(json, Community.fromJson); }
    return DataResponse.fromHttpResponse(page, response);
  }

  Map<String, String> _paginationParams(int pageNumber) {
    return {
      'pageSize': '10',
      'pageNumber': pageNumber.toString()
    };
  }
}
