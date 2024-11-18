class Utils {
  static String processDisplayValue(dynamic value) {
    if (value is List<String>) {
      return value.join(', ');
    } else {
      return value.toString();
    }
  }
}