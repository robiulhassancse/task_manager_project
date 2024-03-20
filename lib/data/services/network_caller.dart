import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/data/models/response_object.dart';
import 'package:task_manager/screens/auth/sign_in_screen.dart';

class NetworkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    try {
      log(url);
      log(AuthController.accessToken.toString());
      final Response response = await get(Uri.parse(url),
          headers: {'token': AuthController.accessToken ?? ''});

      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true,
            statusCode: response.statusCode,
            responseBody: decodedResponse,
            errorMessage: '');
      } else if (response.statusCode == 401) {
        _moveToSignIn();
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            errorMessage: '');
      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            errorMessage: '');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(
      String url, Map<String, dynamic> body,{bool fromSignIn =false}) async {
    try {
      log(url);
      log(body.toString());

      final Response response = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            'Content-type': 'application/json',
            'token': AuthController.accessToken ?? ''
          });

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true,
            statusCode: response.statusCode,
            responseBody: decodedResponse,
            errorMessage: '');
      } else if (response.statusCode == 401) {
        if(fromSignIn){
          return ResponseObject(
              isSuccess: false,
              statusCode: response.statusCode,
              responseBody: '',
              errorMessage: 'Email/password is incorrect. Try agian');
        }else {
          _moveToSignIn();
          return ResponseObject(
              isSuccess: false,
              statusCode: response.statusCode,
              responseBody: '',
              errorMessage: '');
        }

      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            errorMessage: '');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }

  static void _moveToSignIn() async{
   await AuthController.clearUserData();

    Navigator.pushAndRemoveUntil(
        TaskManager.navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }
  // Future<bool> VerificationRequest(Email) async{
  //   var Url = Uri.parse('${BaseURL}/RecoverVerifyEmail/${Email}');
  // }


}
