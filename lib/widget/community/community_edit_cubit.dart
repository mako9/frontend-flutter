import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/community.dart';

import '../../di/service_locator.dart';
import '../../model/data_response.dart';
import '../../service/community_service.dart';

class CommunityEditCubit extends Cubit<DataResponse<Community>> {
  final CommunityService _communityService = getIt.get<CommunityService>();

  CommunityEditCubit(super.initialState) {
    final uuid = state.data?.uuid;
    if (uuid != null) getCommunity(uuid);
  }

  factory CommunityEditCubit.ofInitialState({Community? community}) {
    return CommunityEditCubit(DataResponse(data: community, errorMessage: null));
  }

  Future<void> createCommunity(Community community) async {
    final communityDataResponse = await _communityService.createCommunity(community);
    emit(communityDataResponse);
  }

  Future<void> updateCommunity(Community community) async {
    final communityDataResponse = await _communityService.updateCommunity(community);
    emit(communityDataResponse);
  }

  Future<void> getCommunity(String uuid) async {
    final communityDataResponse = await _communityService.getCommunity(uuid);
    emit(communityDataResponse);
  }
}