import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/community.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../model/user.dart';
import '../../service/community_service.dart';

class CommunityDetailCubit extends Cubit<DataResponse<CommunityDetailState>> {
  final CommunityService _communityService = getIt.get<CommunityService>();

  CommunityDetailCubit(super.initialState) {
    final uuid = state.data?.community?.uuid;
    if (uuid != null) {
      getCommunityWithMember(uuid);
    }
  }

  factory CommunityDetailCubit.ofInitialState({Community? community}) {
    return CommunityDetailCubit(DataResponse(
        data: CommunityDetailState(community: community), errorMessage: null));
  }

  Future<void> getCommunityWithMember(String uuid) async {
    final communityDataResponse = await _communityService.getCommunity(uuid);
    final communityMemberDataResponse =
        await _communityService.getCommunityMember(uuid);
    final newState = DataResponse(
        data: CommunityDetailState(
            community: communityDataResponse.data,
            communityMember: communityMemberDataResponse.data),
        errorMessage: communityDataResponse.errorMessage ??
            communityMemberDataResponse.errorMessage);
    emit(newState);
  }
}

class CommunityDetailState {
  Community? community;
  DataPage<User>? communityMember;

  CommunityDetailState({this.community, this.communityMember});
}
