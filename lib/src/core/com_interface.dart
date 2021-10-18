import 'dart:convert';

import 'package:api_com/api_com.dart';
import 'package:api_com/src/core/com_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class ComInterface {
  static const String _packageName = "API_COM";

  ComConfig config = ComConfig(onConnectionLose: () {
    Print.red("NO CONNECTIVITY", name: _packageName);
  });

  static void printResult(http.Response response) {
    String statusMessagePayload =
        "METHOD: ${response.request!.method}, STATUS: ${response.statusCode}, URL: ${response.request!.url}";

    if (response.statusCode == 200) {
      Print.green(statusMessagePayload, name: _packageName);
    } else {
      Print.red(statusMessagePayload, name: _packageName);
    }
  }

  Future<ComResponse<Model>> makeRequest<Model>(
      ComRequest request) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Print.red("NO CONNECTIVITY", name: _packageName);
      config.onConnectionLose();
      return ComResponse(
          status: ResponseStatus.connectionProblem,
          request: request,
          response: null);
    }

    switch (request.method) {
      case HttpMethod.post:
        return await _callPost<Model>(request);
      case HttpMethod.get:
        return await _callGet<Model>(request);
      case HttpMethod.put:
        return await _callPut<Model>(request);
      case HttpMethod.delete:
        return await _callDelete<Model>(request);
      case HttpMethod.patch:
        return await _callPatch<Model>(request);
    }
  }

  // ignore: unused_element
  Future<ComResponse<Model>> _callPost<Model>(
      ComRequest request) async {
    final rawResponse = await http.post(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    printResult(rawResponse);

    return ComResponse<Model>.fromResponse(
        request: request, response: rawResponse);
  }

  // ignore: unused_element
  Future<ComResponse<Model>> _callPut<Model>(
      ComRequest request) async {
    final rawResponse = await http.put(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    printResult(rawResponse);

    return ComResponse<Model>.fromResponse(
        request: request, response: rawResponse);
  }

  // ignore: unused_element
  Future<ComResponse<Model>> _callDelete<Model>(
      ComRequest request) async {
    final rawResponse = await http.delete(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    printResult(rawResponse);

    return ComResponse<Model>.fromResponse(
        request: request, response: rawResponse);
  }

  // ignore: unused_element
  Future<ComResponse<Model>> _callPatch<Model>(
      ComRequest request) async {
    final rawResponse = await http.patch(
      Uri.parse(request.getUrl()),
      headers: request.headers,
      body: jsonEncode(request.parameters),
      encoding: config.encoding,
    );

    printResult(rawResponse);

    return ComResponse<Model>.fromResponse(
        request: request, response: rawResponse);
  }

  // ignore: unused_element
  Future<ComResponse<Model>> _callGet<Model>(
      ComRequest request) async {
    final rawResponse = await http.get(
      Uri.parse(request.getUrl()),
      headers: request.headers,
    );

    printResult(rawResponse);

    return ComResponse<Model>.fromResponse(
        request: request, response: rawResponse);
  }

  //...
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
}
