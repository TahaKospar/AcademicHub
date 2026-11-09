import 'dart:io';
import 'package:academichub/business_logic/tasks/task_details_cubit.dart';
import 'package:academichub/business_logic/tasks/task_details_state.dart';
import 'package:academichub/presentation/widgets/voice_paly.dart';
import 'package:academichub/presentation/widgets/voice_recorder_widget.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Taskdetailsscreen extends StatefulWidget {
  final String dayId;
  const Taskdetailsscreen({super.key, required this.dayId});

  @override
  State<Taskdetailsscreen> createState() => _TaskdetailsscreenState();
}

class _TaskdetailsscreenState extends State<Taskdetailsscreen> {
  TextEditingController answer = TextEditingController();
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  String? recordedFilePath;
  bool isAudioPlayingLocally = false;
  bool isSubmitting = false; // متغير للتحكم في اللودينج وقت الإرسال
  late AudioPlayer _localAudioPlayer;
  bool _isInitializedFromData = false;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<TaskDetailsCubit>().fetchUserTask(
        uid: uid,
        dayId: widget.dayId,
      );
    }
    _localAudioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _localAudioPlayer.dispose();
    answer.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> submitTask({required String taskType}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      isSubmitting = true; // بدء التحميل وإظهار اللودينج في الزرار
    });

    try {
      String? uploadedAudioUrl;

      if (taskType != "Writing") {
        if (recordedFilePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please record your answer first!")),
          );
          setState(() => isSubmitting = false);
          return;
        }

        final file = File(recordedFilePath!);
        final fileName =
            'task_${widget.dayId}_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await Supabase.instance.client.storage
            .from('task-answers')
            .upload(fileName, file);
        uploadedAudioUrl = Supabase.instance.client.storage
            .from('task-answers')
            .getPublicUrl(fileName);
      } else {
        if (!(formState.currentState?.validate() ?? false)) {
          setState(() => isSubmitting = false);
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .collection('UserTasks')
          .doc(widget.dayId)
          .update({
            if (taskType == "Writing") 'answerText': answer.text.trim(),
            if (taskType != "Writing") 'answerAudioUrl': uploadedAudioUrl ?? '',
            'instructorNote': note.text.trim(),
            'status': 'Pending',
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Task submitted successfully!",
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error submitting task: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit: $e")));
      setState(() {
        isSubmitting = false; // إيقاف اللودينج في حالة حدوث خطأ
      });
    }
  }

  Widget _buildModernSubmissionTracker(String status) {
    final colors = Theme.of(context).colorScheme;
    final currentStatus = status.toLowerCase();

    int activeStep = 0;
    if (currentStatus == 'pending') {
      activeStep = 1;
    } else if (currentStatus == 'done') {
      activeStep = 2;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.adaptiveColor(
            light: Colors.grey.shade200,
            dark: colors.outlineVariant,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.adaptiveColor(
              light: Colors.grey.shade100,
              dark: colors.shadow.withValues(alpha: 0.08),
            ),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _trackerStepItem(
            title: "To do",
            isDone: activeStep >= 0,
            isCurrent: activeStep == 0,
          ),
          _trackerConnector(isDone: activeStep >= 1),
          _trackerStepItem(
            title: "Pending",
            isDone: activeStep >= 1,
            isCurrent: activeStep == 1,
          ),
          _trackerConnector(isDone: activeStep >= 2),
          _trackerStepItem(
            title: "Done",
            isDone: activeStep >= 2,
            isCurrent: activeStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _trackerStepItem({
    required String title,
    required bool isDone,
    required bool isCurrent,
  }) {
    final colors = Theme.of(context).colorScheme;
    final stepColor = colors.adaptiveColor(
      light: Colors.blue,
      dark: colors.taskStatusColor(title),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? stepColor
                : colors.adaptiveColor(
                    light: Colors.grey.shade100,
                    dark: colors.surfaceContainerHighest,
                  ),
            border: Border.all(
              color: isCurrent || isDone
                  ? stepColor
                  : colors.adaptiveColor(
                      light: Colors.grey.shade300,
                      dark: colors.outlineVariant,
                    ),
              width: isCurrent ? 2 : 1,
            ),
          ),
          child: Center(
            child: isDone
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: colors.adaptiveColor(
                      light: Colors.white,
                      dark: colors.onPrimary,
                    ),
                  )
                : Text(
                    title[0],
                    style: TextStyle(
                      color: isCurrent
                          ? stepColor
                          : colors.adaptiveColor(
                              light: Colors.grey.shade500,
                              dark: colors.onSurfaceVariant,
                            ),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent || isDone ? FontWeight.bold : FontWeight.w500,
            color: isCurrent || isDone
                ? stepColor
                : colors.adaptiveColor(
                    light: Colors.grey.shade500,
                    dark: colors.onSurfaceVariant,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _trackerConnector({required bool isDone}) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        height: 2,
        color: isDone
            ? colors.adaptiveColor(light: Colors.blue, dark: colors.primary)
            : colors.adaptiveColor(
                light: Colors.grey.shade300,
                dark: colors.outlineVariant,
              ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.adaptiveColor(
        light: Colors.grey.shade50,
        dark: colors.surfaceDim,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.adaptiveColor(
          light: Colors.white,
          dark: colors.surface,
        ),
        foregroundColor: colors.adaptiveColor(
          light: Colors.black,
          dark: colors.onSurface,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Task details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Your learning activity",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: colors.adaptiveColor(
                      light: Colors.grey.shade600,
                      dark: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          if (state is TaskDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskDetailsError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: Colors.red,
                    dark: colors.error,
                  ),
                ),
              ),
            );
          }
          if (state is TaskDetailsLoaded) {
            final details = state.task;

            if (!_isInitializedFromData) {
              if (details.answerText != null &&
                  details.answerText!.isNotEmpty) {
                answer.text = details.answerText!;
              }
              if (details.instructorNote != null &&
                  details.instructorNote!.isNotEmpty) {
                note.text = details.instructorNote!;
              }
              _isInitializedFromData = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.adaptiveColor(
                        light: Colors.amber.shade100,
                        dark: colors
                            .taskStatusColor(details.status)
                            .withValues(alpha: 0.15),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${details.status} • ${details.type}",
                      style: TextStyle(
                        color: colors.taskStatusColor(details.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    details.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colors.adaptiveColor(
                        light: Colors.black87,
                        dark: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (details.type == "Listening") ...[
                    VoicePaly(isTask: true, audioUrl: details.audioUrl!),
                    const SizedBox(height: 16),
                  ],

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: colors.adaptiveColor(
                          light: Colors.grey.shade300,
                          dark: colors.outlineVariant,
                        ),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.adaptiveColor(
                                  light: Colors.grey.shade200,
                                  dark: colors.surfaceContainerHighest,
                                ),
                              ),
                              child: Icon(
                                Icons.menu_book_sharp,
                                color: colors.adaptiveColor(
                                  light: Colors.blue,
                                  dark: colors.primary,
                                ),
                              ),
                            ),
                            const Text(
                              "  Task Content",
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SelectableText.rich(
                          TextSpan(
                            children: details.textContent.split('\n').map((
                              line,
                            ) {
                              if (line.contains(':')) {
                                final colonIndex = line.indexOf(':');
                                final beforeColon = line
                                    .substring(0, colonIndex)
                                    .trim();
                                final afterColon = line.substring(
                                  colonIndex + 1,
                                );

                                bool isSpeakerName =
                                    beforeColon.length < 35 &&
                                    !beforeColon.contains('.');

                                if (isSpeakerName) {
                                  return TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "$beforeColon:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors.adaptiveColor(
                                            light: Colors.black87,
                                            dark: colors.onSurface,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "$afterColon\n",
                                        style: TextStyle(
                                          color: colors.adaptiveColor(
                                            light: Colors.grey.shade800,
                                            dark: colors.onSurface,
                                          ),
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }

                              return TextSpan(
                                text: "$line\n",
                                style: TextStyle(
                                  color: colors.adaptiveColor(
                                    light: Colors.grey.shade800,
                                    dark: colors.onSurface,
                                  ),
                                  height: 1.5,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Your response",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (details.type == "Writing") ...[
                          const Text(
                            "Text response",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: formState,
                            child: TextFormField(
                              controller: answer,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please write your task answer";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colors.adaptiveColor(
                                  light: Colors.grey.shade100,
                                  dark: colors.surfaceContainerHighest,
                                ),
                                hintText: "Write your answer here...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxLines: 5,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 10),
                          if (recordedFilePath == null) ...[
                            if (details.answerAudioUrl != null &&
                                details.answerAudioUrl!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.adaptiveColor(
                                    light: Colors.green.shade50,
                                    dark: colors.tertiaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colors.adaptiveColor(
                                      light: Colors.green.shade200,
                                      dark: colors.tertiary,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: colors.adaptiveColor(
                                            light: Colors.green,
                                            dark: colors.tertiary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            "Previous voice response submitted.",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    VoicePaly(
                                      isTask: true,
                                      audioUrl: details.answerAudioUrl!,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            VoiceRecorderWidget(
                              onRecordingComplete: (filePath) {
                                setState(() {
                                  recordedFilePath = filePath;
                                });
                              },
                            ),
                          ] else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.adaptiveColor(
                                  light: Colors.blue.shade50,
                                  dark: colors.primaryContainer,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.adaptiveColor(
                                    light: Colors.blue.shade200,
                                    dark: colors.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isAudioPlayingLocally
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      color: colors.adaptiveColor(
                                        light: Colors.blue,
                                        dark: colors.primary,
                                      ),
                                      size: 36,
                                    ),
                                    onPressed: () async {
                                      if (isAudioPlayingLocally) {
                                        await _localAudioPlayer.pause();
                                        setState(
                                          () => isAudioPlayingLocally = false,
                                        );
                                      } else {
                                        await _localAudioPlayer.play(
                                          DeviceFileSource(recordedFilePath!),
                                        );
                                        setState(
                                          () => isAudioPlayingLocally = true,
                                        );
                                        _localAudioPlayer.onPlayerComplete
                                            .listen((_) {
                                              if (mounted) {
                                                setState(
                                                  () => isAudioPlayingLocally =
                                                      false,
                                                );
                                              }
                                            });
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      "Voice note recorded successfully. Tap to listen.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: colors.adaptiveColor(
                                        light: Colors.red,
                                        dark: colors.error,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        recordedFilePath = null;
                                        isAudioPlayingLocally = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("    Note to instructor (optional)"),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: TextField(
                      controller: note,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText:
                            "Anything you'd like your instructor to know?",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // زر الإرسال مع تفعيل اللودينج المحلي
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        backgroundColor: colors.adaptiveColor(
                          light: Colors.blue,
                          dark: colors.primary,
                        ),
                        foregroundColor: colors.adaptiveColor(
                          light: Colors.white,
                          dark: colors.onPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isSubmitting
                          ? null // تعطيل الزر أثناء التحميل لمنع التكرار
                          : () {
                              final hasAudioAnswer =
                                  details.answerAudioUrl != null &&
                                  details.answerAudioUrl!.isNotEmpty;
                              if (hasAudioAnswer) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text("Update Task"),
                                      content: const Text(
                                        "You will overwrite the previous submission.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            submitTask(taskType: details.type);
                                          },
                                          child: const Text("Update"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                submitTask(taskType: details.type);
                              }
                            },
                      child: isSubmitting
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: colors.adaptiveColor(
                                  light: Colors.white,
                                  dark: colors.onPrimary,
                                ),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.send),
                                SizedBox(width: 8),
                                Text(
                                  "Submit Task",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: const Text(
                      "Submission tracking",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildModernSubmissionTracker(details.status),
                  const SizedBox(height: 25),
                ],
              ),
            );
          }
          return const Center(child: Text("Error loading data"));
        },
      ),
    );
  }
}
