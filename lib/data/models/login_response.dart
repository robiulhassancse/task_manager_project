import 'package:task_manager/data/models/user_data.dart';

class LoginResponse {
  String? status;
  String? token;
  UserData? userData;

  LoginResponse({this.status, this.token, this.userData});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}


