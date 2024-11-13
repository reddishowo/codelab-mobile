import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SpeakerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var currentUrl = ''.obs;  // Menambahkan variabel untuk menyimpan URL saat ini

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });
    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // Memperbarui URL saat ini
  void updateCurrentUrl(String url) {
    currentUrl.value = url;
  }

  Future<void> playAudio(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a valid URL',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _audioPlayer.play(UrlSource(url));
      currentUrl.value = url;
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to play audio: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPlaying.value = false;
  }

  Future<void> resumeAudio() async {
    if (currentUrl.value.isEmpty) {
      Get.snackbar(
        'Error',
        'No audio URL set',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await _audioPlayer.resume();
    isPlaying.value = true;
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
  }

  void seekAudio(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }
}