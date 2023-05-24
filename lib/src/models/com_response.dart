import 'dart:convert';
import 'dart:typed_data';
import 'package:api_com/api_com.dart';
import 'package:api_com/src/core/com.dart';
import 'package:http/http.dart' as http;
import 'package:palestine_console/palestine_console.dart';

class ComResponse<Model> {
  ComResponse({
    required this.status,
    required this.request,
    this.response,
    this.payload,
  });

  factory ComResponse.fromResponse({
    required http.Response response,
    required ComRequest request,
    Function(dynamic)? preDecorder,
  }) {
    final ResponseStatus status =
        ComInterface.statusCodeToResponseStatus(response.statusCode);
    Model? payload;
    if (request.decoder != null) {
      try {
        dynamic decodedBody = decodeUtf8BodyBytes(response.bodyBytes);

        if (preDecorder != null && request.ignorePreDecoder == false) {
          decodedBody = preDecorder(decodedBody);
        }

        payload = request.decoder!(decodedBody, status) as Model?;
      } catch (e) {
        Print.red(
            'Unable to decode payload. Error: ${Model.runtimeType} ${e.toString()}',
            name: apiComPackageName);
      }
    }

    return ComResponse(
      response: response,
      request: request,
      status: status,
      payload: payload,
    );
  }

  /// Original [ComRequest] used to get the response
  final ComRequest request;

  /// Raw response from the server [http.Response]
  final http.Response? response;
  final ResponseStatus status;

  bool get isSuccess => status == ResponseStatus.success;
  int? get statusCode => response?.statusCode;

  Model Function(dynamic rawPayload, ResponseStatus status)? decoder;

  Model? payload;

  static dynamic decodeUtf8BodyBytes(Uint8List body) {
    final dynamic decodedJson = jsonDecode(utf8.decode(body));

    return decodedJson;
  }
}
