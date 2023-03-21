import 'dart:convert';
import 'package:api_com/api_com.dart';
import 'package:api_com/src/core/com.dart';
import 'package:http/http.dart' as http;
import 'package:palestine_console/palestine_console.dart';

class ComInterface {
  ComInterface() : _connectivity = Connectivity();

  ComConfig config = ComConfig(onConnectionLose: () {
    Print.red('NO CONNECTIVITY', name: apiComPackageName);
  });

  final Connectivity _connectivity;

  static void _printResult(
    http.Response response,
    Stopwatch stopwatch,
  ) {
    final statusMessagePayload =
        'METHOD: ${response.request!.method}, STATUS: ${response.statusCode}, URL: ${response.request!.url}  ${stopwatch.elapsedMilliseconds} ms';

    if (response.statusCode == 200) {
      Print.green(statusMessagePayload, name: apiComPackageName);
    } else {
      Print.red(statusMessagePayload, name: apiComPackageName);
      Print.white(response.body, name: apiComPackageName);
    }
  }

  Future<ComResponse<Model>> makeRequest<Model>(ComRequest request) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    request = _applyConfigToRequest(request);

    try {
      _validateRequest(request);
    } catch (e) {
      Print.red('Invalid request', name: apiComPackageName);
      return ComResponse<Model>(
        request: request,
        status: ResponseStatus.invalidRequest,
      );
    }

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Print.red('NO CONNECTIVITY | ${request.getUrl()}',
          name: apiComPackageName);

      if (request.skipOnConnectionLoseAction == false) {
        config.onConnectionLose?.call();
      }

      return ComResponse(
        status: ResponseStatus.connectionProblem,
        request: request,
      );
    }

    switch (request.method) {
      case HttpMethod.post:
        return _callPost<Model>(request, stopwatch);
      case HttpMethod.get:
        return _callGet<Model>(request, stopwatch);
      case HttpMethod.put:
        return _callPut<Model>(request, stopwatch);
      case HttpMethod.delete:
        return _callDelete<Model>(request, stopwatch);
      case HttpMethod.patch:
        return _callPatch<Model>(request, stopwatch);
    }
  }

  Future<ComResponse<Model>> _callPost<Model>(
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    final rawResponse = await http.post(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    _printResult(rawResponse, stopwatch);

    return ComResponse<Model>.fromResponse(
      request: request,
      response: rawResponse,
      preDecorder: config.preDecorder,
    );
  }

  Future<ComResponse<Model>> _callPut<Model>(
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    final rawResponse = await http.put(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    _printResult(rawResponse, stopwatch);

    return ComResponse<Model>.fromResponse(
      request: request,
      response: rawResponse,
      preDecorder: config.preDecorder,
    );
  }

  Future<ComResponse<Model>> _callDelete<Model>(
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    final rawResponse = await http.delete(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    _printResult(rawResponse, stopwatch);

    return ComResponse<Model>.fromResponse(
      request: request,
      response: rawResponse,
      preDecorder: config.preDecorder,
    );
  }

  Future<ComResponse<Model>> _callPatch<Model>(
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    final rawResponse = await http.patch(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    _printResult(rawResponse, stopwatch);

    return ComResponse<Model>.fromResponse(
      request: request,
      response: rawResponse,
      preDecorder: config.preDecorder,
    );
  }

  Future<ComResponse<Model>> _callGet<Model>(
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    final rawResponse = await http.get(
      Uri.parse(request.getUrl()),
      headers: request.headers,
    );

    _printResult(rawResponse, stopwatch);

    return ComResponse<Model>.fromResponse(
      request: request,
      response: rawResponse,
      preDecorder: config.preDecorder,
    );
  }

  String httpMethodEnumToString(HttpMethod method) {
    switch (method) {
      case HttpMethod.post:
        return 'post';
      case HttpMethod.get:
        return 'get';
      case HttpMethod.put:
        return 'put';
      case HttpMethod.delete:
        return 'delete';
      case HttpMethod.patch:
        return 'patch';
    }
  }

  static ResponseStatus statusCodeToResponseStatus(int statusCode) {
    switch (statusCode) {
      case 200:
        return ResponseStatus.success;

      case 201:
        return ResponseStatus.created;

      case 202:
        return ResponseStatus.accepted;

      case 204:
        return ResponseStatus.noContent;

      case 400:
        return ResponseStatus.badRequest;

      case 401:
        return ResponseStatus.unauthorized;

      case 402:
        return ResponseStatus.paymentRequired;

      case 403:
        return ResponseStatus.forbidden;

      case 404:
        return ResponseStatus.notFound;

      case 405:
        return ResponseStatus.methodNotAllowed;

      case 406:
        return ResponseStatus.notAcceptable;

      case 422:
        return ResponseStatus.unprocessableEntity;

      case 429:
        return ResponseStatus.tooManyRequests;

      case 500:
        return ResponseStatus.serverError;
    }
    return ResponseStatus.unknownStatus;
  }

  ComRequest _applyConfigToRequest(ComRequest request) {
    if (request.host == null && config.mainHost != null) {
      request = request.copyWith(host: config.mainHost!);
    }

    if (config.preferredProtocol != null) {
      request = request.copyWith(protocol: config.preferredProtocol!);
    }

    if (config.sharedHeaders != null) {
      final Map<String, String> allHeaders = Map.from(request.headers);
      allHeaders.addAll(config.sharedHeaders ?? {});

      request = request.copyWith(headers: allHeaders);
    }

    return request;
  }

  void _validateRequest(ComRequest request) {
    if (request.host == null) {
      throw Exception('Host is null');
    }
  }

  Future<bool> hasInternetConnection() async {
    final connectionStatus = await _connectivity.checkConnectivity();
    return connectionStatus != ConnectivityResult.none;
  }

  Connectivity getConnectivityInstance() {
    return _connectivity;
  }
}
