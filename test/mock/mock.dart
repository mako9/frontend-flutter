@GenerateNiceMocks([MockSpec<StorageService>()])
import 'package:frontend_flutter/service/storage_service.dart';
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'package:http/http.dart' as http;
@GenerateNiceMocks([MockSpec<AuthService>()])
import 'package:frontend_flutter/service/auth_service.dart';
@GenerateNiceMocks([MockSpec<RequestService>()])
import 'package:frontend_flutter/service/request_service.dart';
@GenerateNiceMocks([MockSpec<Auth>()])
import 'package:frontend_flutter/service/auth/auth_interface.dart';
import 'package:mockito/annotations.dart';