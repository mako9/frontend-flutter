import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/item_service.dart';

import '../../di/service_locator.dart';
import '../../model/data_response.dart';

class ItemEditCubit extends Cubit<DataResponse<Item>> {
  final ItemService _itemService = getIt.get<ItemService>();
  FilePickerResult? _filePickerResult;

  ItemEditCubit(super.initialState) {
    final uuid = state.data?.uuid;
    if (uuid != null) {
      getItem(uuid);
      _getItemImage(uuid);
    }
  }

  factory ItemEditCubit.ofInitialState({Item? item, Uint8List? imageData}) {
    return ItemEditCubit(DataResponse(data: item, errorMessage: null));
  }

  Future<void> createItem(Item item) async {
    final itemDataResponse = await _itemService.createItem(item);
    final imageData = await _uploadImages(itemDataResponse.data?.uuid);
    itemDataResponse.data?.imageData = imageData;
    emit(itemDataResponse);
  }

  Future<void> updateItem(Item item) async {
    final itemDataResponse = await _itemService.updateItem(item);
    final imageData = await _uploadImages(itemDataResponse.data?.uuid);
    itemDataResponse.data?.imageData = imageData;
    emit(itemDataResponse);
  }

  Future<void> getItem(String uuid) async {
    final itemDataResponse = await _itemService.getItem(uuid);
    emit(itemDataResponse);
  }

  Future<void> deleteItem(Item item) async {
    await _itemService.deleteItem(item.uuid!);
  }

  Future<Uint8List?> pickFiles() async {
    _filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    return _filePickerResult?.files.first.bytes;
  }

  Future<void> _getItemImage(String uuid) async {
    final itemImageDataResponse = await _itemService.getItemImage(uuid);
    state.data?.imageData = itemImageDataResponse.data;
    final newState = DataResponse(
      data: state.data,
      errorMessage: state.errorMessage ?? itemImageDataResponse.errorMessage
    );
    emit(newState);
  }

  Future<Uint8List?> _uploadImages(String? uuid) async {
    if (uuid == null) return null;
    final files = _filePickerResult?.files;
    if (files == null || files.isEmpty) return null;
    final bytes = files.first.bytes;
    final imageExtension = files.first.extension;
    if (bytes == null || imageExtension == null) return null;
    final response = await _itemService.uploadItemImage(uuid, bytes, imageExtension);
    return response.data;
  }
}