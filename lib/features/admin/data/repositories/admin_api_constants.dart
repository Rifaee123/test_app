class AdminApiConstants {
  static const String baseUrl = 'http://192.168.29.238:8081';
  static const String students = '$baseUrl/api/students';

  static String studentDetail(String id) => '$students/$id';
}
