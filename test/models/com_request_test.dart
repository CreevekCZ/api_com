import 'dart:convert';
import 'package:api_com/src/enums/http_methods.dart';
import 'package:api_com/src/models/com_request.dart';
import 'package:test/test.dart';

void main() {
  group('ComRequest test', () {
    test('getUrl()', () {
      final ComRequest request = ComRequest(
        host: 'example.com',
        uri: '/api/v1/events',
        method: HttpMethod.get,
        parameters: {
          'active': true,
          'userId': 3,
          'posId': [1, 2],
        },
      );

      const String exceptationEncoded =
          'https://example.com/api/v1/events?active=true&userId=3&posId[]=1&posId[]=2';

      final result = request.getUrl();

      expect(result, exceptationEncoded);
    });

    test('Try to get JSON body form ComRequest with method GET', () {
      final ComRequest request = ComRequest(
        host: 'example.com',
        uri: '/api/v1/events',
        method: HttpMethod.get,
        parameters: {
          'active': true,
          'userId': 3,
          'posId': [1, 2],
        },
      );

      expect(() => request.getBody(), throwsA(const TypeMatcher<Exception>()));
    });

    test('Try to get JSON body form ComRequest with method other than GET', () {
      final ComRequest request = ComRequest(
        host: 'example.com',
        uri: '/api/v1/events',
        method: HttpMethod.post,
        parameters: {
          'active': true,
          'userId': 3,
          'posId': [1, 2],
        },
      );

      expect(
        request.getBody(),
        jsonEncode({
          'active': true,
          'userId': 3,
          'posId': [1, 2],
        }),
      );
    });
  });
}
