import 'http_json_response.dart';

class DataResponse<E> {
  final E? data;
  final String? errorMessage;

  const DataResponse({
    required this.data,
    required this.errorMessage,
  });

  factory DataResponse.empty() {
    return const DataResponse(data: null, errorMessage: null);
  }

  factory DataResponse.fromHttpResponse(E? data, HttpJsonResponse response) {
    String? message;
    if (!response.status.isSuccessful()) {
      message = response.errorMessage ?? response.status.name;
    }
    return DataResponse(
        data: data,
        errorMessage: message
    );
  }
}