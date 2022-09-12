import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Config {
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

  static final Config _singleton = Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  loadConfig(BuildContext context) async {
    final yamlString = await DefaultAssetBundle.of(context)
        .loadString('assets/config/config.yaml');
    final dynamic yamlMap = loadYaml(yamlString);

    YamlList test = yamlMap["scopes"];


    clientId = yamlMap["clientId"] as String;
    clientSecret = yamlMap["clientSecret"] as String;
    redirectUrl = yamlMap["redirectUrl"] as String;
    issuer = yamlMap["issuer"] as String;
    discoveryUrl = yamlMap["discoveryUrl"] as String;
    postLogoutRedirectUrl = yamlMap["postLogoutRedirectUrl"] as String;
    scopes = test.map((value) => value.toString()).toList();
    authorizationEndpoint = yamlMap["authorizationEndpoint"] as String;
    tokenEndpoint = yamlMap["tokenEndpoint"] as String;
    endSessionEndpoint = yamlMap["endSessionEndpoint"] as String;
  }
}