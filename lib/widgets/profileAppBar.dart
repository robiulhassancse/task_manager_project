
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/screens/update_profile_screen.dart';

PreferredSizeWidget get profileAppBar {
  return AppBar(
    backgroundColor: Colors.green,
    title: GestureDetector(
      onTap: (){
        Navigator.push(TaskManager.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>const UpdateProfileScreen()));
      },
      child:  Row(
        children: [
          const CircleAvatar(),
          const SizedBox(
            width: 16,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Robiul Hassan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'robiul@gmail.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout,color: Colors.white,size: 30,))
        ],
      ),
    ),
  );
}
