import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/auth/presentation/view/auth_keys.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AuthKeys.landingPage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_rounded,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to EduTrack',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please select your role to continue',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                key: AuthKeys.loginButton,
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const NavigateToLoginRequested(isAdmin: false),
                  );
                },
                child: const Text('Login as Student'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: AuthKeys.registerButton,
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const NavigateToLoginRequested(isAdmin: true),
                  );
                },
                child: const Text('Login as Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
