import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';

class LoginPage extends StatefulWidget {
  final bool isAdmin;

  const LoginPage({super.key, this.isAdmin = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigation is handled by Bloc -> AuthNavigation -> Dashboard
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Semantics(
                label: TestIds.loginError,
                child: Text(state.message),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Welcome to EduTrack',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isAdmin
                      ? 'Sign in to access admin dashboard'
                      : 'Sign in to continue your education portal',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 48),
                Semantics(
                  // label: TestIds.studentIdInput,
                  identifier: TestIds.studentIdInput,

                  container: true,
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: widget.isAdmin ? 'Admin ID' : 'Student ID',
                      hintText: widget.isAdmin ? 'e.g. ADM001' : 'e.g. STU1001',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  identifier: TestIds.passwordInput,

                  // label: TestIds.passwordInput,
                  container: true,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: '••••••',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Semantics(
                      label: TestIds.loginButton,
                      identifier: TestIds.loginButton,

                      container: true,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  LoginRequested(
                                    studentId: _idController.text,
                                    password: _passwordController.text,
                                    isAdmin: widget.isAdmin,
                                  ),
                                );
                              },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Login'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
