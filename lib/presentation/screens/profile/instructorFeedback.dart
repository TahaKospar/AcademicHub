import 'package:flutter/material.dart';

class Instructorfeedback extends StatelessWidget {
  const Instructorfeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instructor Feedback')),
      body: const Center(
        child: Text(
          'Instructor Feedback Screen',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
