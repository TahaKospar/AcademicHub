import 'package:academichub/data/model/home/home_page_model.dart';
import 'package:academichub/data/services/home/home_page_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageRepository {
  final HomePageServices _homeService;

  HomePageRepository({HomePageServices? homeService})
    : _homeService = homeService ?? HomePageServices();

  Future<HomePageModel> fetchDashboardData(String userId) async {
    final results = await Future.wait([
      _homeService.getUserProfile(userId),
      _homeService.getUserTasks(userId),
      _homeService.getActiveCourse(userId),
    ]);

    final userProfile = results[0] as Map<String, dynamic>;
    final rawTasks = results[1] as List<Map<String, dynamic>>;
    final rawCourse = results[2] as Map<String, dynamic>?;

    final userName = (userProfile['name'] ?? '').toString();
    final userInitial = _getInitials(userName);

    final sectionProgress = _calculateSectionProgress(rawTasks);
    final overallProgress = _calculateOverallProgress(rawTasks);

    CourseModel? activeCourse;

    if (rawCourse != null) {
      activeCourse = CourseModel(
        title: (rawCourse['title'] ?? '').toString(),
        instructor: (rawCourse['instructor'] ?? '').toString(),
        schedule: (rawCourse['schedule'] ?? '').toString(),
        progress: 0,
        details: (rawCourse['details'] ?? '').toString(),
      );
    }

    final todoTasks = rawTasks
        .where((task) => _normalizeStatus(task['status']) == 'Todo')
        .take(3)
        .map((task) {
          final dayId = (task['dayId'] ?? task['id'] ?? '').toString();

          return TaskSummaryModel(
            id: dayId,
            title: (task['title'] ?? dayId).toString(),
            type: (task['type'] ?? 'Task').toString(),
            time: _getTaskDate(userProfile, dayId),
            isCompleted: false,
          );
        })
        .toList();

    return HomePageModel(
      userName: userName.isEmpty ? 'Student' : userName,
      userInitial: userInitial,
      overallProgress: overallProgress,
      sectionProgress: sectionProgress,
      activeCourse: activeCourse,
      todoTasks: todoTasks,
    );
  }

  String _normalizeStatus(dynamic status) {
    final value = status?.toString().trim().toLowerCase() ?? '';

    if (value == 'to do' || value == 'todo') return 'Todo';
    if (value == 'pending') return 'Pending';
    if (value == 'done') return 'Done';

    return value;
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }

    return 'S';
  }

  Map<String, double> _calculateSectionProgress(
    List<Map<String, dynamic>> tasks,
  ) {
    final Map<String, List<bool>> sectionMap = {
      'Listening': [],
      'Reading': [],
      'Speaking': [],
      'Writing': [],
      'Pronunciation': [],
    };

    for (final task in tasks) {
      final type = task['type']?.toString();

      if (type != null && sectionMap.containsKey(type)) {
        sectionMap[type]!.add(_normalizeStatus(task['status']) == 'Done');
      }
    }

    final Map<String, double> result = {};

    sectionMap.forEach((section, statuses) {
      if (statuses.isEmpty) {
        result[section] = 0;
      } else {
        final completed = statuses.where((done) => done).length;
        result[section] = completed / statuses.length;
      }
    });

    return result;
  }

  double _calculateOverallProgress(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) return 0;

    final completed = tasks
        .where((task) => _normalizeStatus(task['status']) == 'Done')
        .length;

    return completed / tasks.length;
  }

  String _getTaskDate(Map<String, dynamic> userProfile, String dayId) {
    final createdAt = userProfile['createdAt'];

    if (createdAt == null) return dayId;

    DateTime startDate;

    if (createdAt is Timestamp) {
      startDate = createdAt.toDate();
    } else if (createdAt is DateTime) {
      startDate = createdAt;
    } else {
      return dayId;
    }
    final dayNumber = int.tryParse(dayId.replaceAll('day', ''));

    if (dayNumber == null || dayNumber < 1) return dayId;

    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);

    int currentDay = 1;

    while (date.weekday == DateTime.friday) {
      date = date.add(const Duration(days: 1));
    }

    while (currentDay < dayNumber) {
      date = date.add(const Duration(days: 1));

      if (date.weekday == DateTime.friday) continue;

      currentDay++;
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
