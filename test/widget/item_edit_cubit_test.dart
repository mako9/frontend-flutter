import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/widget/item/item_edit_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ItemService mockItemService;
  late ItemEditCubit itemEditCubit;
  final item = Item(
    uuid: 'uuid',
    name: 'name',
  );
  final response = DataResponse<Item>(
      data: item,
      errorMessage: null
  );

  setUpAll(() async {
    getServices();
    mockItemService = MockItemService();
    await getIt.unregister<ItemService>();
    getIt.registerLazySingleton<ItemService>(() => mockItemService);
    itemEditCubit = ItemEditCubit(DataResponse.empty());
  });

  test('when creating item with success, then state is set to data response', () async {
    when(mockItemService.createItem(item)).thenAnswer((_) async => response);
    await itemEditCubit.createItem(item);

    expect(itemEditCubit.state, response);
  });

  test('when creating item with failure, then state is set to error message', () async {
    const errorResponse = DataResponse<Item>(
      data: null,
      errorMessage: 'some error',
    );
    when(mockItemService.createItem(item)).thenAnswer((_) async => errorResponse);
    await itemEditCubit.createItem(item);

    expect(itemEditCubit.state, errorResponse);
  });

  test('when getting item with success, then state is set to data response', () async {
    when(mockItemService.getItem('uuid')).thenAnswer((_) async => response);
    await itemEditCubit.getItem('uuid');

    expect(itemEditCubit.state, response);
  });

  test('when updating community with success, then state is set to data response', () async {
    when(mockItemService.updateItem(item)).thenAnswer((_) async => response);
    await itemEditCubit.updateItem(item);

    expect(itemEditCubit.state, response);
  });

  test('when deleting item with success, then state is set to data response', () async {
    when(mockItemService.deleteItem(item.uuid!)).thenAnswer((_) async => response);
    await itemEditCubit.deleteItem(item);

    expect(itemEditCubit.state, response);
  });
}