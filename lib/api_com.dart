export 'src/models/com_response.dart' show ComResponse;
export 'src/models/com_request.dart' show ComRequest;
export 'src/enums/enums.dart';
export 'src/models/models.dart';
export 'src/core/com_config.dart';
import 'src/core/com.dart';
export 'src/extensions/uri_php_extension.dart' show UriPhpEstension;

class _ComImpl extends ComInterface {}

// ignore: non_constant_identifier_names, prefer_const_declarations
final Com = _ComImpl();
