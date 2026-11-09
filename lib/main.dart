import 'package:academichub/business_logic/profile/profile_cubit.dart';
import 'package:academichub/business_logic/theme/theme_cubit.dart';
import 'package:academichub/presentation/screens/profile/instructorFeedback.dart';
import 'package:academichub/data/repository/profile_repository/profile_repository.dart';
import 'package:academichub/firebase_options.dart';
import 'package:academichub/business_logic/home/home_page_cubit.dart';
import 'package:academichub/business_logic/tasks/tasks_cubit.dart';
import 'package:academichub/data/repository/home/home_page_repository.dart';
import 'package:academichub/data/repository/tasks/task_repository.dart';
import 'package:academichub/data/services/tasks/task_services.dart';
import 'package:academichub/presentation/widgets/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/screens/auth/splash_screen.dart';
import 'package:academichub/presentation/screens/auth/welcome_screen.dart';
import 'package:academichub/presentation/screens/auth/auth_screen.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/courses/coursesScreen.dart';
import 'package:academichub/presentation/screens/home/home_screen.dart';
import 'package:academichub/presentation/screens/home/notificationsScreen.dart';
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
    // ignore: deprecated_member_use
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR1dGhhcXdkeWx5aWlrdGVkaG13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5NDkwNDgsImV4cCI6MjEwODUyNTA0OH0.QPFPavGJ29QFzqUnmk_JroaKnf7xRiat8uZ0DHJ2p6w',
  );

  runApp(const AcademicHub());
}

class AcademicHub extends StatelessWidget {
  const AcademicHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksCubit>(
          create: (_) => TasksCubit(TaskRepository(TaskServices())),
        ),
        BlocProvider<HomePageCubit>(
          create: (_) => HomePageCubit(HomePageRepository()),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository()),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final darkColorScheme =
              ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ).copyWith(
                primary: const Color(0xFF7CB7FF),
                onPrimary: const Color(0xFF101827),
                primaryContainer: const Color(0xFF233B59),
                onPrimaryContainer: const Color(0xFFD8E9FC),
                secondary: const Color(0xFFFFC36B),
                onSecondary: const Color(0xFF30230F),
                secondaryContainer: const Color(0xFF493820),
                onSecondaryContainer: const Color(0xFFFFE1B0),
                tertiary: const Color(0xFF75D69A),
                onTertiary: const Color(0xFF10281A),
                tertiaryContainer: const Color(0xFF214432),
                onTertiaryContainer: const Color(0xFFC5F4D6),
                error: const Color(0xFFFF7B82),
                onError: const Color(0xFF301719),
                errorContainer: const Color(0xFF542A31),
                onErrorContainer: const Color(0xFFFFDADD),
                surface: const Color(0xFF182235),
                onSurface: const Color(0xFFE8EEF7),
                onSurfaceVariant: const Color(0xFFAAB7C8),
                surfaceDim: const Color(0xFF101827),
                surfaceBright: const Color(0xFF26354B),
                surfaceContainerLowest: const Color(0xFF141D2C),
                surfaceContainerLow: const Color(0xFF182235),
                surfaceContainer: const Color(0xFF1C283B),
                surfaceContainerHigh: const Color(0xFF202D42),
                surfaceContainerHighest: const Color(0xFF202D42),
                outline: const Color(0xFF34445A),
                outlineVariant: const Color(0xFF34445A),
                inverseSurface: const Color(0xFFE8EEF7),
                onInverseSurface: const Color(0xFF182235),
              );

          return MaterialApp(
            themeMode: themeMode,
            title: 'AcademicHub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              cardColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),

            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              scaffoldBackgroundColor: const Color(0xFF101827),
              cardColor: const Color(0xFF182235),
              dividerColor: darkColorScheme.outlineVariant,
              appBarTheme: AppBarTheme(
                backgroundColor: darkColorScheme.surface,
                foregroundColor: darkColorScheme.onSurface,
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: darkColorScheme.surfaceContainerHighest,
                hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: darkColorScheme.surface,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: darkColorScheme.surface,
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: darkColorScheme.surfaceContainerHighest,
                contentTextStyle: TextStyle(color: darkColorScheme.onSurface),
              ),
            ),
            initialRoute: splashScreen,
            onGenerateRoute: generateRoute,
            routes: {
              splashScreen: (_) => const Splashscreen(),
              authScreen: (_) => const Authscreen(),
              welcomeScreen: (_) => const Welcomescreen(),
              homeScreen: (_) => const Homescreen(),
              coursesScreen: (_) => const Coursesscreen(),
              chatScreen: (_) => const Chatscreen(),
              tasksScreen: (_) => const Tasksscreen(),
              profileScreen: (_) => const Profilescreen(),
              notificationsScreen: (_) => const Notificationsscreen(),
              instructorFeedback: (_) => const Instructorfeedback(),
              // accountSettingsScreen: (_) => const AccountSettingsScreen(),
              helpScreen: (_) => const Helpscreen(),
            },
          );
        },
      ),
    );
  }
}
