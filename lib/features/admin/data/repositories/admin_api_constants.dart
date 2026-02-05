class AdminApiConstants {
  static const String baseUrl =
      'https://studentcrudtest-production.up.railway.app';
  static const String students = '$baseUrl/api/students';

  static String studentDetail(String id) => '$students/$id';
}
