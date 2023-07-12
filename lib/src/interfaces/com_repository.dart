import 'package:api_com/api_com.dart';

abstract class ComRepository<Model> {
  ComRepository({required this.decoder});
  final Function() decoder;

  Future<ComResult<Model>> send(ComRequest request) async {
    return ComResult();
  }
}
