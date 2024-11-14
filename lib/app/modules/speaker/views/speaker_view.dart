import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/speaker_controller.dart';

class SpeakerView extends GetView<SpeakerController> {
  const SpeakerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Player',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // URL Input Field with enhanced design
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter Audio URL',
                    hintText: 'https://example.com/audio.mp3',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.link),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        urlController.clear();
                        controller.stopAudio();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Animated music wave indicator
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 60,
                    child: Icon(
                      Icons.music_note,
                      size: 40,
                      color: controller.isPlaying.value
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  )),
              const SizedBox(height: 20),
              // Enhanced slider with better visuals
              Column(
                children: [
                  Obx(() => Slider(
                        min: 0.0,
                        max: controller.duration.value.inSeconds.toDouble(),
                        value: controller.position.value.inSeconds.toDouble(),
                        onChanged: (value) {
                          controller.seekAudio(Duration(seconds: value.toInt()));
                        },
                        activeColor: Theme.of(context).primaryColor,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(controller.position.value),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              _formatDuration(controller.duration.value),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Enhanced control buttons
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: Icons.stop,
                        label: 'Stop',
                        onPressed: controller.stopAudio,
                        context: context,
                      ),
                      const SizedBox(width: 20),
                      _buildControlButton(
                        icon: controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        label: controller.isPlaying.value ? 'Pause' : 'Play',
                        onPressed: () {
                          if (controller.currentUrl.value.isEmpty) {
                            controller.playAudio(urlController.text);
                          } else {
                            controller.isPlaying.value
                                ? controller.pauseAudio()
                                : controller.resumeAudio();
                          }
                        },
                        context: context,
                        isPrimary: true,
                      ),
                      const SizedBox(width: 20),
                      _buildControlButton(
                        icon: Icons.replay,
                        label: 'Replay',
                        onPressed: () => controller.playAudio(urlController.text),
                        context: context,
                      ),
                    ],
                  )),
              const SizedBox(height: 30),
              // Now playing display
              Obx(() => controller.currentUrl.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.music_note, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Now playing: ${controller.currentUrl.value}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: isPrimary
              ? Colors.white
              : Theme.of(context).primaryColor, backgroundColor: isPrimary
              ? Theme.of(context).primaryColor
              : Colors.white, padding: const EdgeInsets.all(20),
          shape: const CircleBorder(),
        ),
        child: Icon(icon),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}