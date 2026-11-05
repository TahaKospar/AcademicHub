// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoicePaly extends StatefulWidget {
  bool isTask;
  String audioUrl;
  VoicePaly({super.key, required this.isTask, required this.audioUrl});

  @override
  State<VoicePaly> createState() => _VoicePalyState();
}

class _VoicePalyState extends State<VoicePaly> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
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
    return widget.isTask
        ? Container(
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
                        ? duration.inSeconds.toDouble()
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        final newPos = position - const Duration(seconds: 5);
                        await _audioPlayer.seek(
                          newPos < Duration.zero ? Duration.zero : newPos,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      mini: true,
                      onPressed: () async {
                        if (widget.audioUrl == null ||
                            widget.audioUrl!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "No audio file available for this task",
                              ),
                            ),
                          );
                          return;
                        }
                        if (isPlaying) {
                          await _audioPlayer.pause();
                        } else {
                          await _audioPlayer.play(UrlSource(widget.audioUrl!));
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
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
                        final newPos = position + const Duration(seconds: 5);
                        if (newPos < duration) {
                          await _audioPlayer.seek(newPos);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
