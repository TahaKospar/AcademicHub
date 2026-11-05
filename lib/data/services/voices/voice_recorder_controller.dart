import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorderController {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? recordedFilePath;
  bool isRecording = false;
  bool isPaused = false;

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        recordedFilePath =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // إعدادات التشفير لتقليل حجم الملف لأقصى درجة مع الحفاظ على نقاء الصوت
        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 32000, // 32kbps حجم صغير جداً
          sampleRate: 16000,
        );

        await _audioRecorder.start(config, path: recordedFilePath!);
        isRecording = true;
        isPaused = false;
      }
    } catch (e) {
      print('Error starting record: $e');
    }
  }

  Future<void> pauseRecording() async {
    if (isRecording && !isPaused) {
      await _audioRecorder.pause();
      isPaused = true;
    }
  }

  Future<void> resumeRecording() async {
    if (isRecording && isPaused) {
      await _audioRecorder.resume();
      isPaused = false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording = false;
      isPaused = false;
      recordedFilePath = path;
      return path; 
    } catch (e) {
      print('Error stopping record: $e');
      return null;
    }
  }

  bool get hasRecordedFile =>
      recordedFilePath != null && File(recordedFilePath!).existsSync();

  Future<void> dispose() async {}
}
