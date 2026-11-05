import 'package:academichub/data/model/home/home_page_model.dart';
import 'package:academichub/data/services/home/home_page_services.dart';

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

    final userName = (userProfile['name'] ?? 'King').toString();
    final userInitial = _getInitials(userName);

    final sectionProgress = _calculateSectionProgress(rawTasks);

    final overallProgress = _calculateOverallProgress(sectionProgress);

    CourseModel? activeCourse;

    if (rawCourse != null) {
      activeCourse = CourseModel(
        title: (rawCourse['title'] ?? '').toString(),
        instructor: (rawCourse['instructor'] ?? '').toString(),
        schedule: (rawCourse['schedule'] ?? '').toString(),
        progress: (rawCourse['progress'] as num?)?.toDouble() ?? 0.0,
        details: (rawCourse['details'] ?? '').toString(),
      );
    }

    final todoTasks = rawTasks
        .where((task) => task['status'] == 'Todo')
        .take(3)
        .map(
          (task) => TaskSummaryModel(
            id: (task['id'] ?? '').toString(),
            title: (task['title'] ?? '').toString(),
            type: (task['type'] ?? 'Task').toString(),
            time: (task['time'] ?? '').toString(),
            isCompleted: task['status'] == 'Done',
          ),
        )
        .toList();

    return HomePageModel(
      userName: userName,
      userInitial: userInitial,
      overallProgress: overallProgress,
      sectionProgress: sectionProgress,
      activeCourse: activeCourse,
      todoTasks: todoTasks,
    );
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

    return 'K';
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
      final isDone = task['status'] == 'Done';

      if (type != null && sectionMap.containsKey(type)) {
        sectionMap[type]!.add(isDone);
      }
    }


    final Map<String, double> result = {};

    sectionMap.forEach((section, tasksStatus) {
      if (tasksStatus.isEmpty) {
        result[section] = 0.0;
      } else {
        final doneCount = tasksStatus.where((done) => done).length;
        result[section] = doneCount / tasksStatus.length;
      }
    });

    return result;
  }

  double _calculateOverallProgress(Map<String, double> sectionProgress) {
    if (sectionProgress.isEmpty) return 0.0;

    final total = sectionProgress.values.reduce((a, b) => a + b);

    return total / sectionProgress.length;
  }
}
