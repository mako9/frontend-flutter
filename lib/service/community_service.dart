import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../model/community.dart';
import '../model/user.dart';
import '../utils/http_helper.dart';

class CommunityService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _communityPath = 'user/community';

  Future<DataResponse<DataPage<Community>>> getAllCommunities(
      {int pageNumber = 0}) async {
    final response = await _requestService.request(_communityPath,
        queryParameters: _paginationParams(pageNumber));
    return _dataPageFromResponse(response);
  }

  Future<DataResponse<DataPage<Community>>> getMyCommunities(
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_communityPath/my',
        queryParameters: _paginationParams(pageNumber));
    return _dataPageFromResponse(response);
  }

  Future<DataResponse<Community>> getCommunity(String uuid) async {
    final response = await _requestService.request('$_communityPath/$uuid');
    return _communityFromResponse(response);
  }

  Future<DataResponse<Community>> createCommunity(Community community) async {
    final response = await _requestService.request(_communityPath,
        method: HttpMethod.post, body: community);
    return _communityFromResponse(response);
  }

  Future<DataResponse<Community>> updateCommunity(Community community) async {
    final response = await _requestService.request(
        '$_communityPath/${community.uuid}',
        method: HttpMethod.patch,
        body: community);
    return _communityFromResponse(response);
  }

  Future<DataResponse<DataPage<User>>> getCommunityMember(String uuid) async {
    final response =
        await _requestService.request('$_communityPath/$uuid/member');
    final json = response.getJson();
    DataPage<User>? responseCommunityMember;
    if (json != null) {
      responseCommunityMember = DataPage.fromJson(json, User.fromJson);
    }
    return DataResponse.fromHttpResponse(responseCommunityMember, response);
  }

  Map<String, String> _paginationParams(int pageNumber) {
    return {'pageSize': '10', 'pageNumber': pageNumber.toString()};
  }

  DataResponse<DataPage<Community>> _dataPageFromResponse(
      HttpJsonResponse response) {
    final json = response.getJson();
    DataPage<Community>? page;
    if (json != null) {
      page = DataPage.fromJson(json, Community.fromJson);
    }
    return DataResponse.fromHttpResponse(page, response);
  }

  DataResponse<Community> _communityFromResponse(HttpJsonResponse response) {
    final json = response.getJson();
    Community? responseCommunity;
    if (json != null) {
      responseCommunity = Community.fromJson(json);
    }
    return DataResponse.fromHttpResponse(responseCommunity, response);
  }
}
