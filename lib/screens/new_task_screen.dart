
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/count_by_staurs_wrapper.dart';
import 'package:task_manager/data/models/task_item.dart';
import 'package:task_manager/data/models/task_list_wrapper.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utlity/urls.dart';
import 'package:task_manager/screens/add_new_task_screen.dart';
import 'package:task_manager/widgets/snack_bar_message.dart';

import '../widgets/profileAppBar.dart';
import '../widgets/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
   const NewTaskScreen({super.key});



  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getAllTaskCountByStatusInProgress = false;
  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();
  TaskListWrapper _newTaskListWrapper = TaskListWrapper();
  bool _getNewTaskListInProgress = false;
  bool _deleteTaskInProgress = false;
  bool _updatesTaskInProgress = false;


  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }

  void _getDataFromApis(){
    _getAllTaskCountByStatus();
    _getAllNewTaskList();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: RefreshIndicator(
        onRefresh: ()async{
          _getDataFromApis();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Visibility(
                visible: _getAllTaskCountByStatusInProgress == false,
                  replacement: const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  LinearProgressIndicator(),
                  ),
                  child: taskCounterSection),
              Expanded(
                child: Visibility(
                  visible: _getNewTaskListInProgress == false && _deleteTaskInProgress ==false && _updatesTaskInProgress== false,
                  replacement: const Center(child: CircularProgressIndicator(),),
                  child: ListView.builder(
                      itemCount: _newTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title:  Text(_newTaskListWrapper.taskList![index].title ?? ''),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text( _newTaskListWrapper.taskList![index].description ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   Text('Date: ${_newTaskListWrapper.taskList?[index].createdDate}'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                       Chip(
                                        label: Text(
                                          _newTaskListWrapper.taskList![index].status ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          _showUpdatesStateDialog(_newTaskListWrapper.taskList![index].sId!);
                                        },
                                        child: const Icon(Icons.edit),
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          _deleteTaskById(_newTaskListWrapper.taskList![index].sId!);
                                        },
                                        child: const Icon(
                                            Icons.delete_forever_outlined,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget get taskCounterSection {
    return SizedBox(
      height: 100,
      child: ListView.separated(
          itemCount: _countByStatusWrapper.listOfTaskByStatusData?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TaskCounterCard(
              title: _countByStatusWrapper.listOfTaskByStatusData![index].sId ?? '',
              amount: _countByStatusWrapper.listOfTaskByStatusData![index].sum ?? 0,
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(
              width: 8,
            );
          }),
    );
  }

  void _showUpdatesStateDialog(String id){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        title: Text('Select staus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('New'),trailing: Icon(Icons.check),),
            ListTile(title: Text('Completed'),onTap: (){
              _updateTaskById(id, 'Completed');
              Navigator.pop(context);
            },),
            ListTile(title: Text('Progress'),onTap: (){
              _updateTaskById(id, 'Progress');
              Navigator.pop(context);
            },),
            ListTile(title: Text('Cancelled'),onTap: (){
              _updateTaskById(id, 'Cancelled');
              Navigator.pop(context);
            },),

          ],
        ),
      );
    });
  }

  Future<void> _getAllTaskCountByStatus() async {
    _getAllTaskCountByStatusInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.taskCountByStatus);
    if (response.isSuccess) {
      _countByStatusWrapper =
          CountByStatusWrapper.fromJson(response.responseBody);
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});
    } else {
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ??
                'Get task count by status has been failed');
      }
    }
  }
  
  Future<void>_getAllNewTaskList() async{
    _getNewTaskListInProgress = true;
    setState(() {});
    
    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if(response.isSuccess){
      _newTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getNewTaskListInProgress =false;
      setState(() {});
    }else{
      _getNewTaskListInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get new task list has been failed');
      }
    }
  }
  Future<void> _deleteTaskById(String id) async{
    _deleteTaskInProgress = true;
    setState(() {});
    
    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));
    _deleteTaskInProgress = false;
    if(response.isSuccess){
      _getDataFromApis();
    }else{
      _deleteTaskInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Delete task has been failed');
      }
    }
    
  }
  
  Future<void> _updateTaskById(String id,String status) async{
    _updatesTaskInProgress = true;
    setState(() {});
    
    final response = await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _updatesTaskInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _getDataFromApis();
    }else{
      setState(() {});
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Update task status has been failed');
      }
    }
    
  }
}
