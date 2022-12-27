import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/widget/item/item_detail_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ItemService mockItemService;
  late ItemDetailCubit itemDetailCubit;
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
    itemDetailCubit = ItemDetailCubit(DataResponse.empty());
  });

  test('when getting item with success, then state is set to data response', () async {
    when(mockItemService.getItem(item.uuid!)).thenAnswer((_) async => response);
    await itemDetailCubit.getItem(item.uuid!);

    expect(itemDetailCubit.state, response);
  });

  test('when getting item with failure, then state is set to error message', () async {
    const errorResponse = DataResponse<Item>(
      data: null,
      errorMessage: 'some error',
    );
    when(mockItemService.getItem(item.uuid!)).thenAnswer((_) async => errorResponse);
    await itemDetailCubit.getItem(item.uuid!);

    expect(itemDetailCubit.state, errorResponse);
  });
}