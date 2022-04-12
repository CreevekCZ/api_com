import 'package:api_com/api_com.dart';

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

  ComRequest({
    this.protocol = "https",
    required this.method,
    required this.host,
    required this.uri,
    this.token,
    this.parameters,
    this.decoder,
    Map<String, String>? headers,
  }) : _headers = headers;

  String getUrl() {
    if (host == null) {
      throw Exception("Host is null");
    }
    return protocol + "://" + host! + uri + _encodeParametersToUrl();
  }

  String _encodeParametersToUrl() {
    String encodedParameters = "";
    String andSymbol = !uri.contains("?") ? "?" : "&";

    Map<String, dynamic> arrayParameters = {};

    if (method == HttpMethod.get && parameters != null) {
      parameters?.forEach(
        (key, value) {
          var encodedValue = Uri.encodeComponent(value.toString());

          if (value is Iterable) {
            arrayParameters[key] = encodedValue;
            return;
          }
          if (value != null) {
            encodedParameters += "$andSymbol$key=$encodedValue";
            andSymbol = "&";
          }
        },
      );
    }

    encodedParameters =
        _encodeArrayParameters(arrayParameters, encodedParameters, andSymbol);

    return encodedParameters;
  }

  dynamic _encodeArrayParameters(
      arrayParameters, encodedParameters, andSymbol) {
    andSymbol = !encodedParameters.contains("?") ? "?" : "&";

    if (arrayParameters.isNotEmpty) {
      arrayParameters.forEach((key, value) {
        if (value != null) {
          var encodedValue = Uri.encodeComponent(value.toString());
          encodedParameters += "$andSymbol$key[]=$encodedValue";
          andSymbol = "&";
        }
      });
    }

    return encodedParameters;
  }
}
