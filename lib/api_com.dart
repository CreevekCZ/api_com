export 'src/models/com_response.dart' show ComResponse;
export 'src/models/com_request.dart' show ComRequest;
export 'src/enums/enums.dart';
export 'src/models/models.dart';
import 'src/core/com.dart';

class _ComImpl extends ComInterface {}

// ignore: non_constant_identifier_names, prefer_const_declarations
final Com = _ComImpl();
