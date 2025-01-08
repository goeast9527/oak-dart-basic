RegExp replaceSymbolRegExp = new RegExp('Symbol|\\("|"\\)');

/// 解析 Symbol的name
String parseSymbolName(Symbol symbol) {
  return symbol.toString().replaceAll(replaceSymbolRegExp, "");
}
