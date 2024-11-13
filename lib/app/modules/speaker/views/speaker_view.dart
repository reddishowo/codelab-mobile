import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_codelab_4/app/modules/speaker/controllers/speaker_controller.dart';

class SpeakerView extends GetView<SpeakerController> {
  const SpeakerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TextField untuk input URL
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter Audio URL',
                hintText: 'https://example.com/audio.mp3',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    urlController.clear();
                    controller.stopAudio();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Slider untuk mengontrol posisi audio
            Obx(() {
              return Slider(
                min: 0.0,
                max: controller.duration.value.inSeconds.toDouble(),
                value: controller.position.value.inSeconds.toDouble(),
                onChanged: (value) {
                  controller.seekAudio(Duration(seconds: value.toInt()));
                },
              );
            }),
            
            // Menampilkan waktu yang sudah diputar dan durasi total
            Obx(() {
              return Text(
                '${_formatDuration(controller.position.value)} / ${_formatDuration(controller.duration.value)}',
              );
            }),
            
            const SizedBox(height: 20),
            
            // Tombol kontrol audio
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.isPlaying.value
                        ? controller.pauseAudio
                        : controller.resumeAudio,
                    child: Text(controller.isPlaying.value ? 'Pause' : 'Resume'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => controller.playAudio(urlController.text),
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: controller.stopAudio,
                    child: const Text('Stop'),
                  ),
                ],
              );
            }),

            // Menampilkan URL yang sedang diputar
            const SizedBox(height: 20),
            Obx(() => controller.currentUrl.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Now playing: ${controller.currentUrl.value}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}