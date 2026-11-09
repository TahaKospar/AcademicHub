import 'package:academichub/business_logic/profile/profile_cubit.dart';
import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/data/model/profile/profile_model.dart';
import 'package:academichub/presentation/screens/profile/accountSettingsScreen.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profilescreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const Profilescreen({super.key, this.onNavigate});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      context.read<ProfileCubit>().fetchDashboardData(userId);
    }
  }

  void _fetchDashboard() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && mounted) {
      context.read<ProfileCubit>().fetchDashboardData(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildHeader(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileError) {
              return _buildError(state.errorMessage);
            }
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              return _buildDashboard(state.profileModel);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(ProfileModel profileModel) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      color: colors.adaptiveColor(
        light: const Color(0xFF2563EB),
        dark: colors.primary,
      ),
      onRefresh: () async => _fetchDashboard(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(padding: EdgeInsets.all(15)),
            SliverList(
              delegate: SliverChildListDelegate([
                // _buildHeader(),
                _buildUserData(profileModel),
                SizedBox(height: 20),
                _buildCountDone(profileModel),
                SizedBox(height: 20),
                Text(
                  "Your Learning",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildLearning(profileModel),
                SizedBox(height: 20),

                _finishPage(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          "My Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Your academy identity"),
        trailing: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: colors.adaptiveColor(
              light: const Color.fromARGB(255, 223, 238, 249),
              dark: colors.primaryContainer,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: colors.adaptiveColor(
              light: const Color.fromARGB(255, 88, 166, 231),
              dark: colors.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserData(
    ProfileModel model,
    // String userInitial,
    // String name,
    // String userId,
    // userLevel,
    // String academicCode,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.adaptiveColor(
          light: const Color(0xFFF8FAFC),
          dark: colors.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colors.adaptiveColor(
                light: const Color.fromARGB(255, 0, 107, 189),
                dark: colors.primary,
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            alignment: Alignment.center,
            child: Text(
              "${model.userInitial}",
              style: TextStyle(
                color: colors.adaptiveColor(
                  light: Colors.white,
                  dark: colors.onPrimary,
                ),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            "${model.userName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),

          Text(
            "${model.academicCode}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: colors.adaptiveColor(
                light: const Color.fromARGB(255, 165, 214, 167),
                dark: colors.secondaryContainer,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${model.userLevel} • ${model.isActive}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: Colors.black,
                    dark: colors.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: colors.adaptiveColor(
                light: Colors.grey.shade300,
                dark: colors.outlineVariant,
              ),
              thickness: 2,
              height: 20,
            ),
          ),
          Text("Northbridge Language Academy"),
          // Text("Student ID: ${model.userId}"),
        ],
      ),
    );
  }

  Widget _buildCountDone(ProfileModel model) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            width: 50,
            height: 90,
            color: colors.adaptiveColor(
              light: const Color.fromARGB(255, 223, 238, 249),
              dark: colors.surfaceContainerHighest,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${model.coursesDone}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colors.adaptiveColor(
                      light: Colors.blue.shade700,
                      dark: colors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text("Finished courses"),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Expanded(
          child: Container(
            width: 50,
            height: 90,
            color: colors.adaptiveColor(
              light: const Color.fromARGB(255, 223, 238, 249),
              dark: colors.surfaceContainerHighest,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${model.tasksDone}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colors.adaptiveColor(
                      light: Colors.blue.shade700,
                      dark: colors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text("Tasks done"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLearning(ProfileModel model) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            widget.onNavigate?.call(1);
          },
          child: Center(
            child: _listTile(
              "My Courses",
              "${model.coursesDone} done courses",
              Icon(
                Icons.menu_book,
                color: colors.adaptiveColor(
                  light: const Color.fromARGB(255, 88, 166, 231),
                  dark: colors.primary,
                ),
              ),
              Icon(Icons.chevron_right),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(instructorFeedback);
          },
          child: Center(
            child: _listTile(
              "Instructor feedback",
              "View your task reviews and replies",
              Icon(
                Icons.chat_outlined,
                color: colors.adaptiveColor(
                  light: const Color.fromARGB(255, 88, 166, 231),
                  dark: colors.primary,
                ),
              ),
              Icon(Icons.chevron_right),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Account & Support",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(accountSettingsScreen);
          },
          child: Center(
            child: _listTile(
              "Account settings",
              "Personal details, security & Preference",
              Icon(
                Icons.settings_outlined,
                color: colors.adaptiveColor(
                  light: const Color.fromARGB(255, 88, 166, 231),
                  dark: colors.primary,
                ),
              ),
              Icon(Icons.chevron_right),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(notificationsScreen);
          },
          child: Center(
            child: _listTile(
              "Notification",
              "Class updates, deadlines & messages",
              Icon(
                Icons.notifications_none,
                color: colors.adaptiveColor(
                  light: const Color.fromARGB(255, 88, 166, 231),
                  dark: colors.primary,
                ),
              ),
              Icon(Icons.chevron_right),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(helpScreen);
          },
          child: Center(
            child: _listTile(
              "Help & Support",
              "Wer're here when you need us",
              Icon(
                Icons.chat_outlined,
                color: colors.adaptiveColor(
                  light: const Color.fromARGB(255, 88, 166, 231),
                  dark: colors.primary,
                ),
              ),
              Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listTile(String title, String subTitle, Icon leading, Icon trailing) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.adaptiveColor(
        light: const Color(0xFFF8FAFC),
        dark: colors.surface,
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          subTitle,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.adaptiveColor(
              light: const Color.fromARGB(255, 223, 238, 249),
              dark: colors.primaryContainer,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: leading,
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _finishPage() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 15),

        InkWell(
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(authScreen, (route) => false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: colors.adaptiveColor(
                  light: Colors.red,
                  dark: colors.error,
                ),
              ),
              Text(
                "Log Out",
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: Colors.red,
                    dark: colors.error,
                  ),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Text(
          "AcademicHub • Version 1.0.0",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        Text(
          "Your Academy's Digital Ecosystem",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildError(String message) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colors.adaptiveColor(
              light: Colors.redAccent,
              dark: colors.error,
            ),
            size: 45,
          ),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: colors.adaptiveColor(
                light: const Color(0xFF0F172A),
                dark: colors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.adaptiveColor(
                light: const Color(0xFF64748B),
                dark: colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _fetchDashboard,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
