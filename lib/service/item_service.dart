import 'dart:typed_data';

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

  Future<DataResponse<DataPage<Item>>> getItemsOwnedByMe(
      {int pageNumber = 0}) async {
    final response = await _requestService.request('$_itemPath/owned',
        queryParameters: _paginationParams(pageNumber));
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

  Future<DataResponse<Uint8List?>> getItemImage(String uuid) async {
    final imageUuidResponse = await _requestService.request('$_itemPath/$uuid/image');
    final imageUuids = (imageUuidResponse.getData() as List<dynamic>).cast<String>();
    if (imageUuids.isEmpty) return DataResponse(data: null, errorMessage: imageUuidResponse.errorMessage);
    final imageDataResponse = await _requestService.request('$_itemPath/image/${imageUuids.first}', acceptType: HttpContentType.octetStream);
    return DataResponse.fromHttpResponse(imageDataResponse.getData(), imageDataResponse);
  }

  Future<DataResponse<Uint8List>> uploadItemImage(String uuid, Uint8List bytes, String imageExtension) async {
    final response = await _requestService.multipartRequest('$_itemPath/$uuid/image', bytes, imageExtension);
    return DataResponse.fromHttpResponse(bytes, response);
  }

  Map<String, String> _paginationParams(int pageNumber, {int pageSize = 10}) {
    return {'pageSize': pageSize.toString(), 'pageNumber': pageNumber.toString()};
  }

  DataResponse<DataPage<Item>> _dataPageFromResponse(
      HttpDataResponse response) {
    final json = response.getData();
    DataPage<Item>? page;
    if (json != null) {
      page = DataPage.fromJson(json, Item.fromJson);
    }
    return DataResponse.fromHttpResponse(page, response);
  }

  DataResponse<Item> _itemFromResponse(HttpDataResponse response) {
    final json = response.getData();
    Item? responseCommunity;
    if (json != null) {
      responseCommunity = Item.fromJson(json);
    }
    return DataResponse.fromHttpResponse(responseCommunity, response);
  }

  static Map<ItemCategory, List<Item>>? getGroupedItems(DataPage<Item>? page) {
    if (page == null || page.content.isEmpty) return null;
    Map<ItemCategory, List<Item>> map = {};
    for (var element in ItemCategory.values) {
      map[element] = List.empty();
    }
    for (var element in page.content) {
      final categories = element.itemCategories;
      if (categories == null) continue;
      for (var category in categories)  {
        map[category] = [...?map[category], element];
      }
    }
    map.removeWhere((key, value) => value.isEmpty);
    return map;
  }
}
