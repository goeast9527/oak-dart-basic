/// method to command resolver
/// [methodName]
typedef String MethodNameCommandResolver(String methodName);

final MethodNameCommandResolver noneResolver = (methodName) => methodName;
final MethodNameCommandResolver toUpperCaseResolver = (methodName) => methodName.toUpperCase();
final MethodNameCommandResolver toLowerCaseResolver = (methodName) => methodName.toLowerCase();
final MethodNameCommandResolver initialLowercase = (String methodName) {
  var firstChar = methodName.substring(0, 1);
  return firstChar.toLowerCase() + methodName.substring(1, methodName.length);
};

var _toHumpRegExp = new RegExp("\\_(.+?)", dotAll: true);

/// 下划线转驼峰
final MethodNameCommandResolver toHumpResolver = (String methodName) {
  return methodName.replaceAllMapped(_toHumpRegExp, (Match match) {
    String? text = match.group(0);
    if (text == null) {
      return '';
    }
    return text.substring(1, text.length).toUpperCase();
  });
};

var _toLineResolver = new RegExp("([A-Z])", dotAll: true);

/// 驼峰转下划线
final MethodNameCommandResolver toLineResolver = (String methodName) {
  return methodName.replaceAllMapped(_toLineResolver, (Match match) {
    String? text = match.group(0);
    if (text == null) {
      return '';
    }
    return "_" + text.toLowerCase();
  });
};
