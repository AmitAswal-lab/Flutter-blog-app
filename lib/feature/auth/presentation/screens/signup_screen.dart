import 'package:bloc_app_clean_solidp_bloc/core/common/widgets/loader.dart';
import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/show_snackbar.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/validators.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/screens/login_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_button.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackbar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
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
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthSignup(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          }
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
