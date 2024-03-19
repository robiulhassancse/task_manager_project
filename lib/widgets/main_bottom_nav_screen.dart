import 'package:flutter/material.dart';
import 'package:task_manager/screens/cancle_task_screen.dart';
import 'package:task_manager/screens/complete_task_screen.dart';
import 'package:task_manager/screens/new_task_screen.dart';
import 'package:task_manager/screens/progress_task_screen.dart';

class MainBottomNavScren extends StatefulWidget {
  const MainBottomNavScren({super.key});

  @override
  State<MainBottomNavScren> createState() => _MainBottomNavScrenState();
}

class _MainBottomNavScrenState extends State<MainBottomNavScren> {

   int _currentSelectIndex=0;
   final List<Widget> _screen=[
      const NewTaskScreen(),
     const ProgressTaskScreen(),
     const CompleteTaskScreen(),
     const CancleTaskScreen(),
   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentSelectIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index){
          _currentSelectIndex = index;
          if(mounted){
            setState(() {});
          }
        },
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),label: 'New Task'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pending),label: 'Progress'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all),label: 'Complete'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel),label: 'Cancle'
          ),
        ],
      ),
    );
  }
}
