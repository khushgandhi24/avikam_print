class ScanResponse {
  String response;

  ScanResponse({
    required this.response,
  });

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      ScanResponse(response: json["Response"] ?? '');
}
