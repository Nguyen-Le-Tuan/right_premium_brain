import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:right_premium_brain/app_theme.dart';
import 'package:cron/cron.dart';
import 'package:right_premium_brain/database.dart';
import 'package:logging/logging.dart';
import 'package:right_premium_brain/auth.dart';
import 'package:right_premium_brain/auth_service.dart';
import 'package:right_premium_brain/authentication/forgot_password_page.dart';
import 'package:right_premium_brain/home_page.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Configure logging
  Logger.root.level = Level.ALL; // Set the desired logging level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('CronJob'); // Create a logger for the cron job
  final cron = Cron();
  cron.schedule(Schedule.parse('0 0 * * *'), () async {
    logger.info('Running daily task - adding average score');
    DatabaseService().addAverageScore();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>( // Changed type of User to User?
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null, // Added initialData with null value
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: Provider.of<AppState>(context).isNightModeOn
                ? ThemeMode.dark
                : ThemeMode.light,
            home: AnimatedSplashScreen(
              duration: 1000,
              splash: Image.asset('assets/brain-openmoji.png'),
              splashIconSize: 100,
              nextScreen: const AuthenticationWrapper(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.scale,
              backgroundColor: Colors.white,
            ),
            routes: <String, WidgetBuilder>{
              "/forgotPassword": (BuildContext context) => const ForgotPassword(),
            });
      }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();

    if (firebaseuser == true) {
      return const HomePage();
    } else {
      return const Authenticate();
    }
  }
}
