import '../exceptions/com_exception.dart';

class ComResult<Model> {
  ComResult({
    this.payload,
    this.exception,
  }) : assert((payload == null) || (exception == null));

  final Model? payload;
  final ComException? exception;

  bool get isSuccess => exception == null;
}
