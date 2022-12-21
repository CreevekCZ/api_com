import 'src/core/com.dart';
export 'src/core/com_config.dart';
export 'src/enums/enums.dart';
export 'src/extensions/date_time_atom_extension.dart'
    show DateTimeAtomExtension;
export 'src/extensions/uri_php_extension.dart' show UriPhpEstension;
export 'src/models/com_request.dart' show ComRequest;
export 'src/models/com_response.dart' show ComResponse;
export 'src/models/models.dart';

class _ComImpl extends ComInterface {}

// ignore: non_constant_identifier_names, prefer_const_declarations
final Com = _ComImpl();
