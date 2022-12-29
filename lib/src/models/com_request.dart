import 'dart:convert';
import 'package:api_com/src/enums/http_methods.dart';
import 'package:api_com/src/enums/response_status.dart';
import 'package:api_com/src/extensions/uri_php_extension.dart';

class ComRequest<Model> {
  ComRequest({
    this.protocol = 'https',
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

  final HttpMethod method;

  /// https by default
  final String protocol;

  /// for example:
  /// ```dart
  /// var host = "example.com";
  /// var host = "www.example.com";
  /// ```
  final String? host;

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
  final String? token;

  final Model? Function(dynamic rawPayload, ResponseStatus status)? decoder;

  ///Parameters are automatically sent to the server as request JSON body but in the case of GET method they are encoded in URL as GET parameters
  final Map<String, dynamic>? parameters;

  Map<String, String> get headers {
    final headersList = {'Content-Type': 'application/json; charset=UTF-8'};

    if (token != null) {
      headersList['Authorization'] = 'Bearer ${token!}';
    }

    if (_headers != null) {
      headersList.addAll(_headers!);
    }

    return headersList;
  }

  /// if this parameter is true then onConnectionLose() action defined in ConConfig will not be called
  final bool skipOnConnectionLoseAction;

  /// if this parameter is true than decoding of rawPayload will ignore ComConfig:preDecoder function
  final bool ignorePreDecoder;

  String getUrl() {
    if (host == null) {
      throw Exception('Host is null');
    }

    return UriPhpEstension.encodeForPhpServer(
      host: host!,
      uri: uri,
      parameters: method == HttpMethod.get ? parameters : null,
    );
  }

  String? getBody() {
    if (method == HttpMethod.get) {
      throw Exception("GET method doesn't have body");
    }

    if (parameters == null) {
      return null;
    }

    return jsonEncode(parameters);
  }

  ComRequest<Model> copyWith({
    String? protocol,
    HttpMethod? method,
    String? host,
    String? uri,
    String? token,
    Map<String, dynamic>? parameters,
    Model? Function(dynamic rawPayload, ResponseStatus status)? decoder,
    Map<String, String>? headers,
    bool? skipOnConnectionLoseAction,
    bool? ignorePreDecoder,
  }) {
    return ComRequest<Model>(
      protocol: protocol ?? this.protocol,
      method: method ?? this.method,
      host: host ?? this.host,
      uri: uri ?? this.uri,
      token: token ?? this.token,
      parameters: parameters ?? this.parameters,
      decoder: decoder ?? this.decoder,
      headers: headers ?? _headers,
      skipOnConnectionLoseAction:
          skipOnConnectionLoseAction ?? this.skipOnConnectionLoseAction,
      ignorePreDecoder: ignorePreDecoder ?? this.ignorePreDecoder,
    );
  }
}
