import 'dart:convert';
import 'package:api_com/api_com.dart';
import 'package:api_com/src/core/com.dart';
import 'package:http/http.dart' as http;
import 'package:palestine_console/palestine_console.dart';

class ComInterface {
  ComInterface() : _connectivity = Connectivity();

  final Connectivity _connectivity;

  ComConfig config = ComConfig(onConnectionLose: () {
    Print.red('NO CONNECTIVITY', name: apiComPackageName);
  });

  Future<ComResponse<Model>> makeRequest<Model>(ComRequest request) async {
    request = _applyConfigToRequest(request);

    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      _validateRequest(request);
    } catch (e) {
      return _handleInvalidRequest(request);
    }

    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return _handleNoConnectivity(request);
    }

    final ComResponse<Model> response = await _callHttpMethod<Model>(
      request.method,
      request,
      stopwatch,
    );

    return response;
  }

  ComResponse<Model> _handleInvalidRequest<Model>(ComRequest request) {
    Print.red('Invalid request', name: apiComPackageName);

    final ComResponse<Model> response = ComResponse<Model>(
      request: request,
      status: ResponseStatus.invalidRequest,
    );

    config.onMakeRequestComplete?.call(response);

    return response;
  }

  ComResponse<Model> _handleNoConnectivity<Model>(ComRequest request) {
    Print.red('NO CONNECTIVITY | ${request.getUrl()}', name: apiComPackageName);

    if (config.onConnectionLose != null &&
        request.skipOnConnectionLoseAction == false) {
      config.onConnectionLose!();
    }

    final ComResponse<Model> response = ComResponse<Model>(
      status: ResponseStatus.connectionProblem,
      request: request,
    );

    config.onMakeRequestComplete?.call(response);

    return response;
  }

  Future<ComResponse<Model>> _callHttpMethod<Model>(
    HttpMethod method,
    ComRequest request,
    Stopwatch stopwatch,
  ) async {
    late ComResponse<Model> response;

    switch (method) {
      case HttpMethod.post:
        response = await _callPost<Model>(request, stopwatch);
        break;
      case HttpMethod.get:
        response = await _callGet<Model>(request, stopwatch);
        break;
      case HttpMethod.put:
        response = await _callPut<Model>(request, stopwatch);
        break;
      case HttpMethod.delete:
        response = await _callDelete<Model>(request, stopwatch);
        break;
      case HttpMethod.patch:
        response = await _callPatch<Model>(request, stopwatch);
        break;
    }

    config.onMakeRequestComplete?.call(response);

    return response;
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

  void _printResult<Model>(
    http.Response response,
    Stopwatch stopwatch,
  ) {
    final statusMessagePayload =
        'METHOD: ${response.request!.method}, STATUS: ${response.statusCode}, URL: ${response.request!.url}  ${stopwatch.elapsedMilliseconds} ms';

    if (response.statusCode == 200) {
      Print.green(statusMessagePayload, name: apiComPackageName);
    } else {
      Print.red(statusMessagePayload, name: apiComPackageName);
      Print.blue(response.body, name: apiComPackageName);
    }
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
}
