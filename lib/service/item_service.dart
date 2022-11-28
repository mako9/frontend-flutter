import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/request_service.dart';

import '../util/http_helper.dart';

class ItemService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _itemPath = 'user/item';

  Future<DataResponse<DataPage<Item>>> getAllItemsOfCommunity(
      String uuid,
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_itemPath/$uuid',
        queryParameters: _paginationParams(pageNumber));
    return _dataPageFromResponse(response);
  }

  Future<DataResponse<DataPage<Item>>> getMyItems(
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_itemPath/my',
        queryParameters: _paginationParams(pageNumber));
    return _dataPageFromResponse(response);
  }

  Future<DataResponse<DataPage<Item>>> getItemsOfMyCommunities(
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_itemPath/my-communities',
        queryParameters: _paginationParams(pageNumber, pageSize: 100));
    return _dataPageFromResponse(response);
  }

  Future<DataResponse<Item>> getItem(String uuid) async {
    final response = await _requestService.request('$_itemPath/$uuid');
    return _itemFromResponse(response);
  }

  Future<DataResponse<Item>> createItem(Item item) async {
    final response = await _requestService.request(_itemPath,
        method: HttpMethod.post, body: item);
    return _itemFromResponse(response);
  }

  Future<DataResponse<Item>> updateItem(Item item) async {
    final response = await _requestService.request(
        '$_itemPath/${item.uuid}',
        method: HttpMethod.patch,
        body: item);
    return _itemFromResponse(response);
  }

  Future<DataResponse<Item>> deleteItem(String uuid) async {
    final response = await _requestService.request('$_itemPath/$uuid', method: HttpMethod.delete);
    return _itemFromResponse(response);
  }

  Map<String, String> _paginationParams(int pageNumber, {int pageSize = 10}) {
    return {'pageSize': pageSize.toString(), 'pageNumber': pageNumber.toString()};
  }

  DataResponse<DataPage<Item>> _dataPageFromResponse(
      HttpJsonResponse response) {
    final json = response.getJson();
    DataPage<Item>? page;
    if (json != null) {
      page = DataPage.fromJson(json, Item.fromJson);
    }
    return DataResponse.fromHttpResponse(page, response);
  }

  DataResponse<Item> _itemFromResponse(HttpJsonResponse response) {
    final json = response.getJson();
    Item? responseCommunity;
    if (json != null) {
      responseCommunity = Item.fromJson(json);
    }
    return DataResponse.fromHttpResponse(responseCommunity, response);
  }
}
