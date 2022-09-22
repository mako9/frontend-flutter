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
}