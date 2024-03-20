
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_data.dart';
class AuthController{
  static String? accessToken;
  static UserData?userData;

  static Future<void>saveUserData(UserData userData)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userData',jsonEncode(userData.toJson()));
    AuthController.userData = userData;
  }
  static Future<UserData?>getUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? result = sharedPreferences.getString('userData');
    if(result == null){
      return null;
    }
    final user= UserData.fromJson(jsonDecode(result));
    AuthController.userData = user;
    return user;
  }
  static Future<void>saveUserToken(String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
    accessToken = token;
  }
  static Future<String?> getUserToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }
  static Future<bool> isUserLogin() async{
    final result = await getUserToken();
    accessToken = result;
    bool loginState = result != null;
    if(loginState){
      await getUserData();
    }
    return loginState;
  }
  static Future<void> clearUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<void> emailVerificationCheck(Email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('EmailVarification', Email);
  }

  static Future<void>OtpVericication(OTP) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('OtpVerification', OTP);
  }

  static Future<String> ReadUserData(key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? mydata = await sharedPreferences.getString(key);
    return mydata!;
  }
}