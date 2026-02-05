import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: TestIds
                    .splashLogo, // Reusing simple concept or make landing logo key
                child: Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Semantics(
                label: TestIds.landingTitle,

                container: true,
                child: Text(
                  'Welcome to EduTrack',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
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
              Semantics(
                label: TestIds.landingStudentBtn,
                identifier: TestIds.landingStudentBtn,

                container: true,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const NavigateToLoginRequested(isAdmin: false),
                    );
                  },
                  child: const Text('Login as Student'),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: TestIds.landingAdminBtn,
                identifier: TestIds.landingAdminBtn,

                container: true,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const NavigateToLoginRequested(isAdmin: true),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    'Login as Admin',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
