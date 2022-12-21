import 'package:api_com/src/extensions/uri_php_extension.dart'
    show UriPhpEstension;
import 'package:test/test.dart';

void main() {
  test('Test encoding URL with array of parameters for php server', () {
    const String exceptationEncoded =
        'https://example.com/api/v1/events?active=true&posId[]=1&posId[]=2&userId[]=3';

    final encodedUrl = UriPhpEstension.encodeForPhpServer(
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
