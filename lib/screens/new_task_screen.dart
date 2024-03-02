import 'package:flutter/material.dart';
import 'package:task_manager/screens/add_new_task_screen.dart';

import '../widgets/profileAppBar.dart';
import '../widgets/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            taskCounterSection,
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
                                  const Chip(label: Text('New', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                    backgroundColor: Colors.blue,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {}, child: const Icon(Icons.edit),),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewTaskScreen(),),);
        },
        child: const Icon(Icons.add,size: 30,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
  Widget get taskCounterSection{
    return SizedBox(
      height: 100,
      child: ListView.separated(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return const TaskCounterCard(
              title: 'New',
              amount: 12,
            );
          }, separatorBuilder: (_,__){
        return const SizedBox(width: 8,);
      }),
    );
  }
}





