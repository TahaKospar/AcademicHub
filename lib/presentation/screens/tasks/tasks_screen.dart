import 'package:academichub/business_logic/tasks/task_details_cubit.dart';
import 'package:academichub/business_logic/tasks/tasks_cubit.dart';
import 'package:academichub/data/model/tassk/task_model.dart';
import 'package:academichub/data/repository/tasks/task_details_repository.dart';
import 'package:academichub/presentation/screens/tasks/task_details_screen.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class Tasksscreen extends StatefulWidget {
  const Tasksscreen({super.key});

  @override
  State<Tasksscreen> createState() => _TasksscreenState();
}

class _TasksscreenState extends State<Tasksscreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<TasksCubit>().fetchUserTasks(uid: uid);
    }
  }

  String _currentFilter = "All";

  Widget buildTaskIconContainer(String type) {
    final colors = Theme.of(context).colorScheme;
    IconData iconData;
    Color primaryColor;
    switch (type) {
      case "Listening":
        iconData = Icons.headphones_rounded;
        primaryColor = colors.adaptiveColor(
          light: Colors.blue,
          dark: colors.primary,
        );
      case "Speaking":
        iconData = Icons.mic;
        primaryColor = colors.adaptiveColor(
          light: Colors.amber,
          dark: colors.tertiary,
        );
      case "Reading":
        iconData = Icons.menu_book_rounded;
        primaryColor = colors.adaptiveColor(
          light: Colors.greenAccent,
          dark: colors.secondary,
        );
      case "Writing":
        iconData = Icons.edit;
        primaryColor = colors.adaptiveColor(
          light: Colors.deepPurpleAccent,
          dark: colors.primary,
        );
      case "Pronunciation":
        iconData = Icons.record_voice_over_outlined;
        primaryColor = colors.adaptiveColor(
          light: Colors.redAccent,
          dark: colors.error,
        );
      default:
        iconData = Icons.task;
        primaryColor = colors.adaptiveColor(
          light: Colors.red,
          dark: colors.error,
        );
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: primaryColor, size: 24),
    );
  }

  Widget buildTaskIconStatus(String status) {
    final colors = Theme.of(context).colorScheme;
    IconData iconData;
    switch (status) {
      case "Done":
        iconData = Icons.done_sharp;
      case "Pending":
        iconData = Icons.access_time_rounded;
      case "To Do":
      case "Required":
        iconData = Icons.pending_actions_rounded;
      default:
        iconData = Icons.multitrack_audio_rounded;
    }
    final statusColor = colors.taskStatusColor(status);

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(iconData, color: statusColor, size: 20),
          Text(status),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Task Planner"),
                const Text(
                  "Make room for your next milestone",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.adaptiveColor(
                  light: Colors.lightBlueAccent.shade100,
                  dark: colors.primaryContainer,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.filter_list_outlined,
                color: colors.adaptiveColor(
                  light: Colors.black,
                  dark: colors.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: colors.adaptiveColor(
                          light: Colors.black12,
                          dark: colors.outlineVariant,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<TasksCubit, TasksState>(
                          builder: (context, state) {
                            List tasksList = [];
                            if (state is TasksLoadedState) {
                              tasksList = state.tasks;
                            }
                            return TableCalendar(
                              focusedDay: DateTime.now(),
                              firstDay: DateTime.utc(2025, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              enabledDayPredicate: (day) {
                                if (day.weekday == DateTime.friday)
                                  return false;
                                return true;
                              },
                              eventLoader: (day) {
                                return tasksList.where((task) {
                                  return isSameDay(task.scheduledDate, day);
                                }).toList();
                              },
                              calendarBuilders: CalendarBuilders(
                                markerBuilder: (context, day, events) {
                                  if (events.isEmpty) return null;

                                  return Positioned(
                                    bottom: 1,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: events.map((event) {
                                        final task = event as TaskModel;

                                        final dotColor = colors.taskStatusColor(
                                          task.status,
                                        );

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5,
                                          ),
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: dotColor,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              calendarStyle:
                                  colors.brightness == Brightness.dark
                                  ? CalendarStyle(
                                      defaultTextStyle: TextStyle(
                                        color: colors.onSurface,
                                      ),
                                      weekendTextStyle: TextStyle(
                                        color: colors.onSurface,
                                      ),
                                      outsideTextStyle: TextStyle(
                                        color: colors.onSurfaceVariant,
                                      ),
                                      disabledTextStyle: TextStyle(
                                        color: colors.onSurfaceVariant,
                                      ),
                                      selectedTextStyle: TextStyle(
                                        color: colors.onPrimary,
                                      ),
                                      todayTextStyle: TextStyle(
                                        color: colors.onPrimaryContainer,
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: colors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      todayDecoration: BoxDecoration(
                                        color: colors.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const CalendarStyle(),
                              headerStyle: colors.brightness == Brightness.dark
                                  ? HeaderStyle(
                                      titleTextStyle: TextStyle(
                                        color: colors.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      leftChevronIcon: Icon(
                                        Icons.chevron_left,
                                        color: colors.onSurfaceVariant,
                                      ),
                                      rightChevronIcon: Icon(
                                        Icons.chevron_right,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    )
                                  : const HeaderStyle(),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "• ",
                                  style: TextStyle(
                                    color: colors.taskStatusColor("Done"),
                                    fontSize: 30,
                                  ),
                                ),
                                Text("Done"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "• ",
                                  style: TextStyle(
                                    color: colors.taskStatusColor("Pending"),
                                    fontSize: 30,
                                  ),
                                ),
                                Text("Pending"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "• ",
                                  style: TextStyle(
                                    color: colors.taskStatusColor("To Do"),
                                    fontSize: 30,
                                  ),
                                ),
                                Text("To Do"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentFilter == "All"
                                ? colors.adaptiveColor(
                                    light: Colors.blue.shade100,
                                    dark: colors.primaryContainer,
                                  )
                                : null,
                            foregroundColor: _currentFilter == "All"
                                ? (colors.brightness == Brightness.dark
                                      ? colors.onPrimaryContainer
                                      : null)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentFilter = "All";
                            });
                          },
                          child: const Text("All"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentFilter == "Pending"
                                ? colors.adaptiveColor(
                                    light: Colors.blue.shade100,
                                    dark: colors.primaryContainer,
                                  )
                                : null,
                            foregroundColor: _currentFilter == "Pending"
                                ? (colors.brightness == Brightness.dark
                                      ? colors.onPrimaryContainer
                                      : null)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentFilter = "Pending";
                            });
                          },
                          child: const Text("Pending"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentFilter == "Done"
                                ? colors.adaptiveColor(
                                    light: Colors.blue.shade100,
                                    dark: colors.primaryContainer,
                                  )
                                : null,
                            foregroundColor: _currentFilter == "Done"
                                ? (colors.brightness == Brightness.dark
                                      ? colors.onPrimaryContainer
                                      : null)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentFilter = "Done";
                            });
                          },
                          child: const Text("done"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ),
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksLoadingState) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TasksErrorState) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(state.errorMessage)),
                  );
                }
                if (state is TasksLoadedState) {
                  final filterTasks = state.tasks.where((task) {
                    if (_currentFilter == "All") return true;
                    return task.status.toLowerCase() ==
                        _currentFilter.toLowerCase();
                  }).toList();

                  if (filterTasks.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No Tasks found for this filter"),
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: filterTasks.length,
                    itemBuilder: (context, index) {
                      final task = filterTasks[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    TaskDetailsCubit(TaskDetailsRepository()),
                                child: Taskdetailsscreen(dayId: task.dayId),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: buildTaskIconContainer(task.type),
                            title: Text(task.dayId),
                            subtitle: Text('${task.type} '),
                            trailing: buildTaskIconStatus(task.status),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
