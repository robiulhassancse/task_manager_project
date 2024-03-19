import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_wrapper.dart';


import '../data/services/network_caller.dart';
import '../data/utlity/urls.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/profileAppBar.dart';
import '../widgets/snack_bar_message.dart';


class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getAllProgressTaskListInProgress=false;
  TaskListWrapper _progressTaskListWrapper = TaskListWrapper();
  bool _deleteProgressTaskInProgress=false;

  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }

  void _getDataFromApis() {
    _getAllProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: ()async{
            _getDataFromApis();
          },
          child: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: _getAllProgressTaskListInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator(),),
                  child: Visibility(
                    visible: _progressTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                        itemCount: _progressTaskListWrapper.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              title:  Text(_progressTaskListWrapper.taskList![index].title ?? ''),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      _progressTaskListWrapper.taskList![index].description ?? '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                     Text('Date: ${_progressTaskListWrapper.taskList![index].createdDate ?? ''}'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Chip(label: Text('Progress', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),),
                                          backgroundColor: Colors.purple,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            _showUpdatesStateDialog(_progressTaskListWrapper.taskList![index].sId!);
                                          }, icon: const Icon(Icons.edit),),
                                        Visibility(
                                          visible: _deleteProgressTaskInProgress == false,
                                          replacement: const CircularProgressIndicator(),
                                          child: IconButton(onPressed: () {
                                            _deleteTaskById(_progressTaskListWrapper.taskList![index].sId!);
                                          },
                                            icon: const Icon(Icons.delete_forever_outlined,
                                                color: Colors.red),),
                                        ),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void>_getAllProgressTaskList() async{
    _getAllProgressTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.progressTaskList);
    if(response.isSuccess){
      _progressTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllProgressTaskListInProgress =false;
      setState(() {});
    }else{
      _getAllProgressTaskListInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get Progress task list has been failed');
      }
    }
  }

  void _showUpdatesStateDialog(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('New'),
                  trailing: _isCurrentStatus('New') ?const Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('New')){
                      return;
                    }
                    _updateTaskById(id, 'New');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Completed'),
                  trailing: _isCurrentStatus('Completed') ?const Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Completed')){
                      return;
                    }
                    _updateTaskById(id, 'Completed');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Progress'),
                  trailing: _isCurrentStatus('Progress') ?const Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Progress')){
                      return;
                    }
                    _updateTaskById(id, 'Progress');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Cancelled'),
                  trailing: _isCurrentStatus('Cancelled') ?const Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Cancelled')){
                      return;
                    }
                    _updateTaskById(id, 'Cancelled');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
  // bool _isCurrentStatus(String status) {
  //   return _progressTaskListWrapper.status== status;
  // }

  bool _isCurrentStatus(String status) {
    for (final task in _progressTaskListWrapper.taskList!) {
      if (task.status == status) {
        return true;
      }
    }
    return false;
  }


  Future<void> _updateTaskById(String id,String status) async{
    _getAllProgressTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _getAllProgressTaskListInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _getAllProgressTaskListInProgress =false;
      setState(() {});
      _getDataFromApis();
    }else{
      setState(() {});
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Update task status has been failed');
      }
    }

  }
  Future<void>_getAllNewTaskList() async{
    _getAllProgressTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if(response.isSuccess){
      _progressTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllProgressTaskListInProgress =false;
      setState(() {});
    }else{
      _getAllProgressTaskListInProgress = false;
      setState(() {});
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get new task list has been failed');
      }
    }
  }
  Future<void> _deleteTaskById(String id) async {
    _deleteProgressTaskInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));
    _deleteProgressTaskInProgress = false;
    if (response.isSuccess) {
      _getDataFromApis();
    } else {
      _deleteProgressTaskInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Delete task has been failed');
      }
    }
  }
}





