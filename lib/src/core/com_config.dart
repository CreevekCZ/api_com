import 'dart:convert';

class ComConfig {
  final Function() onConnectionLose;
  final Encoding encoding;
  final String? preferredProtocol;
  final String? mainHost;

  final dynamic Function(dynamic)? preDecorder;

  ComConfig({
    Encoding? encoding,
    this.preferredProtocol,
    this.mainHost,
    required this.onConnectionLose,
    this.preDecorder,
  }) : this.encoding = encoding ?? Encoding.getByName("utf-8")!;
}
