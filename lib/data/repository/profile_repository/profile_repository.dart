import 'package:academichub/data/model/profile/profile_model.dart';
import 'package:academichub/data/services/profile/profile_services.dart';

class ProfileRepository {
  final ProfileServices _profileServices;
  ProfileRepository({ProfileServices? profileServices})
    : _profileServices = profileServices ?? ProfileServices();

  Future<ProfileModel> fetchDashboardData(String userId) async {
    final results = await Future.wait([
      _profileServices.getUserProfile(userId),
      _profileServices.getUserTasksCount(userId),
      _profileServices.getActiveCourseCount(userId),
    ]);
    final userProfile = results[0] as Map<String, dynamic>;
    final tasksCount = results[1] as int;
    final coursesCount = results[2] as int;

    final userName = (userProfile['name'] ?? '').toString();
    final useruid = (userProfile['uid'] ?? '').toString();
    final createdAt = (userProfile['createdAt'] ?? '').toString();
    final academicCode = (userProfile['academicCode'] ?? '').toString();
    final userLevel = (userProfile['levelId'] ?? '').toString();
    final userInitial = _getIntials(userName);
    final isActive = userProfile['isActive'] ?? false;

    return ProfileModel(
      userName: userName.isEmpty ? 'student' : userName,
      userInitial: userInitial,
      tasksDone: tasksCount,
      coursesDone: coursesCount,
      createdAt: createdAt,
      userLevel: userLevel,
      userId: useruid,
      academicCode: academicCode,
      isActive: isActive,
    );
  }

  String _getIntials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'S';
  }
}
