import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../model/community.dart';
import '../model/user.dart';
import '../util/http_helper.dart';

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

  Future<DataResponse<DataPage<Community>>> getCommunitiesOwnedByMe(
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_communityPath/owned',
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

  Future<DataResponse<Community>> deleteCommunity(String uuid) async {
    final response = await _requestService.request('$_communityPath/$uuid', method: HttpMethod.delete);
    return _communityFromResponse(response);
  }

  Future<DataResponse<DataPage<User>>> getCommunityMember(String uuid, {int pageNumber = 0}) async {
    final response =
        await _requestService.request('$_communityPath/$uuid/member',
            queryParameters: _paginationParams(pageNumber));
    final json = response.getJson();
    DataPage<User>? responseCommunityMember;
    if (json != null) {
      responseCommunityMember = DataPage.fromJson(json, User.fromJson);
    }
    return DataResponse.fromHttpResponse(responseCommunityMember, response);
  }

  Future<DataResponse<DataPage<User>>> getRequestingMember(String uuid, {int pageNumber = 0}) async {
    final response =
    await _requestService.request('$_communityPath/$uuid/requesting-member',
        queryParameters: _paginationParams(pageNumber, pageSize: 15));
    final json = response.getJson();
    DataPage<User>? responseCommunityMember;
    if (json != null) {
      responseCommunityMember = DataPage.fromJson(json, User.fromJson);
    }
    return DataResponse.fromHttpResponse(responseCommunityMember, response);
  }

  Future<DataResponse<Community>> joinCommunity(String uuid) async {
    final response = await _requestService.request('$_communityPath/$uuid/join');
    return _communityFromResponse(response);
  }

  Future<DataResponse<Community>> leaveCommunity(String uuid) async {
    final response = await _requestService.request('$_communityPath/$uuid/leave');
    return _communityFromResponse(response);
  }

  Future<DataResponse<List<User>>> approveJoinRequests(String communityUuid, List<String> userUuids) async {
    final response = await _requestService.request('$_communityPath/$communityUuid/request/approve', method: HttpMethod.post, body: userUuids);
    return _userListFromResponse(response);
  }

  Future<DataResponse<List<User>>> declineJoinRequest(String communityUuid, List<String> userUuids) async {
    final response = await _requestService.request('$_communityPath/$communityUuid/request/decline', method: HttpMethod.post, body: userUuids);
    return _userListFromResponse(response);
  }

  Map<String, String> _paginationParams(int pageNumber, {int pageSize = 10}) {
    return {'pageSize': pageSize.toString(), 'pageNumber': pageNumber.toString()};
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

  DataResponse<List<User>> _userListFromResponse(
      HttpJsonResponse response) {
    final json = response.getJson();
    List<User>? list;
    if (json != null) {
      list = List<User>.from(json.map((e) => User.fromJson(e)));
    }
    return DataResponse.fromHttpResponse(list, response);
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
