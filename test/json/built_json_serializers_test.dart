import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../lib/src/json/built_json_serializers.dart';
import 'hello/hello.dart';
import 'serializers.dart';

void main() {
  test('test json serialize', () {
    String jsonText = '''
 {
      "id": 157538,
      "date": "2017-07-21T10:30:34",
      "date_gmt": "2017-07-21T17:30:34",
      "type": "post",
      "link": "https://example.com",
      "title": {
          "rendered": "Json 2 dart built_value converter"
      },
      "tags": [
          1798,
          6298
      ]
    }
    ''';

    final hello = serializers.deserializeWith(Hello.serializer, jsonDecode(jsonText));

    print("==>${hello?.id}");
    final _h = serializers.serializeWith(Hello.serializer, hello);
    print(json.encode(_h));

    final formJson = Hello.formJson(jsonText);
    print(formJson?.toJson());

    final builtJsonSerializers = BuiltJsonSerializers(serializers);
    var result = builtJsonSerializers.parseObject(jsonText, resultType: Hello);
    result = builtJsonSerializers.parseObject(json.decode(jsonText), resultType: Hello);
    print("===> $result");
    var text = builtJsonSerializers.toJson(result);
    print("===> $text");
  });
}
