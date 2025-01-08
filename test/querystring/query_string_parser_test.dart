import 'package:oak_dart_basic/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("query string parse ", () {
    //http://www.baidu.com?
//    var queryString = Uri.encodeQueryComponent("a=1&b=2&c=3&b=4&h=我的&e=&f=你", encoding: utf8);
    var queryString = "a=1&b=2&c=3&b=4&h=我的&e=&f=你";
    var parse = QueryStringParser.parse(queryString);
    print("$parse");
    var text = QueryStringParser.stringify(parse);
    var queryParams = Uri.splitQueryString(text ?? "");
    print("splitQueryString ==>$queryParams");
    print("$text");
    parse = QueryStringParser.parse(text ?? '"', needDecode: true);
    print("$parse");
  });
}
