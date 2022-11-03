class Credential {
  final String accessToken;
  final String refreshToken;
  final String idToken;

  const Credential({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  });

  @override
  String toString() {
    return 'Credentials: accessToken: $accessToken, refreshToken: $refreshToken, idToken: $idToken';
  }

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      idToken: json['id_token'],
    );
  }
}