class ApiException implements Exception {
  int? code;
  String message;
  ApiException({required this.code, required this.message});
}
