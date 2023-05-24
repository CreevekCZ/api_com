import 'dart:convert';
import 'dart:typed_data';
import 'package:api_com/src/models/com_response.dart';
import 'package:test/test.dart';

void main() {
  group('_decodeUtf8BodyBytes', () {
    test('should decode valid JSON', () {
      const json = '{"name": "John", "age": 30}';
      final body = Uint8List.fromList(utf8.encode(json));
      final decoded = ComResponse.decodeUtf8BodyBytes(body);
      expect(decoded, equals({'name': 'John', 'age': 30}));
    });

    test('should throw FormatException for invalid JSON', () {
      const json = '{"name": "John", "age": 30';
      final body = Uint8List.fromList(utf8.encode(json));
      expect(
          () => ComResponse.decodeUtf8BodyBytes(body), throwsFormatException);
    });

    test('should throw TypeError for non-Uint8List input', () {
      const body = 'not a Uint8List';
      expect(() => ComResponse.decodeUtf8BodyBytes(body as Uint8List),
          throwsException);
    });
  });
}
