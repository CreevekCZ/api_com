import 'dart:convert';
import 'dart:typed_data';
import 'package:api_com/api_com.dart';
import 'package:http/http.dart' as http;

class ComResponse<Model extends BaseModel> {
  final ComRequest request;
  final http.Response? response;
  final ResponseStatus status;

  Model Function(dynamic rawPayload, ResponseStatus status)? decoder;

  Model? payload;

  ComResponse({
    required this.status,
    required this.request,
    this.response,
    this.payload,
  });

  factory ComResponse.fromResponse({
    required http.Response response,
    required ComRequest request,
  }) {
    ResponseStatus status = Com.statusCodeToResponseStatus(response.statusCode);
    Model? payload;
    if (request.decoder != null) {
      payload =
          request.decoder!(_decodeUtf8BodyBytes(response.bodyBytes), status)
              as Model?;
    }

    return ComResponse(
      response: response,
      request: request,
      status: status,
      payload: payload,
    );
  }

  static dynamic _decodeUtf8BodyBytes(Uint8List body) {
    Map<String, dynamic> decodedJson = jsonDecode(utf8.decode(body));

    if (decodedJson.containsKey("payload")) {
      return decodedJson["payload"];
    }

    return null;
  }
}
