import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_theme.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/interview_cards/presentation/screens/groups_screen.dart';

class InterviewCardsApp extends ConsumerWidget {
  const InterviewCardsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HireDeck AI',
      theme: AppTheme.lightTheme,
      home: switch (auth.status) {
        AuthStatus.loading => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        AuthStatus.signedOut => const SignInScreen(),
        AuthStatus.signedIn => const GroupsScreen(),
      },
    );
  }
}
