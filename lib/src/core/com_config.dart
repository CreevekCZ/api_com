import 'dart:convert';
import 'package:api_com/api_com.dart';

class ComConfig {
  ComConfig({
    Encoding? encoding,
    this.preferredProtocol,
    this.mainHost,
    this.onConnectionLose,
    this.preDecorder,
    this.sharedHeaders,
  }) : encoding = encoding ?? Encoding.getByName('utf-8')!;

  /// Shared headers that will be added to every request.
  /// You can use this property to add headers like `Authorization` or `Content-Type`.
  final Map<String, String>? sharedHeaders;

  /// UTF-8 by default
  final Encoding encoding;

  // HTTPS by default
  final String? preferredProtocol;

  /// If you set this property you will be able to use [ComRequest] without spedifieing host property.
  final String? mainHost;

  /// This function is called when internet connection is lost.
  final Function()? onConnectionLose;

  /// Predecoder should be used to decode the response body before passing it to the decoder.
  /// It is useful when your API returns payload where your targer object is wrapped in other property. For example User payload like this:
  /// ```json
  /// {
  ///   "status": "ok",
  ///   "payload": {
  ///       "firstName": "John",
  ///       "lastName": "Doe",
  ///       "age": 30,
  ///   }
  /// }
  /// ```
  /// In this case you can use the predecoder to extract the payload from the response body like this:
  /// ```dart
  /// Com.config = ComConfig(
  ///   preDecorder: (payload) => payload["payload"],
  /// );
  /// ```
  final dynamic Function(dynamic)? preDecorder;

  String getUrl() => '$preferredProtocol://$mainHost';

  ComConfig copyWith({
    Encoding? encoding,
    String? preferredProtocol,
    String? mainHost,
    Function()? onConnectionLose,
    dynamic Function(dynamic)? preDecorder,
    Map<String, String>? sharedHeaders,
  }) {
    return ComConfig(
      encoding: encoding ?? this.encoding,
      preferredProtocol: preferredProtocol ?? this.preferredProtocol,
      mainHost: mainHost ?? this.mainHost,
      onConnectionLose: onConnectionLose ?? this.onConnectionLose,
      preDecorder: preDecorder ?? this.preDecorder,
      sharedHeaders: sharedHeaders ?? this.sharedHeaders,
    );
  }
}
