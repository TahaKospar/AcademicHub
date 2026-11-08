// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileModel {
  String? userInitial;
  String? userName;
  String? userId;
  String? userLevel;
  String? createdAt;
  int?   coursesDone;
  int?   tasksDone;
  String? academicCode;
  bool? isActive;

  ProfileModel({
    this.userId,
    this.userName,
    this.userInitial,
    this.userLevel,
    this.createdAt,
    this.coursesDone,
    this.tasksDone,
    this.academicCode,
    this.isActive,
  });
}
