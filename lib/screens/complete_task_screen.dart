import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_wrapper.dart';

import '../data/services/network_caller.dart';
import '../data/utlity/urls.dart';
import '../widgets/profileAppBar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_counter_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});



  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _getAllCompletedTaskListInProgress = false;
  TaskListWrapper _completedTaskListWrapper = TaskListWrapper();
  bool _getNewCompletedTaskListInProgress = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _getAllCompletedTaskList();
  // }

  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }

  void _getDataFromApis() {
    _getAllCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Visibility(
                visible: _getAllCompletedTaskListInProgress == false,
                replacement: const Center(child: CircularProgressIndicator(),),
                child: ListView.builder(
                    itemCount: _completedTaskListWrapper.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title:  Text(_completedTaskListWrapper.taskList![index].title ?? ''),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                          _completedTaskListWrapper.taskList![index].description ?? '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                 Text('Date: ${_completedTaskListWrapper.taskList![index].title ?? ''}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Chip(label: Text('Complete', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),),
                                      backgroundColor: Colors.green,
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        _showUpdatesStateDialog(_completedTaskListWrapper.taskList![index].sId!);
                                      }, child: const Icon(Icons.edit),),
                                    TextButton(onPressed: () {},
                                      child: const Icon(Icons.delete_forever_outlined,
                                          color: Colors.red),),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void>_getAllCompletedTaskList() async{
    _getAllCompletedTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.completedTaskList);
    if(response.isSuccess){
      _completedTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllCompletedTaskListInProgress =false;
      setState(() {});
    }else{
      _getAllCompletedTaskListInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get completed task list has been failed');
      }
    }
  }

  void _showUpdatesStateDialog(String id){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        title: const Text('Select staus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('New'),trailing: Icon(Icons.check),),
            ListTile(title: const Text('Completed'),onTap: (){
              _updateTaskById(id, 'Completed');
              Navigator.pop(context);
            },),
            ListTile(title: const Text('Progress'),onTap: (){
              _updateTaskById(id, 'Progress');
              Navigator.pop(context);
            },),
            ListTile(title: const Text('Cancelled'),onTap: (){
              _updateTaskById(id, 'Cancelled');
              Navigator.pop(context);
            },),

          ],
        ),
      );
    });
  }
  Future<void> _updateTaskById(String id,String status) async{
    _getAllCompletedTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _getAllCompletedTaskListInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _getAllCompletedTaskListInProgress =false;
      setState(() {});
      // _getDataFromApis();
    }else{
      setState(() {});
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Update task status has been failed');
      }
    }

  }
  Future<void>_getAllNewTaskList() async{
    _getNewCompletedTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if(response.isSuccess){
      _completedTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getNewCompletedTaskListInProgress =false;
      setState(() {});
    }else{
      _getNewCompletedTaskListInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get new task list has been failed');
      }
    }
  }
}





