import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALL IN ONE APP'),
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFeatureButton(
                icon: Icons.videocam,
                label: 'Video Picker',
                onPressed: () => Get.toNamed('/video'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                icon: Icons.image,
                label: 'Image Picker',
                onPressed: () => Get.toNamed('/image'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                icon: Icons.mic,
                label: 'Speech to Text',
                onPressed: () => Get.toNamed('/mikrofon'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                icon: Icons.speaker,
                label: 'Audio Player',
                onPressed: () => Get.toNamed('/speaker'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
