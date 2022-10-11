import 'package:frontend_flutter/model/config.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/service/storage_service.dart';
import 'package:frontend_flutter/service/user_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void getServices() {
  getIt.registerLazySingleton(() => Config());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => RequestService());
  getIt.registerLazySingleton(() => CommunityService());
}