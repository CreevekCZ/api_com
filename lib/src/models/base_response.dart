import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import '../enums/response_status.dart';

class BaseResponse<T> {
  T Function(dynamic, ResponseStatus)? decoder;

  final ResponseStatus status;
  final dynamic payload;

  BaseResponse({
    required this.status,
    required this.payload,
    this.decoder,
  });

  factory BaseResponse.fromResponse(
    Response response,
    T Function(dynamic, ResponseStatus)? decoder,
  ) {
    return BaseResponse(
      status: _responseStatusFormStatusCode(response.statusCode),
      payload: _decodeUtf8BodyBytes(response.bodyBytes),
      decoder: decoder,
    );
  }

  T? getDecodedPayload() {
    return decoder != null ? decoder!(payload, status) : null;
  }

  static dynamic _decodeUtf8BodyBytes(Uint8List body) {
    Map<String, dynamic> decodedJson = jsonDecode(utf8.decode(body));

    if (decodedJson.containsKey("payload")) {
      return decodedJson["payload"];
    }

    return null;
  }

  static ResponseStatus _responseStatusFormStatusCode(int statusCode) {
    switch (statusCode) {
      case 200:
        return ResponseStatus.success;

      case 201:
        return ResponseStatus.created;

      case 202:
        return ResponseStatus.accepted;

      case 204:
        return ResponseStatus.noContent;

      case 500:
        return ResponseStatus.serverError;
    }
    return ResponseStatus.unknownStatus;
  }
}
