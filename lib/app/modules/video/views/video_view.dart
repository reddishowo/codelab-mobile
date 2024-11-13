import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../data/services/VideoImage_controller.dart';

class VideoView extends GetView<VideoImageController> {
  const VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Picker'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height / 2.32,
                width: Get.width * 0.7,
                child: Obx(() {
                  if (controller.selectedVideoPath.value.isNotEmpty) {
                    return Card(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: VideoPlayer(controller.videoPlayerController!),
                          ),
                          VideoProgressIndicator(
                            controller.videoPlayerController!,
                            allowScrubbing: true,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  controller.isVideoPlaying.isTrue
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                ),
                                onPressed: controller.togglePlayPause,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center( // Center the "No video selected" text
                      child: Text('No video selected'),
                    );
                  }
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.pickVideo(ImageSource.camera),
                child: const Text('Pick Video from Camera'),
              ),
              ElevatedButton(
                onPressed: () => controller.pickVideo(ImageSource.gallery),
                child: const Text('Pick Video from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => controller.deleteVideo(),
                child: const Text('Delete Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
