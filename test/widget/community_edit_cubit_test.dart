import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/widget/community/community_edit_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommunityService mockCommunityService;
  late CommunityEditCubit communityEditCubit;
  const community = Community(
      name: 'name',
      radius: 10,
      latitude: 0.4,
      longitude: 2.3,
  );
  const response = DataResponse<Community>(
        data: community,
      errorMessage: null
  );

  setUpAll(() async {
    getServices();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    communityEditCubit = CommunityEditCubit(DataResponse.empty());
  });

  test('when getting community with success, then state is set to data response', () async {
    when(mockCommunityService.getCommunity('uuid')).thenAnswer((_) async => response);
    await communityEditCubit.getCommunity('uuid');

    expect(communityEditCubit.state, response);
  });

  test('when updating community with success, then state is set to data response', () async {
    when(mockCommunityService.updateCommunity(community)).thenAnswer((_) async => response);
    await communityEditCubit.updateCommunity(community);

    expect(communityEditCubit.state, response);
  });
}