// 查询字符串解析
import 'dart:convert';

class QueryStringParser {
  static final SEP = '&';
  static final EQ = '=';
  static final QUERY_TRING_SEP = '?';

  //  Parses the given query string into a Map.
  static Map<String, dynamic> parse(String query,
      {bool filterNoneValue = true, bool needDecode = false, Encoding encoding = utf8}) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map<String, dynamic>();

    if (query == null || query.trim().length == 0) {
      return Map.from({});
    }
    if (needDecode) {
      query = Uri.decodeQueryComponent(query, encoding: encoding);
    }
    // Get rid off the beginning ? in query strings.
    if (query.startsWith(QueryStringParser.QUERY_TRING_SEP)) {
      query = query.substring(1);
    }

    // A custom decoder.
//    decode(String s) => Uri.decodeQueryComponent(s.replaceAll('+', ' '),encoding: encoding);

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      final value = match.group(2);
      if (value?.trim().length == 0 && filterNoneValue) {
        continue;
      }
      final key = match.group(1);
      var item = result[key];
      if (item != null) {
        // if value exist ,converter to List
        if (!(item is List)) {
          item = [item];
        }
        item.add(value);
      } else {
        item = value;
      }
      result[key as String] = item;
    }

    return result;
  }

  /// if [queryParams] params is null or empty return null
  static String? stringify(Map queryParams, {bool filterNoneValue = true, Encoding encoding = utf8}) {
    if (queryParams == null || queryParams.isEmpty) {
      return null;
    }
    StringBuffer queryString = StringBuffer();
    queryParams.forEach((key, val) {
      _writeStringify(queryString, Uri.encodeQueryComponent(key, encoding: encoding), val, filterNoneValue, encoding);
    });

    return queryString.toString().substring(1, queryString.length);
  }

  static void _writeStringify(StringBuffer queryString, String key, val, bool filterNoneValue, Encoding encoding) {
    if (val == null && filterNoneValue) {
      return;
    }
    if (val is String) {
      if (val.trim().length == 0) {
        return;
      }
    }
    if (val is List) {
      val.forEach((item) {
        _writeStringify(queryString, key, item, filterNoneValue, encoding);
      });
    } else {
      queryString.write(QueryStringParser.SEP);
      if (val is String) {
        queryString.write("$key${QueryStringParser.EQ}${Uri.encodeQueryComponent(val, encoding: encoding)}");
      } else {
        queryString.write("$key${QueryStringParser.EQ}$val");
      }
    }
  }
}
