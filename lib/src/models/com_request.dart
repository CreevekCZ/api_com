import 'package:api_com/api_com.dart';

class ComRequest<Model extends BaseModel> {
  final HttpMethod method;
  final String protocol;
  final String host;
  final String uri;

  String? token;

  Model Function(dynamic rawPayload, ResponseStatus status)? decoder;

  Map<String, dynamic>? parameters;

  Map<String, String> get headers {
    var headersList = {'Content-Type': 'application/json; charset=UTF-8'};

    if (token != null) {
      headers["Authorization"] = "Bearer " + token!;
    }

    return headersList;
  }

  ComRequest({
    required this.method,
    required this.protocol,
    required this.host,
    required this.uri,
    this.parameters,
    this.decoder,
  });

  String getUrl() {
    return protocol + "://" + host + uri + _encodeParametersToUrl();
  }

  String _encodeParametersToUrl() {
    String encodedParameters = "";
    String andSymbol = !uri.contains("?") ? "?" : "&";

    if (method == HttpMethod.get && parameters != null) {
      parameters?.forEach(
        (key, value) {
          encodedParameters += "$andSymbol$key[]=$value";
          andSymbol = "&";
        },
      );
    }

    return encodedParameters;
  }
}
