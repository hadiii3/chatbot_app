import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/core/injection/injection.dart';
import 'package:chatbot_app/core/theme/app_theme.dart';
import 'package:chatbot_app/features/auth/cubit/auth_cubit.dart';
import 'package:chatbot_app/features/auth/cubit/auth_state.dart';
import 'package:chatbot_app/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:chatbot_app/features/auth/repositories/auth_repository.dart';
import 'package:chatbot_app/features/shared/presentation/home_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark status bar icons globally
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return BlocProvider(
      create: (_) => AuthCubit(getIt<AuthRepository>()),
      child: MaterialApp(
        title: 'Galala Uni',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (ctx, state) {
            if (state is AuthAuthenticated) return const HomeShell();
            return const OnboardingScreen();
          },
        ),
        routes: {
          '/home': (_) => const HomeShell(),
          '/onboarding': (_) => const OnboardingScreen(),
        },
      ),
    );
  }
}
