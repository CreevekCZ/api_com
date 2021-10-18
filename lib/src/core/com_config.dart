import 'dart:convert';

class ComConfig {
  Function() onConnectionLose;
  Encoding encoding = Encoding.getByName("utf-8")!;
  ComConfig({
    required this.onConnectionLose,
  });
}
