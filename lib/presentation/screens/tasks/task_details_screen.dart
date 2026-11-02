import 'package:academichub/business_logic/tasks/cubit/task_details_cubit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Taskdetailsscreen extends StatefulWidget {
  final String dayId;
  const Taskdetailsscreen({super.key, required this.dayId});

  @override
  State<Taskdetailsscreen> createState() => _TaskdetailsscreenState();
}

class _TaskdetailsscreenState extends State<Taskdetailsscreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackRate = 1.0;

  TextEditingController answer = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

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

    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.more_horiz, color: Colors.blue),
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
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is TaskDetailsLoaded) {
            final details = state.task;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${details.status} • ${details.type}",
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "A memorable journey",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    details.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (details.type == "Listening") ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.headphones_rounded,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Listen to Audio",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                            ),
                            child: Slider(
                              min: 0,
                              max: duration.inSeconds > 0
                                  ? duration.inSeconds.toDouble().toDouble()
                                  : 1.0,
                              value: position.inSeconds.toDouble().clamp(
                                0.0,
                                duration.inSeconds.toDouble(),
                              ),
                              onChanged: (value) async {
                                final pos = Duration(seconds: value.toInt());
                                await _audioPlayer.seek(pos);
                                await _audioPlayer.resume();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatTime(position),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  _formatTime(duration),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.replay_5_rounded,
                                  size: 28,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  final newPos =
                                      position - const Duration(seconds: 5);
                                  await _audioPlayer.seek(
                                    newPos < Duration.zero
                                        ? Duration.zero
                                        : newPos,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              FloatingActionButton(
                                elevation: 0,
                                backgroundColor: Colors.blue,
                                mini: true,
                                onPressed: () async {
                                  if (isPlaying) {
                                    await _audioPlayer.pause();
                                  } else {
                                    await _audioPlayer.play(
                                      UrlSource("${details.audioUrl}"),
                                    );
                                  }
                                },
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(
                                  Icons.forward_5_rounded,
                                  size: 28,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  final newPos =
                                      position + const Duration(seconds: 5);
                                  if (newPos < duration) {
                                    await _audioPlayer.seek(newPos);
                                  }
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Speed: ",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ToggleButtons(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 28,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                isSelected: [
                                  playbackRate == 0.5,
                                  playbackRate == 0.75,
                                  playbackRate == 1.0,
                                  playbackRate == 1.5,
                                  playbackRate == 2.0,
                                ],
                                onPressed: (index) async {
                                  double speed = 1.0;
                                  if (index == 0) speed = 0.5;
                                  if (index == 1) speed = 0.75;
                                  if (index == 2) speed = 1.0;
                                  if (index == 3) speed = 1.5;
                                  if (index == 4) speed = 2.0;
                                  setState(() {
                                    playbackRate = speed;
                                  });
                                  await _audioPlayer.setPlaybackRate(
                                    playbackRate,
                                  );
                                },
                                children: const [
                                  Text("0.5x", style: TextStyle(fontSize: 11)),
                                  Text("0.75x", style: TextStyle(fontSize: 11)),
                                  Text("1x", style: TextStyle(fontSize: 11)),
                                  Text("1.5x", style: TextStyle(fontSize: 11)),
                                  Text("2x", style: TextStyle(fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: Icon(
                                Icons.menu_book_sharp,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "  Task Content",
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        SelectableText(
                          details.textContent,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Your response",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (details.type == "Writing") ...[
                          Text(
                            "   Text response",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "     Write your answer here",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(10),
                            child: Form(
                              key: formState,
                              child: TextFormField(
                                controller: answer,
                                enabled: true,
                                validator: (value) {
                                  return "Please Write Your Task";
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: "Write your answer here...  ",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),

                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),

                                maxLines: 5,
                              ),
                            ),
                          ),
                        ],

                        if (details.type != "Writing") ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Voice note",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text("Record Your answer"),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(15),
                                      width: 40,

                                      color: Colors.grey[100],
                                      child: Text("Ready"),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: ListTile(
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[700],
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.mic_none_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "Tap to record",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text("No recording saved yet"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.error_outline_sharp, size: 30),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Speak clearly and include the same details as the text response",
                                        softWrap: true,

                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
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
