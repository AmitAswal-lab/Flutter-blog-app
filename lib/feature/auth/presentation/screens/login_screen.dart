import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/validators.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/screens/signup_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_button.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'LogIn',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 20),
                  AuthField(
                    hintText: 'Password',
                    isObscure: true,
                    controller: passwordController,
                    validator: Validators.validatePassword,
                  ),
                  SizedBox(height: 30),
                  AuthButton(
                    text: 'LogIn',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SignupScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'I don\'t have an Account ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: AppPallete.gradient3,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
