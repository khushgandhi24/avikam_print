class ScanResponse {
  SResponse response;

  ScanResponse({
    required this.response,
  });

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      ScanResponse(response: SResponse.fromJson(json["Response"]));
}

class SResponse {
  String status;
  int respCode;
  String response;

  SResponse({
    required this.status,
    required this.respCode,
    required this.response,
  });

  factory SResponse.fromJson(Map<String, dynamic> json) => SResponse(
      status: json["status"],
      respCode: json["Resp_Code"],
      response: json["response"]);
}
