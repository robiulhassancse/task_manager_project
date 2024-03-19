import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: 200,
          child: Image.asset(
                'assets/images/empty.png',
              ),
        ));
  }
}
