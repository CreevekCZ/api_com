import 'dart:convert';
import 'package:api_com/src/enums/http_methods.dart';
import 'package:api_com/src/enums/response_status.dart';
import 'package:api_com/src/extensions/uri_php_extension.dart';

class ComRequest<Model> {
  final HttpMethod method;

  /// https by default
  String protocol;

  /// for example:
  /// ```dart
  /// var host = "example.com";
  /// var host = "www.example.com";
  /// ```
  String? host;

  /// for example:
  /// ```dart
  /// var uri = "/api/v1/login";
  /// ```
  final String uri;

  /// for example:
  /// ```dart
  /// var headers = {
  ///   "Content-Type": "application/json",
  ///   "Authorization": "x-token xxxxx", // here you can override the [ComRequest.token] attribute
  /// };
  /// ```
  final Map<String, String>? _headers;

  /// Bearer token by default
  /// Authorization attribute by addning
  /// ```dart
  /// var authorization = {"Authorization": "x-token xxxxx",};
  /// ```
  /// to headers attribute of [ComRequest]
  String? token;

  Model? Function(dynamic rawPayload, ResponseStatus status)? decoder;

  ///Parameters are automatically sent to the server as request JSON body but in the case of GET method they are encoded in URL as GET parameters
  Map<String, dynamic>? parameters;

  Map<String, String> get headers {
    var headersList = {'Content-Type': 'application/json; charset=UTF-8'};

    if (token != null) {
      headersList["Authorization"] = "Bearer " + token!;
    }

    if (_headers != null) {
      headersList.addAll(_headers!);
    }

    return headersList;
  }

  /// if this parameter is true then onConnectionLose() action defined in ConConfig will not be called
  bool skipOnConnectionLoseAction;

  /// if this parameter is true than decoding of rawPayload will ignore ComConfig:preDecoder function
  bool ignorePreDecoder;

  ComRequest({
    this.protocol = "https",
    required this.method,
    this.host,
    required this.uri,
    this.token,
    this.parameters,
    this.decoder,
    Map<String, String>? headers,
    this.skipOnConnectionLoseAction = false,
    this.ignorePreDecoder = false,
  }) : _headers = headers;

  String getUrl() {
    if (host == null) {
      throw Exception("Host is null");
    }

    return UriPhpEstension.encodeForPhpServer(
      host: host!,
      uri: uri,
      parameters: method == HttpMethod.get ? parameters : null,
    );
  }

  String getBody() {
    if (method == HttpMethod.get) {
      throw Exception("GET method doesn't have body");
    }

    if (parameters == null) {
      return "";
    }

    return jsonEncode(parameters);
  }
}
