import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/validators.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/screens/login_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_button.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Sign up',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                    validator: Validators.validateName,
                  ),
                  SizedBox(height: 20),
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
                    text: 'Sign Up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an Account?  ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'LogIn',
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
