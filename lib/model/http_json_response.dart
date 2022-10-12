class HttpJsonResponse {
  final HttpStatus status;
  final Map<String, dynamic>? json;
  final String? errorMessage;

  const HttpJsonResponse({
    required this.status,
    required this.json,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'Status: ${status.value}, body: $json, errorMessage: $errorMessage';
  }

  Map<String, dynamic>? getJson() {
    if (status.isSuccessful()) {
      return json;
    } else {
      return null;
    }
  }
}

enum HttpStatus {
  ok(200),
  created(201),
  noContent(204),
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  methodNotAllowed(405),
  requestTimeout(408),
  internalServerError(500),
  badGateway(502),
  serviceUnavailable(503),
  gatewayTimeout(504),
  undefined(900);

  const HttpStatus(this.value);

  bool isSuccessful() {
    return this == HttpStatus.ok
        || this == HttpStatus.created
        || this == HttpStatus.noContent;
  }

  factory HttpStatus.fromValue(int value) {
    try {
      return HttpStatus.values.firstWhere((element) => element.value == value);
    } catch(_) {
      return HttpStatus.undefined;
    }
  }

  final int value;
}