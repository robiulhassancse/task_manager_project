import 'package:flutter/material.dart';

import '../widgets/profileAppBar.dart';
import '../widgets/task_counter_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                                  const Chip(label: Text('Complete', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                    backgroundColor: Colors.green,
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
    );
  }
}





