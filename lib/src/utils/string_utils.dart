class StringUtils {
  static bool hasText(String? str) {
    if (str == null) {
      return false;
    }
    return str.trim().length > 0;
  }
}
