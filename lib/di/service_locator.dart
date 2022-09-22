import 'package:frontend_flutter/models/config.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/services/request_service.dart';
import 'package:frontend_flutter/services/storage_service.dart';
import 'package:frontend_flutter/services/user_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void getServices() {
  getIt.registerLazySingleton(() => Config());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => RequestService());
}