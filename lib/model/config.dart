import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Config {
  String baseUrl = '';
  String backendHost = '';
  String backendScheme = '';
  int? backendPort;
  String backendBasePath = '';
  String clientId = '';
  String clientSecret = '';
  String redirectUrl = '';
  String issuer = '';
  String discoveryUrl = '';
  String postLogoutRedirectUrl = '';
  List<String> scopes = List.empty();
  String authorizationEndpoint = '';
  String tokenEndpoint = '';
  String endSessionEndpoint = '';

  loadConfig(BuildContext context) async {
    final yamlString = await DefaultAssetBundle.of(context)
        .loadString('assets/config/config.yaml');
    final dynamic yamlMap = loadYaml(yamlString);

    YamlList test = yamlMap['scopes'];


    baseUrl = yamlMap['baseUrl'] as String;
    backendHost = yamlMap['backendHost'] as String;
    backendScheme = yamlMap['backendScheme'] as String;
    backendPort = yamlMap['backendPort'] as int?;
    backendBasePath = yamlMap['backendBasePath'] as String;
    clientId = yamlMap['clientId'] as String;
    clientSecret = yamlMap['clientSecret'] as String;
    redirectUrl = yamlMap['redirectUrl'] as String;
    issuer = yamlMap['issuer'] as String;
    discoveryUrl = yamlMap['discoveryUrl'] as String;
    postLogoutRedirectUrl = yamlMap['postLogoutRedirectUrl'] as String;
    scopes = test.map((value) => value.toString()).toList();
    authorizationEndpoint = yamlMap['authorizationEndpoint'] as String;
    tokenEndpoint = yamlMap['tokenEndpoint'] as String;
    endSessionEndpoint = yamlMap['endSessionEndpoint'] as String;
  }
}