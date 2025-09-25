import 'package:bloc_app_clean_solidp_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:bloc_app_clean_solidp_bloc/core/theme/app_theme.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/screens/login_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/screens/blog_screen.dart';
import 'package:bloc_app_clean_solidp_bloc/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggin());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blog App',
      theme: AppTheme.darkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isloggedIn) {
          if (isloggedIn) {
            return const BlogScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
