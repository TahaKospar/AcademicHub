import 'package:academichub/firebase_options.dart';
import 'package:academichub/business_logic/tasks/cubit/tasks_cubit.dart';
import 'package:academichub/data/repository/tasks/task_repository.dart';
import 'package:academichub/data/services/tasks/task_services.dart';
import 'package:academichub/presentation/screens/auth/auth_screen.dart';
import 'package:academichub/presentation/screens/home/main_screen.dart';
import 'package:academichub/presentation/widgets/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/screens/auth/splash_screen.dart';
import 'package:academichub/presentation/screens/auth/welcome_screen.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/courses/coursesScreen.dart';
import 'package:academichub/presentation/screens/home/home_screen.dart';
import 'package:academichub/presentation/screens/home/notificationsScreen.dart';
import 'package:academichub/presentation/screens/profile/accountSettingsScreen.dart';
import 'package:academichub/presentation/screens/profile/helpScreen.dart';
import 'package:academichub/presentation/screens/profile/profileScreen.dart';
import 'package:academichub/presentation/screens/tasks/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://tuthaqwdylyiiktedhmw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR1dGhhcXdkeWx5aWlrdGVkaG13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5NDkwNDgsImV4cCI6MjEwODUyNTA0OH0.QPFPavGJ29QFzqUnmk_JroaKnf7xRiat8uZ0DHJ2p6w',
  );
  runApp(AcademicHub());
}

class AcademicHub extends StatefulWidget {
  const AcademicHub({super.key});

  @override
  State<AcademicHub> createState() => _AcademicHubState();
}

class _AcademicHubState extends State<AcademicHub> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(TaskRepository(TaskServices())),
      child: MaterialApp(
        themeMode: ThemeMode.light,
        title: 'AcademicHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: splashScreen,
        onGenerateRoute: generateRoute,
        routes: {
          splashScreen: (_) => const Splashscreen(),
          authScreen: (_) => const Authscreen(),
          welcomeScreen: (_) => const Welcomescreen(),
          mainScreen: (_) => const MainScreen(),
          homeScreen: (_) => const Homescreen(),
          coursesScreen: (_) => const Coursesscreen(),
          chatScreen: (_) => const Chatscreen(),
          tasksScreen: (_) => const Tasksscreen(),
          profileScreen: (_) => const Profilescreen(),
          notificationsScreen: (_) => const Notificationsscreen(),
          accountSettingsScreen: (_) => const Accountsettingsscreen(),
          helpScreen: (_) => const Helpscreen(),
        },
      ),
    );
  }
}
