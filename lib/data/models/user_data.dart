class UserData {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  UserData({this.email, this.firstName, this.lastName, this.mobile, this.photo});



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['photo'] = photo;
    return data;
  }
  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }
  String get fullName{
    return '${firstName ?? ''} ${lastName ?? ''}';
  }
}