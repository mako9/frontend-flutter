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
    final isAdmin = communityDataResponse.data?.isAdmin == true;
    final communityMemberDataResponse = isAdmin ? await _communityService.getCommunityMember(uuid) : null;
    final requestingMemberResponse = isAdmin ? await _communityService.getRequestingMember(uuid) : null;
    final newState = DataResponse(
        data: CommunityDetailState(
            community: communityDataResponse.data,
            communityMember: communityMemberDataResponse?.data,
            requestingMember: requestingMemberResponse?.data),
        errorMessage: communityDataResponse.errorMessage
            ?? communityMemberDataResponse?.errorMessage
            ?? requestingMemberResponse?.errorMessage);
    emit(newState);
  }

  Future<void> joinCommunity(String uuid) async {
    final response = await _communityService.joinCommunity(uuid);
    emit(DataResponse(data: state.data, errorMessage: response.errorMessage));
  }

  Future<void> leaveCommunity(String uuid) async {
    final response = await _communityService.leaveCommunity(uuid);
    emit(DataResponse(data: state.data, errorMessage: response.errorMessage));
  }

  Future<void> deleteCommunity(String uuid) async {
    final response = await _communityService.deleteCommunity(uuid);
    emit(DataResponse(data: state.data, errorMessage: response.errorMessage));
  }
}

class CommunityDetailState {
  Community? community;
  DataPage<User>? communityMember;
  DataPage<User>? requestingMember;

  CommunityDetailState({this.community, this.communityMember, this.requestingMember});
}
