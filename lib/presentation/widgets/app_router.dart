import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:academichub/business_logic/tasks/cubit/task_details_cubit.dart';
import 'package:academichub/business_logic/tasks/cubit/tasks_cubit.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/data/repository/auth_repository.dart';
import 'package:academichub/data/repository/task_details_repository.dart';
import 'package:academichub/data/repository/task_repository.dart';
import 'package:academichub/data/services/authService.dart';
import 'package:academichub/data/services/task_services.dart';
import 'package:academichub/presentation/screens/auth/auth_screen.dart';
import 'package:academichub/presentation/screens/auth/splash_screen.dart';
import 'package:academichub/presentation/screens/auth/welcome_screen.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/courses/coursesScreen.dart';
import 'package:academichub/presentation/screens/home/home_screen.dart';
import 'package:academichub/presentation/screens/home/main_screen.dart';
import 'package:academichub/presentation/screens/home/notificationsScreen.dart';
import 'package:academichub/presentation/screens/profile/accountSettingsScreen.dart';
import 'package:academichub/presentation/screens/profile/helpScreen.dart';
import 'package:academichub/presentation/screens/profile/profileScreen.dart';
import 'package:academichub/presentation/screens/tasks/task_details_screen.dart';
import 'package:academichub/presentation/screens/tasks/tasks_screen.dart';
import 'package:academichub/presentation/widgets/login_widget.dart';
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
    case tasksScreen:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TasksCubit(TaskRepository(TaskServices())),
          child: const Tasksscreen(),
        ),
      );

    case taskDetailsScreen:
      final dayId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TaskDetailsCubit(TaskDetailsRepository()),
          child: Taskdetailsscreen(dayId: dayId),
        ),
      );
    case loginWidget:
      return MaterialPageRoute(builder: (context) => LoginWidget());
    case homeScreen:
      return MaterialPageRoute(builder: (context) => Homescreen());
    case welcomeScreen:
      return MaterialPageRoute(builder: (context) => Welcomescreen());
    case coursesScreen:
      return MaterialPageRoute(builder: (context) => Coursesscreen());
    case chatScreen:
      return MaterialPageRoute(builder: (context) => Chatscreen());
    case profileScreen:
      return MaterialPageRoute(builder: (context) => Profilescreen());
    case notificationsScreen:
      return MaterialPageRoute(builder: (context) => Notificationsscreen());
    case accountSettingsScreen:
      return MaterialPageRoute(builder: (context) => Accountsettingsscreen());
    case helpScreen:
      return MaterialPageRoute(builder: (context) => Helpscreen());
  }
}
