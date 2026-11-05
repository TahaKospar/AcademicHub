import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:academichub/business_logic/home/home_page_cubit.dart';
import 'package:academichub/data/model/home/home_page_model.dart';

const Color primaryBlue = Color(0xFF2563EB);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color darkText = Color(0xFF0F172A);
const Color secondaryText = Color(0xFF64748B);

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null && mounted) {
        context.read<HomePageCubit>().fetchDashboardData(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomePageCubit, HomePageState>(
          builder: (context, state) {
            if (state is HomePageLoading || state is HomePageInitial) {
              return const Center(
                child: CircularProgressIndicator(color: primaryBlue),
              );
            }

            if (state is HomePageError) {
              return _buildError(state.message);
            }

            if (state is HomePageSuccess) {
              return _buildDashboard(state.homePageModel);
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildDashboard(HomePageModel model) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(),
              const SizedBox(height: 28),

              _buildWelcome(model),
              const SizedBox(height: 24),

              _buildProgressCard(model),
              const SizedBox(height: 24),

              _buildSectionHeader('Active Courses', 'Your current course'),
              const SizedBox(height: 14),

              _buildActiveCourse(model.activeCourse),
              const SizedBox(height: 24),

              _buildSectionHeader('To-Do Tasks', 'Tasks waiting for you'),
              const SizedBox(height: 14),

              _buildTasks(model.todoTasks),
              const SizedBox(height: 24),

              _buildSectionHeader('Quick Destinations', 'Explore AcademicHub'),
              const SizedBox(height: 14),

              _buildQuickDestinations(),
            ]),
          ),
        ),
      ],
    );
  }

  // Header

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'AcademicHub',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'NORTHBRIDGE LANGUAGE ACADEMY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.7,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: primaryBlue,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  // Welcome

  Widget _buildWelcome(HomePageModel model) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            model.userInitial,
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(color: secondaryText, fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                model.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Progress

  Widget _buildProgressCard(HomePageModel model) {
    final progress = model.overallProgress.clamp(0.0, 1.0);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircularPercentIndicator(
                radius: 48,
                lineWidth: 9,
                percent: progress,
                animation: true,
                animationDuration: 900,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: const Color(0xFFEFF6FF),
                progressColor: primaryBlue,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const Text(
                      'Overall',
                      style: TextStyle(fontSize: 10, color: secondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  children: model.sectionProgress.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: _buildSectionProgress(entry.key, entry.value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionProgress(String title, double value) {
    final progress = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 6,
          percent: progress,
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFFEFF6FF),
          progressColor: primaryBlue,
          barRadius: const Radius.circular(10),
          animation: true,
          animationDuration: 800,
        ),
      ],
    );
  }

  // Active Course

  Widget _buildActiveCourse(CourseModel? course) {
    if (course == null) {
      return _card(
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              'No active course at the moment',
              style: TextStyle(color: secondaryText),
            ),
          ),
        ),
      );
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: primaryBlue,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructor,
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: secondaryText,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          _courseInfoRow(
            Icons.calendar_month_rounded,
            'Meeting Schedule',
            course.schedule,
          ),

          if (course.details.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _courseInfoRow(
              Icons.sticky_note_2_outlined,
              'Course Notes',
              course.details,
            ),
          ],
        ],
      ),
    );
  }

  Widget _courseInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: primaryBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tasks

  Widget _buildTasks(List<TaskSummaryModel> tasks) {
    if (tasks.isEmpty) {
      return _card(
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              'You have no pending tasks',
              style: TextStyle(color: secondaryText),
            ),
          ),
        ),
      );
    }

    return Column(
      children: tasks.take(2).map((task) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _card(
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFFF59E0B),
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${task.type} • ${task.time}',
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: secondaryText,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Quick Destinations

  Widget _buildQuickDestinations() {
    return Row(
      children: [
        Expanded(
          child: _destinationItem(Icons.calendar_month_rounded, 'Calendar'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _destinationItem(
            Icons.chat_bubble_outline_rounded,
            'Messages',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _destinationItem(Icons.assignment_outlined, 'Tasks')),
      ],
    );
  }

  Widget _destinationItem(IconData icon, String title) {
    return _card(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
      child: Column(
        children: [
          Icon(icon, color: primaryBlue, size: 24),
          const SizedBox(height: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  // Section Header

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: secondaryText),
        ),
      ],
    );
  }

  // Card

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Bottom Navigation

  Widget _buildBottomNavigation() {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.calendar_month_rounded, 'Calendar'),
      (Icons.assignment_outlined, 'Tasks'),
      (Icons.chat_bubble_outline_rounded, 'Chat'),
      (Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].$1,
                        size: 22,
                        color: isSelected ? primaryBlue : secondaryText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? primaryBlue : secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Error

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 45,
            ),
            const SizedBox(height: 12),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: secondaryText),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                final userId = FirebaseAuth.instance.currentUser?.uid;

                if (userId != null) {
                  context.read<HomePageCubit>().fetchDashboardData(userId);
                }
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
