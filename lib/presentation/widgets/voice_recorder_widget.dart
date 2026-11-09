import 'dart:async';
import 'package:academichub/data/services/voices/voice_recorder_controller.dart';
import 'package:flutter/material.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String filePath) onRecordingComplete;
  final VoidCallback? onRecordingStarted;
  final VoidCallback? onCancelled;

  const VoiceRecorderWidget({
    super.key,
    required this.onRecordingComplete,
    this.onRecordingStarted,
    this.onCancelled,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final VoiceRecorderController _recorderController = VoiceRecorderController();

  Timer? _timer;
  int _recordDuration = 0;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordDuration++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    bool isRecording = _recorderController.isRecording;

    if (isRecording) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: colors.adaptiveColor(
                light: const Color(0x1F000000),
                dark: colors.shadow.withValues(alpha: 0.12),
              ),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border.all(
            color: colors.adaptiveColor(
              light: const Color(0x4DFF0000),
              dark: colors.error.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                _stopTimer();
                await _recorderController.stopRecording();
                setState(() {});
                if (widget.onCancelled != null) {
                  widget.onCancelled!();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: colors.adaptiveColor(
                    light: Colors.grey,
                    dark: colors.onSurfaceVariant,
                  ),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.fiber_manual_record,
              color: colors.adaptiveColor(
                light: Colors.red,
                dark: colors.error,
              ),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDuration(_recordDuration),
              style: TextStyle(
                color: colors.adaptiveColor(
                  light: Colors.red,
                  dark: colors.error,
                ),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            // زرار الـ Pause / Resume
            IconButton(
              icon: Icon(
                _recorderController.isPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                color: colors.adaptiveColor(
                  light: Colors.orange,
                  dark: colors.tertiary,
                ),
                size: 26,
              ),
              onPressed: () async {
                if (_recorderController.isPaused) {
                  await _recorderController.resumeRecording();
                  _startTimer();
                } else {
                  await _recorderController.pauseRecording();
                  _stopTimer();
                }
                setState(() {});
              },
            ),
            const SizedBox(width: 8),
            // زرار الإرسال
            InkWell(
              onTap: () async {
                _stopTimer();
                final path = await _recorderController.stopRecording();
                setState(() {});
                if (path != null) {
                  widget.onRecordingComplete(path);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.adaptiveColor(
                    light: Colors.blue,
                    dark: colors.primary,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: colors.adaptiveColor(
                    light: Colors.white,
                    dark: colors.onPrimary,
                  ),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // شكل الكارت في وضع الاستعداد
    return Container(
      padding: const EdgeInsets.all(16),
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
              light: const Color(0x0A000000),
              dark: colors.shadow.withValues(alpha: 0.08),
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Voice note",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.adaptiveColor(
                        light: Colors.black87,
                        dark: colors.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Record Your answer",
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.adaptiveColor(
                        light: Colors.grey,
                        dark: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.adaptiveColor(
                    light: Colors.grey.shade100,
                    dark: colors.surfaceContainerHighest,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Ready",
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.adaptiveColor(
                      light: Colors.grey,
                      dark: colors.onSurfaceVariant,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.adaptiveColor(
                light: Colors.grey.shade50,
                dark: colors.surfaceContainerLow,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.adaptiveColor(
                  light: Colors.grey.shade200,
                  dark: colors.outlineVariant,
                ),
              ),
            ),
            child: InkWell(
              onTap: () async {
                await _recorderController.startRecording();
                setState(() {
                  _recordDuration = 0;
                });
                _startTimer();

                // 🔥 إبلاغ الشاشة الرئيسية فوراً أن التسجيل بدا عشان ينزل تحت في الـ BottomBar
                if (widget.onRecordingStarted != null) {
                  widget.onRecordingStarted!();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colors.adaptiveColor(
                        light: Colors.blue,
                        dark: colors.primary,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic,
                      color: colors.adaptiveColor(
                        light: Colors.white,
                        dark: colors.onPrimary,
                      ),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tap to record",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.adaptiveColor(
                            light: Colors.black87,
                            dark: colors.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "No recording saved yet",
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.adaptiveColor(
                            light: Colors.grey,
                            dark: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colors.adaptiveColor(
                  light: Colors.grey.shade500,
                  dark: colors.onSurfaceVariant,
                ),
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Speak clearly and include the same details as the text response",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: colors.adaptiveColor(
                      light: Colors.grey.shade600,
                      dark: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
