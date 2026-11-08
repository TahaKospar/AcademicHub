import 'package:academichub/business_logic/home/home_page_cubit.dart';
import 'package:academichub/presentation/screens/chat/chatScreen.dart';
import 'package:academichub/presentation/screens/home/home_screen.dart';
import 'package:academichub/presentation/screens/tasks/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../courses/coursesScreen.dart';
import '../profile/profileScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late HomePageCubit _homePageCubit;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      Homescreen(
        onNavigate: (index) {
          changeTab(index);
        },
      ),
      const Coursesscreen(),
      const Chatscreen(),
      const Tasksscreen(),
      Profilescreen(
        onNavigate: (index) {
          changeTab(index);
        },
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homePageCubit = context.read<HomePageCubit>();
  }

  void changeTab(int index) {
    if (index < 0 || index >= _screens.length) return;

    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: _homePageCubit,
              child: _screens[index],
            );
          },
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final navigator = _navigatorKeys[_currentIndex].currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(
            _screens.length,
            (index) => _buildNavigator(index),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == _currentIndex) {
              _navigatorKeys[index].currentState?.popUntil(
                (route) => route.isFirst,
              );
              return;
            }

            changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              activeIcon: Icon(Icons.menu_book_sharp),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined),
              activeIcon: Icon(Icons.task),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
