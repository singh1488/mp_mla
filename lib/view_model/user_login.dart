class LoginModel {
  String status;

  LoginModel(this.status);

  factory LoginModel.fromJson(dynamic json) {
    return LoginModel(
      json['status'] as String,

    );
  }

}