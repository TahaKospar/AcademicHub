import 'package:flutter/material.dart';
// استيراد الشاشات الأساسية بتاعتك هنا
// import 'screens/home_screen.dart';
// import 'screens/tasks_screen.dart';
// import 'screens/courses_screen.dart';
// import 'screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final dynamic controller; // الـ Cubit أو الcontroller الخاص بك

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // الـ Index الحالي للتبويب المفتوح (يبدأ من 0 اللي هي الرئيسية مثلاً)
  int _selectedIndex = 0;

  // دالة التنقل بين التبويبات
  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // لستة الشاشات الأساسية في التطبيق مرتبة بنفس ترتيب الـ NavigationBar
    final List<Widget> pages = [
      const Center(
        child: Text('شاشة الرئيسية (Home)'),
      ), // استبدلها بـ HomeScreen
      const Center(
        child: Text('شاشة التاسكات (Tasks)'),
      ), // استبدلها بـ TasksScreen اللي هنشتغل عليها
      const Center(
        child: Text('شاشة الكورسات (Courses)'),
      ), // استبدلها بـ CoursesScreen
      const Center(
        child: Text('شاشة الحساب (Profile)'),
      ), // استبدلها بـ ProfileScreen
    ];

    return Directionality(
      textDirection: TextDirection.rtl, // عشان التطبيق يبقى عربي بالكامل
      child: Scaffold(
        // استخدام IndexedStack يحافظ على حالة كل شاشة وما يعيدش تحميلها لما تقلب
        body: IndexedStack(index: _selectedIndex, children: pages),

        // شريط التنقل السفلي الاحترافي
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _navigateTo,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_outlined),
              selectedIcon: Icon(Icons.task_rounded),
              label: 'التاسكات',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'الكورسات',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
