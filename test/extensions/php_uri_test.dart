import 'package:api_com/src/extensions/php_uri.dart' show PhpUri;
import 'package:test/test.dart';

void main() {
  test("Test encoding URL with array of parameters for php server", () {
    String exceptationEncoded =
        "https://example.com/api/v1/events?active=true&posId[]=1&posId[]=2&userId[]=3";

    var encodedUrl = PhpUri.encodeForPhpServer(
      host: 'example.com',
      uri: '/api/v1/events',
      parameters: {
        'active': true,
        'posId': [1, 2],
        'userId': [3],
      },
    );

    expect(encodedUrl, exceptationEncoded);
  });
}