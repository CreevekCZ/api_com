import 'dart:convert';
import 'dart:typed_data';

import 'package:api_com/api_com.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('ComResponse', () {
    late ComRequest request;
    late http.Response httpResponse;
    late ComResponse<dynamic> comResponse;

    setUp(() {
      request = ComRequest(
        method: HttpMethod.get,
        uri: '/greeting',
      );
      httpResponse = http.Response('{"message": "Hello, world!"}', 200);
      comResponse = ComResponse.fromResponse(
        response: httpResponse,
        request: request,
      );
    });

    group('constructor', () {
      test('should create a ComResponse object with the given properties', () {
        expect(comResponse.request, equals(request));
        expect(comResponse.httpResponse, equals(httpResponse));
        expect(comResponse.status, equals(ResponseStatus.success));
        expect(comResponse.payload, null);
      });
    });

    group('isSuccess', () {
      test('should return true if the status is success', () {
        expect(comResponse.isSuccess, isTrue);
      });

      test('should return false if the status is not success', () {
        final errorResponse = ComResponse<dynamic>(
          status: ResponseStatus.error,
          request: request,
        );

        expect(errorResponse.isSuccess, isFalse);
      });
    });

    group('statusCode', () {
      test('should return the status code of the http response', () {
        expect(comResponse.statusCode, equals(200));
      });

      test('should return null if the http response is null', () {
        final nullResponse = ComResponse<dynamic>(
          status: ResponseStatus.success,
          request: request,
        );

        expect(nullResponse.statusCode, isNull);
      });
    });

    group('ComResponse decodeUtf8BodyBytes', () {
      test('should decode the body bytes using utf8', () {
        final bodyBytes = utf8.encode('{"message": "Hello, world!"}');
        final Uint8List bodyBytesEncoded = Uint8List.fromList(bodyBytes);
        final decodedBody = ComResponse.decodeUtf8BodyBytes(bodyBytesEncoded);

        expect(decodedBody, equals({'message': 'Hello, world!'}));
      });
    });

    group('rawPayload', () {
      test('should return the raw payload', () {
        expect(comResponse.rawPayload, equals('{"message": "Hello, world!"}'));
      });

      test('should return null if the decoder is null', () {
        final nullDecoderResponse = ComResponse<dynamic>(
          status: ResponseStatus.success,
          request: request,
        );

        expect(nullDecoderResponse.payload, isNull);
      });
    });

    group('decoder', () {
      test('should decode the response body using the decoder function', () {
        final customDecoderResponse = ComResponse.fromResponse(
          response: httpResponse,
          request: request,
          preDecorder: (dynamic body) => {'customMessage': body['message']},
        );

        expect(customDecoderResponse.payload,
            equals({'customMessage': 'Hello, world!'}));
      });

      test('should return null if the decoder is null', () {
        final nullDecoderResponse = ComResponse<dynamic>(
          status: ResponseStatus.success,
          request: request,
        );

        expect(nullDecoderResponse.decoder, isNull);
      });
    });
  });
}
