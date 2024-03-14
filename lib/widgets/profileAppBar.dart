
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/screens/auth/sign_in_screen.dart';
import 'package:task_manager/screens/update_profile_screen.dart';

import '../controllers/auth_controller.dart';

PreferredSizeWidget get profileAppBar {
  return AppBar(
    backgroundColor: Colors.green,
    title: GestureDetector(
      onTap: () {
        Navigator.push(
            TaskManager.navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => const UpdateProfileScreen()));
      },
      child: Row(
        children: [
          const CircleAvatar(),
          const SizedBox(
            width: 16,
          ),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userData?.fullName ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AuthController.userData?.email ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                await AuthController.clearUserData();

                Navigator.pushAndRemoveUntil(
                    TaskManager.navigatorKey.currentState!.context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()), (
                    route) => false);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
    ),
  );
}
