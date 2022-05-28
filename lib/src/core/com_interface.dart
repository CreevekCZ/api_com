import 'dart:convert';
import 'package:api_com/api_com.dart';
import 'package:api_com/src/core/com.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:palestine_console/palestine_console.dart';

class ComInterface {
  ComConfig config = ComConfig(onConnectionLose: () {
    Print.red("NO CONNECTIVITY", name: apiComPackageName);
  });

  static void _printResult(
    http.Response response,
    Stopwatch stopwatch,
  ) {
    String statusMessagePayload =
        "[${stopwatch.elapsedMilliseconds} ms], METHOD: ${response.request!.method}, STATUS: ${response.statusCode}, URL: ${response.request!.url}";

    if (response.statusCode == 200) {
      Print.green(statusMessagePayload, name: apiComPackageName);
    } else {
      Print.red(statusMessagePayload, name: apiComPackageName);
      Print.white(response.body, name: apiComPackageName);
    }
  }

  Future<ComResponse<Model>> makeRequest<Model>(ComRequest request) async {
    Stopwatch stopwatch = Stopwatch()..start();

    _applyConfigToRequest(request);

    try {
      _validateRequest(request);
    } catch (e) {
      Print.red("Invalid request", name: apiComPackageName);
      return ComResponse<Model>(
        request: request,
        status: ResponseStatus.invalidRequest,
      );
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Print.red("NO CONNECTIVITY", name: apiComPackageName);

      if (config.onConnectionLose != null) {
        config.onConnectionLose!();
      }

      return ComResponse(
        status: ResponseStatus.connectionProblem,
        request: request,
      );
    }

    switch (request.method) {
      case HttpMethod.post:
        return await _callPost<Model>(request, stopwatch);
      case HttpMethod.get:
        return await _callGet<Model>(request, stopwatch);
      case HttpMethod.put:
        return await _callPut<Model>(request, stopwatch);
      case HttpMethod.delete:
        return await _callDelete<Model>(request, stopwatch);
      case HttpMethod.patch:
        return await _callPatch<Model>(request, stopwatch);
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
        return "post";
      case HttpMethod.get:
        return "get";
      case HttpMethod.put:
        return "put";
      case HttpMethod.delete:
        return "delete";
      case HttpMethod.patch:
        return "patch";
    }
  }

  static ResponseStatus statusCodeToResponseStatus(int statusCode) {
    switch (statusCode) {
      case 200:
        return ResponseStatus.success;

      case 201:
        return ResponseStatus.created;

      case 400:
        return ResponseStatus.unauthorized;

      case 202:
        return ResponseStatus.accepted;

      case 204:
        return ResponseStatus.noContent;

      case 500:
        return ResponseStatus.serverError;
    }
    return ResponseStatus.unknownStatus;
  }

  void _applyConfigToRequest(ComRequest request) {
    if (request.host == null && config.mainHost != null) {
      request.host = config.mainHost!;
    }

    if (config.preferredProtocol != null) {
      request.protocol = config.preferredProtocol!;
    }
  }

  void _validateRequest(ComRequest request) {
    if (request.host == null) {
      throw Exception("Host is null");
    }
  }
}
