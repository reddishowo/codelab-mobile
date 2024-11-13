import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/VideoImage_controller.dart';

class ImageView extends GetView<VideoImageController> {
  const ImageView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker & Detection'),
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
                  return controller.isImageLoading.value
                      ? const CircularProgressIndicator()
                      : controller.selectedImagePath.value == ''
                          ? const Center(
                              child: Text('No image selected'),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    File(controller.selectedImagePath.value),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Display detected objects
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Obx(() => Text(
                                      controller.detectedObjects.isEmpty
                                          ? 'No objects detected'
                                          : 'Detected: ${controller.detectedObjects.join(", ")}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )),
                                  ),
                                ),
                              ],
                            );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.pickImage(ImageSource.camera),
                child: const Text('Pick Image from Camera'),
              ),
              ElevatedButton(
                onPressed: () => controller.pickImage(ImageSource.gallery),
                child: const Text('Pick Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => controller.deleteImage(),
                child: const Text('Delete Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}