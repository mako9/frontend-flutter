import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../model/data_response.dart';
import '../../model/item.dart';
import '../../service/item_service.dart';

class ItemDetailCubit extends Cubit<DataResponse<Item>> {
  final ItemService _itemService = getIt.get<ItemService>();

  ItemDetailCubit(super.initialState) {
    final uuid = state.data?.uuid;
    if (uuid != null) {
      getItem(uuid);
    }
  }

  factory ItemDetailCubit.ofInitialState({Item? item}) {
    return ItemDetailCubit(DataResponse(
        data: item, errorMessage: null));
  }

  Future<void> getItem(String uuid) async {
    final itemDataResponse = await _itemService.getItem(uuid);
    emit(itemDataResponse);
  }
}
