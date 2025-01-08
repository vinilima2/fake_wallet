class DateUtil {
  static String now() {
    return "${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString()}";
  }
}
