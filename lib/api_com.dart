export 'src/models/com_response.dart' show ComResponse;
export 'src/models/com_request.dart' show ComRequest;
export 'src/enums/enums.dart';
export 'src/models/models.dart';
export 'src/core/com_config.dart';
import 'src/core/com.dart';
export 'src/extensions/php_uri.dart' show PhpUri;

class _ComImpl extends ComInterface {}

// ignore: non_constant_identifier_names, prefer_const_declarations
final Com = _ComImpl();
