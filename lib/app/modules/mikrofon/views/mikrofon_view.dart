import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mikrofon_controller.dart';

class MikrofonView extends GetView<MikrofonController> {
  const MikrofonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            Obx(() => Text(
                  controller.text.value, // Menampilkan teks yang dihasilkan
                  style: const TextStyle(fontSize: 24),
                )),
            const SizedBox(height: 20),
            Center( // Center the button horizontally
              child: Obx(() => controller.isListening.value
                  ? ElevatedButton(
                      onPressed: controller.stopListening,
                      child: const Text("Stop Listening"),
                    )
                  : ElevatedButton(
                      onPressed: controller.startListening,
                      child: const Text("Start Listening"),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
