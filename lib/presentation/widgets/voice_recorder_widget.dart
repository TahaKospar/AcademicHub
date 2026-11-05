import 'dart:async';
import 'package:academichub/data/services/voices/voice_recorder_controller.dart';
import 'package:flutter/material.dart';

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
  Widget build(context) {
    bool isRecording = _recorderController.isRecording;

    if (isRecording) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border.all(color: Colors.red.withOpacity(0.3)),
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
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
            const SizedBox(width: 6),
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(
                color: Colors.red,
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
                color: Colors.orange,
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
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Voice note",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Record Your answer",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Ready",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
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
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tap to record",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "No recording saved yet",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
              Icon(Icons.info_outline, color: Colors.grey[500], size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Speak clearly and include the same details as the text response",
                  style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}