import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/data/repository/auth_repository.dart';
import 'package:academichub/data/services/authService.dart';
import 'package:academichub/presentation/screens/auth/authScreen.dart';
import 'package:academichub/presentation/screens/auth/splashScreen.dart';
import 'package:academichub/presentation/screens/auth/welcomeScreen.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/courses/coursesScreen.dart';
import 'package:academichub/presentation/screens/home/homeScreen.dart';
import 'package:academichub/presentation/screens/home/mainScreen.dart';
import 'package:academichub/presentation/screens/home/notificationsScreen.dart';
import 'package:academichub/presentation/screens/profile/accountSettingsScreen.dart';
import 'package:academichub/presentation/screens/profile/profileScreen.dart';
import 'package:academichub/presentation/screens/tasks/taskDetailsScreen.dart';
import 'package:academichub/presentation/screens/tasks/tasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  AppRouter() {}
}

Route? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return MaterialPageRoute(builder: (context) => Splashscreen());
    case authScreen:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AuthCubit(AuthRepository(AuthServices())),
          child: Builder(builder: (context) => const Authscreen()),
        ),
      );
    case mainScreen:
      return MaterialPageRoute(builder: (context) => MainScreen());
    case homeScreen:
      return MaterialPageRoute(builder: (context) => Homescreen());
    case welcomeScreen:
      return MaterialPageRoute(builder: (context) => Welcomescreen());
    case coursesScreen:
      return MaterialPageRoute(builder: (context) => Coursesscreen());
    case chatScreen:
      return MaterialPageRoute(builder: (context) => Chatscreen());
    case tasksScreen:
      return MaterialPageRoute(builder: (context) => Tasksscreen());
    case taskDetailsScreen:
      return MaterialPageRoute(builder: (context) => Taskdetailsscreen());
    case profileScreen:
      return MaterialPageRoute(builder: (context) => Profilescreen());
    case notificationsScreen:
      return MaterialPageRoute(builder: (context) => Notificationsscreen());
    case accountSettingsScreen:
      return MaterialPageRoute(builder: (context) => Accountsettingsscreen());
    case helpScreen:
      return MaterialPageRoute(builder: (context) => Homescreen());
  }
}
