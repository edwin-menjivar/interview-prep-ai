import 'package:flutter/material.dart';

class InterviewCardDetailScreen extends StatelessWidget {
  const InterviewCardDetailScreen({super.key});

  static const routeName = '/card';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Use CardDetailScreen from cards flow.')),
    );
  }
}
