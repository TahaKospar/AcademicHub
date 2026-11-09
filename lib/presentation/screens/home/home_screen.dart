import 'package:academichub/business_logic/tasks/task_details_cubit.dart';
import 'package:academichub/data/repository/tasks/task_details_repository.dart';
import 'package:academichub/presentation/screens/tasks/task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:academichub/business_logic/home/home_page_cubit.dart';
import 'package:academichub/data/model/home/home_page_model.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';

class Homescreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const Homescreen({super.key, this.onNavigate});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboard();
    });
  }

  void _fetchDashboard() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && mounted) {
      context.read<HomePageCubit>().fetchDashboardData(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          if (state is HomePageLoading || state is HomePageInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.adaptiveColor(
                  light: const Color(0xFF2563EB),
                  dark: colors.primary,
                ),
              ),
            );
          }

          if (state is HomePageError) {
            return _buildError(state.message);
          }

          if (state is HomePageSuccess) {
            return _buildDashboard(state.homePageModel);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(HomePageModel model) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      color: colors.adaptiveColor(
        light: const Color(0xFF2563EB),
        dark: colors.primary,
      ),
      onRefresh: () async => _fetchDashboard(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
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

                _buildSectionHeader(
                  'Quick Destinations',
                  'Explore AcademicHub',
                ),
                const SizedBox(height: 14),
                _buildQuickDestinations(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Header

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AcademicHub',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF0F172A),
                    dark: colors.onSurface,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'NORTHBRIDGE LANGUAGE ACADEMY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.7,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF64748B),
                    dark: colors.onSurfaceVariant,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.adaptiveColor(
              light: const Color(0xFFEFF6FF),
              dark: colors.primaryContainer,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.adaptiveColor(
                light: const Color(0xFF2563EB),
                dark: colors.onPrimaryContainer,
              ),
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  // Welcome

  Widget _buildWelcome(HomePageModel model) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colors.adaptiveColor(
              light: const Color(0xFFDBEAFE),
              dark: colors.primaryContainer,
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            model.userInitial,
            style: TextStyle(
              color: colors.adaptiveColor(
                light: const Color(0xFF2563EB),
                dark: colors.onPrimaryContainer,
              ),
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
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: const Color(0xFF64748B),
                    dark: colors.onSurfaceVariant,
                  ),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                model.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF0F172A),
                    dark: colors.onSurface,
                  ),
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
    final colors = Theme.of(context).colorScheme;
    final progress = model.overallProgress.clamp(0.0, 1.0).toDouble();

    const sectionOrder = [
      'Listening',
      'Reading',
      'Speaking',
      'Writing',
      'Pronunciation',
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colors.adaptiveColor(
                      light: const Color(0xFF0F172A),
                      dark: colors.onSurface,
                    ),
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: const Color(0xFF2563EB),
                    dark: colors.primary,
                  ),
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
                lineWidth: 8,
                percent: progress,
                animation: true,
                animationDuration: 900,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: colors.adaptiveColor(
                  light: const Color(0xFFEFF6FF),
                  dark: colors.primaryContainer,
                ),
                progressColor: colors.adaptiveColor(
                  light: const Color(0xFF2563EB),
                  dark: colors.primary,
                ),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: colors.adaptiveColor(
                          light: const Color(0xFF0F172A),
                          dark: colors.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      'Overall',
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.adaptiveColor(
                          light: const Color(0xFF64748B),
                          dark: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  children: sectionOrder.map((section) {
                    final value = model.sectionProgress[section] ?? 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _buildSectionProgress(section, value),
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
    final colors = Theme.of(context).colorScheme;
    final progress = value.clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF64748B),
                    dark: colors.onSurfaceVariant,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.adaptiveColor(
                  light: const Color(0xFF0F172A),
                  dark: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 6,
          percent: progress,
          padding: EdgeInsets.zero,
          backgroundColor: colors.adaptiveColor(
            light: const Color(0xFFEFF6FF),
            dark: colors.primaryContainer,
          ),
          progressColor: colors.adaptiveColor(
            light: const Color(0xFF2563EB),
            dark: colors.primary,
          ),
          barRadius: const Radius.circular(10),
          animation: true,
          animationDuration: 900,
        ),
      ],
    );
  }

  // Active Course

  Widget _buildActiveCourse(CourseModel? course) {
    final colors = Theme.of(context).colorScheme;

    if (course == null) {
      return _card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 30,
                color: colors.adaptiveColor(
                  light: const Color(0xFF64748B),
                  dark: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'No active course at the moment',
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: const Color(0xFF64748B),
                    dark: colors.onSurfaceVariant,
                  ),
                  fontSize: 13,
                ),
              ),
            ],
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
                  color: colors.adaptiveColor(
                    light: const Color(0xFFEFF6FF),
                    dark: colors.primaryContainer,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF2563EB),
                    dark: colors.onPrimaryContainer,
                  ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.adaptiveColor(
                          light: const Color(0xFF0F172A),
                          dark: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructor.isEmpty
                          ? 'Instructor not assigned'
                          : course.instructor,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.adaptiveColor(
                          light: const Color(0xFF64748B),
                          dark: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            color: colors.adaptiveColor(
              light: const Color(0xFFF1F5F9),
              dark: colors.outlineVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (course.schedule.trim().isNotEmpty)
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
          if (course.schedule.trim().isEmpty && course.details.trim().isEmpty)
            Text(
              'No additional course information yet.',
              style: TextStyle(
                color: colors.adaptiveColor(
                  light: const Color(0xFF64748B),
                  dark: colors.onSurfaceVariant,
                ),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _courseInfoRow(IconData icon, String title, String value) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: colors.adaptiveColor(
            light: const Color(0xFF2563EB),
            dark: colors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF0F172A),
                    dark: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: colors.adaptiveColor(
                    light: const Color(0xFF64748B),
                    dark: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // To-Do Tasks

  Widget _buildTasks(List<TaskSummaryModel> tasks) {
    final colors = Theme.of(context).colorScheme;
    final taskStatusColor = colors.adaptiveColor(
      light: const Color(0xFFF59E0B),
      dark: colors.taskStatusColor('To Do'),
    );

    if (tasks.isEmpty) {
      return Center(
        child: _card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Icon(
                  Icons.task_alt_rounded,
                  color: colors.adaptiveColor(
                    light: Colors.green,
                    dark: colors.tertiary,
                  ),
                  size: 30,
                ),
                SizedBox(height: 9),
                Text(
                  'You have no tasks to do',
                  style: TextStyle(
                    color: colors.adaptiveColor(
                      light: const Color(0xFF64748B),
                      dark: colors.onSurfaceVariant,
                    ),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      child: Column(
        children: tasks.take(3).map((task) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _card(
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: taskStatusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: taskStatusColor,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  TaskDetailsCubit(TaskDetailsRepository()),
                              child: Taskdetailsscreen(dayId: task.id),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.adaptiveColor(
                                light: const Color(0xFF0F172A),
                                dark: colors.onSurface,
                              ),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            task.time.isEmpty
                                ? task.type
                                : '${task.id} • ${task.type} • ${task.time}',
                            style: TextStyle(
                              color: colors.adaptiveColor(
                                light: const Color(0xFF64748B),
                                dark: colors.onSurfaceVariant,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: taskStatusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'To Do',
                      style: TextStyle(
                        color: taskStatusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Quick Destinations

  Widget _buildQuickDestinations() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onNavigate?.call(1);
            },
            child: _destinationItem(Icons.menu_book_rounded, 'Courses'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onNavigate!.call(2);
            },
            child: _destinationItem(
              Icons.chat_bubble_outline_rounded,
              'Messages',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onNavigate!.call(3);
            },
            child: _destinationItem(Icons.assignment_outlined, 'Tasks'),
          ),
        ),
      ],
    );
  }

  Widget _destinationItem(IconData icon, String title) {
    final colors = Theme.of(context).colorScheme;

    return _card(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
      child: Column(
        children: [
          Icon(
            icon,
            color: colors.adaptiveColor(
              light: const Color(0xFF2563EB),
              dark: colors.primary,
            ),
            size: 24,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.adaptiveColor(
                light: const Color(0xFF0F172A),
                dark: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header

  Widget _buildSectionHeader(String title, String subtitle) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: colors.adaptiveColor(
              light: const Color(0xFF0F172A),
              dark: colors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: colors.adaptiveColor(
              light: const Color(0xFF64748B),
              dark: colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // Card

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.adaptiveColor(
            light: const Color(0xFFF1F5F9),
            dark: colors.outlineVariant,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.adaptiveColor(
              light: const Color(0xFF0F172A).withValues(alpha: 0.025),
              dark: colors.shadow.withValues(alpha: 0.08),
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Error

  Widget _buildError(String message) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
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
      ),
    );
  }
}
