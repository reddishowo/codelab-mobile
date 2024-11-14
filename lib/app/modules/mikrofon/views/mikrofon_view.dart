import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mikrofon_controller.dart';

class MikrofonView extends GetView<MikrofonController> {
  const MikrofonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Speech to Text",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Memastikan warna teks di AppBar
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Animated microphone icon
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isListening.value
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: controller.isListening.value
                              ? Theme.of(context).primaryColor.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 60,
                      color: controller.isListening.value
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  )),
              const SizedBox(height: 40),
              // Status text
              Obx(() => Text(
                    controller.isListening.value ? "Listening..." : "Not Listening",
                    style: TextStyle(
                      color: controller.isListening.value
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              const SizedBox(height: 30),
              // Text display card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Obx(() => Text(
                          controller.text.value.isEmpty
                              ? "Kata-kata yang Anda ucapkan akan muncul di sini..."
                              : controller.text.value,
                          style: TextStyle(
                            fontSize: 20,
                            color: controller.text.value.isEmpty
                                ? Colors.grey.withOpacity(0.8)
                                : Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Control button dengan warna teks yang eksplisit
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isListening.value
                          ? controller.stopListening
                          : controller.startListening,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ), backgroundColor: controller.isListening.value
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ), // Mengatur warna teks tombol
                        elevation: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.isListening.value
                                ? Icons.stop
                                : Icons.mic_none,
                            size: 24,
                            color: Colors.white, // Memastikan warna ikon
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.isListening.value
                                ? "Stop Listening"
                                : "Start Listening",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Memastikan warna teks
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}