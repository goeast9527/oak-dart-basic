
import 'package:oak_dart_basic/src/resolve/simple_method_name_command_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('command test resolver', () {
    var result1 = toHumpResolver("set_count_ab_ces");
    var result2 = toLineResolver("setCountAbCes");

    print("$result1 $result2");
  });
}
