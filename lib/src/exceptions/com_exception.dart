class ComException implements Exception {
  ComException({
    required this.message,
    required this.statusCode,
    this.response,
  });

  final String message;
  final int statusCode;
  final dynamic response;

  @override
  String toString() {
    return 'ComException: $message, statusCode: $statusCode, response: $response';
  }
}
