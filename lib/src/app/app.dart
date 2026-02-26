import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../features/interview_cards/presentation/interview_card_detail_screen.dart';
import '../features/interview_cards/presentation/interview_cards_home_screen.dart';

class InterviewCardsApp extends StatelessWidget {
  const InterviewCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interview Cards Pro',
      theme: AppTheme.lightTheme,
      initialRoute: InterviewCardsHomeScreen.routeName,
      routes: {
        InterviewCardsHomeScreen.routeName: (_) =>
            const InterviewCardsHomeScreen(),
        InterviewCardDetailScreen.routeName: (_) =>
            const InterviewCardDetailScreen(),
      },
    );
  }
}
