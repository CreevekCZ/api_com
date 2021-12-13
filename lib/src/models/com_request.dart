import 'package:api_com/api_com.dart';

class ComRequest<Model> {
  final HttpMethod method;
  final String protocol;
  final String host;
  final String uri;

  String? token;

  Model? Function(dynamic rawPayload, ResponseStatus status)? decoder;

  Map<String, dynamic>? parameters;

  Map<String, String> get headers {
    var headersList = {'Content-Type': 'application/json; charset=UTF-8'};

    if (token != null) {
      headersList["Authorization"] = "Bearer " + token!;
    }

    return headersList;
  }

  ComRequest({
    required this.method,
    this.protocol = "https",
    required this.host,
    required this.uri,
    this.token,
    this.parameters,
    this.decoder,
  });

  String getUrl() {
    return protocol + "://" + host + uri + _encodeParametersToUrl();
  }

  String _encodeParametersToUrl() {
    String encodedParameters = "";
    String andSymbol = !uri.contains("?") ? "?" : "&";

    Map<String, dynamic> arrayParameters = {};

    if (method == HttpMethod.get && parameters != null) {
      parameters?.forEach(
        (key, value) {
          if (value is Iterable) {
            arrayParameters[key] = value;
            return;
          }
          if (value != null) {
            encodedParameters += "$andSymbol$key=$value";
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
          encodedParameters += "$andSymbol$key[]=$value";
          andSymbol = "&";
        }
      });
    }

    return encodedParameters;
  }
}
