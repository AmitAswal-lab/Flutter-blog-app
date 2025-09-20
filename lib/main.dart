import 'package:bloc_app_clean_solidp_bloc/core/theme/app_theme.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/screens/login_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => serverLocator<AuthBloc>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blog App',
      theme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
