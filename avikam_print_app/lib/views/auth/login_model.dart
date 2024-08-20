class Login {
  Response response;

  Login({
    required this.response,
  });

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(response: Response.fromJson(json['Response']));
}

class Response {
  String statusCode;
  String message;
  String token;
  String loginType;

  Response({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.loginType,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
      statusCode: json["StatusCode"] ?? '',
      message: json["Message"] ?? '',
      token: json["Token"] ?? '',
      loginType: json["LoginType"] ?? '');
}
