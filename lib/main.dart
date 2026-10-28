import 'package:academichub/business_logic/tasks/cubit/tasks_cubit.dart';
import 'package:academichub/firebase_options.dart';
import 'package:academichub/presentation/screens/auth/authScreen.dart';
import 'package:academichub/presentation/screens/home/mainScreen.dart';
import 'package:academichub/presentation/widgets/app_shell.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/screens/auth/splashScreen.dart';
import 'package:academichub/presentation/screens/auth/welcomeScreen.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/courses/coursesScreen.dart';
import 'package:academichub/presentation/screens/home/homeScreen.dart';
import 'package:academichub/presentation/screens/home/notificationsScreen.dart';
import 'package:academichub/presentation/screens/profile/accountSettingsScreen.dart';
import 'package:academichub/presentation/screens/profile/helpScreen.dart';
import 'package:academichub/presentation/screens/profile/profileScreen.dart';
import 'package:academichub/presentation/screens/tasks/taskDetailsScreen.dart';
import 'package:academichub/presentation/screens/tasks/tasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return MultiBlocProvider(
      providers: [BlocProvider<TasksCubit>(create: (context) => TasksCubit())],
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
          taskDetailsScreen: (_) => const Taskdetailsscreen(),
          accountSettingsScreen: (_) => const Accountsettingsscreen(),
          helpScreen: (_) => const Helpscreen(),
        },
      ),
    );
  }
}
