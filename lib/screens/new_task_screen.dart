import 'package:flutter/material.dart';
import 'package:task_manager/data/models/count_by_staurs_wrapper.dart';
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

  @override
  void initState() {
    super.initState();
    _getAllTaskCountByStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: Padding(
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
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: const Text('Lorem ipsum is simply dummy'),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'It is a long a stabilished fact that a reader will be distracted by the readable contaent of a page when looking at its layout',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Date: 02/02/2020'),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Chip(
                                    label: Text(
                                      'New',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Icon(Icons.edit),
                                  ),
                                  TextButton(
                                    onPressed: () {},
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
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
}
