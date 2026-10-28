import 'package:academichub/presentation/screens/home/homeScreen.dart';
import 'package:academichub/presentation/screens/tasks/tasksScreen.dart';
import 'package:flutter/material.dart';
import '../courses/coursesScreen.dart';
import '../profile/profileScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // لستة الشاشات اللي هتظهر لما تدوس تحت
  final List<Widget> _screens = const [
    Homescreen(), // الرئيسية
    Tasksscreen(), // شاشة التاسكات بتاعتك
    Coursesscreen(), // الكورسات
    Profilescreen(), // البروفايل
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الـ body بيعرض الشاشة حسب الـ index الحالي
      body: _screens[_currentIndex],

      // ده بقى شريط التنقل اللي هيظهر تحت في الواجهة العادية خالص بدون تعقيد
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType
            .fixed, // ضروري عشان الأيقونات تظهر لو أكتر من 3
        selectedItemColor: Colors.blue, // لون الأيقونة النشطة
        unselectedItemColor: Colors.grey, // لون الأيقونات العادية
        onTap: (index) {
          setState(() {
            _currentIndex = index; // بيحدث الشاشة وينقل للتاب التانية
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'التاسكات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'الكورسات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
