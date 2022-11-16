import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/user.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/widget/community/community_detail_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const uuid = 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8';
  late CommunityService mockCommunityService;
  late CommunityDetailCubit communityDetailCubit;
  final communityResponse = DataResponse<Community>(data: Community(
    uuid: uuid,
    name: 'name',
    radius: 10,
    isAdmin: true,
  ), errorMessage: null);
  final memberResponse = DataResponse<DataPage<User>>(data: DataPage(
    content: [
      User(uuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8', firstName: 'test', lastName: 'test')
    ],
    isFirstPage: true,
    isLastPage: true,
    pageNumber: 0,
    pageSize: 1,
    totalElements: 1,
    totalPages: 1,),
    errorMessage: null);

  setUpAll(() async {
    getServices();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    communityDetailCubit = CommunityDetailCubit(DataResponse.empty());
  });

  test('when loading detailed community as admin with success, then state is set to data response', () async {
    when(mockCommunityService.getCommunity(uuid)).thenAnswer((_) async => communityResponse);
    when(mockCommunityService.getCommunityMember(uuid)).thenAnswer((_) async => memberResponse);
    when(mockCommunityService.getRequestingMember(uuid)).thenAnswer((_) async => memberResponse);
    await communityDetailCubit.getCommunityWithMember(uuid);

    expect(communityDetailCubit.state.data?.community?.uuid, uuid);
    expect(communityDetailCubit.state.data?.community?.name, communityResponse.data?.name);
    expect(communityDetailCubit.state.data?.communityMember?.content.length, 1);
    expect(communityDetailCubit.state.data?.communityMember?.pageNumber, 0);
    expect(communityDetailCubit.state.data?.communityMember?.totalElements, 1);
    expect(communityDetailCubit.state.data?.requestingMember?.content.length, 1);
    expect(communityDetailCubit.state.data?.requestingMember?.pageNumber, 0);
    expect(communityDetailCubit.state.data?.requestingMember?.totalElements, 1);
  });

  test('when loading detailed community as non-admin with success, then state is set to data response', () async {
    when(mockCommunityService.getCommunity(uuid)).thenAnswer((_) async => DataResponse<Community>(data: Community(
      uuid: uuid,
      name: 'name',
      radius: 10,
      isAdmin: false,
    ), errorMessage: null));
    when(mockCommunityService.getCommunityMember(uuid)).thenAnswer((_) async => memberResponse);
    when(mockCommunityService.getRequestingMember(uuid)).thenAnswer((_) async => memberResponse);
    await communityDetailCubit.getCommunityWithMember(uuid);

    expect(communityDetailCubit.state.data?.community?.uuid, uuid);
    expect(communityDetailCubit.state.data?.community?.name, communityResponse.data?.name);
    expect(communityDetailCubit.state.data?.communityMember, null);
    expect(communityDetailCubit.state.data?.requestingMember, null);
  });
}