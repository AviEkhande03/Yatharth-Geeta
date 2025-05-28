class ResponseData {
  final int statusCode;
  final String message;
  final Map<String, dynamic> data;

  ResponseData(
      {required this.statusCode, required this.message, required this.data});
}
