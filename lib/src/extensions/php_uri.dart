extension PhpUri on Uri {
  static String encodeForPhpServer({
    String protocol = 'https',
    required String host,
    required String uri,
    required Map<String, dynamic>? parameters,
  }) {
    String result = protocol + "://" + host + uri;

    String encodedParameters = "";
    String andSymbol = !uri.contains("?") ? "?" : "&";

    Map<String, dynamic> arrayParameters = {};

    if (parameters != null) {
      parameters.forEach(
        (key, value) {
          var encodedValue = Uri.encodeComponent(value.toString());

          if (value is Iterable) {
            arrayParameters[key] = value;
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

    return result + encodedParameters;
  }

  static String _encodeArrayParameters(
      arrayParameters, encodedParameters, andSymbol) {
    andSymbol = !encodedParameters.contains("?") ? "?" : "&";

    if (arrayParameters.isNotEmpty) {
      arrayParameters.forEach((key, value) {
        for (var item in value) {
          if (item != null) {
            var encodedValue = Uri.encodeComponent(item.toString());
            encodedParameters += "$andSymbol$key[]=$encodedValue";
            andSymbol = "&";
          }
        }
      });
    }

    return encodedParameters;
  }
}
