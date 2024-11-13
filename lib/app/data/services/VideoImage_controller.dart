import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class VideoImageController extends GetxController {
  final ImagePicker _picker = ImagePicker(); // Object image picker
  final box = GetStorage(); // Get storage variable
  var selectedImagePath = ''.obs; // Variable to store image path
  var isImageLoading = false.obs; // Variable for loading state
  var selectedVideoPath = ''.obs; // Variable to store video path
  var isVideoPlaying = false.obs; // Variable for pause and play state
  var detectedObjects = <String>[].obs;
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }


  Future<void> detectObjects(String imagePath) async {
    try {
      // Create InputImage correctly
      final inputImage = InputImage.fromFilePath(imagePath);
      
      // Create and configure ImageLabeler
      final options = ImageLabelerOptions(confidenceThreshold: 0.7);
      // ignore: deprecated_member_use
      final imageLabeler = GoogleMlKit.vision.imageLabeler(options);
      
      // Process the image
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      
      // Update detected objects
      detectedObjects.value = labels
          .map((label) => '${label.label} (${(label.confidence * 100).toStringAsFixed(0)}%)')
          .toList();
      
      // Close the labeler
      await imageLabeler.close();
    } catch (e) {
      print('Error detecting objects: $e');
      detectedObjects.value = ['Error detecting objects'];
    }
  }

  // Function Future to get photo using camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath', pickedFile.path);
        
        // Clear previous detections before starting new detection
        detectedObjects.clear();
        
        // Detect objects in the selected image
        await detectObjects(pickedFile.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Function Future to get video using camera or gallery
  Future<void> pickVideo(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path); // Save video path to storage
        // Initialize VideoPlayerController
        videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path))
              ..initialize().then((_) {
                videoPlayerController!.play();
                isVideoPlaying.value = true; // Update status
                update(); // Notify UI
              });
      } else {
        print('No video selected.');
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';
    if (selectedVideoPath.value.isNotEmpty) {
      detectObjects(selectedImagePath.value);
      videoPlayerController =
          VideoPlayerController.file(File(selectedVideoPath.value))
            ..initialize().then((_) {
              videoPlayerController!.play();
              isVideoPlaying.value = true; // Update status
              update(); // Notify UI
            });
    }
  }

  // Delete image and reset data
  void deleteImage() {
    selectedImagePath.value = ''; // Reset image path
    box.remove('imagePath'); // Remove image path from storage
        detectedObjects.clear(); // Clear detected objects when image is deleted
  }

  // Delete video and reset data
  void deleteVideo() {
    selectedVideoPath.value = ''; // Reset video path
    box.remove('videoPath'); // Remove video path from storage
    videoPlayerController?.dispose(); // Dispose video controller
    videoPlayerController = null; // Reset video controller
    isVideoPlaying.value = false; // Update status
    update(); // Notify UI
  }

  void play() {
    videoPlayerController?.play();
    isVideoPlaying.value = true; // Update status
    update(); // Notify UI
  }

  void pause() {
    videoPlayerController?.pause();
    isVideoPlaying.value = false; // Update status
    update(); // Notify UI
  }

  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
        isVideoPlaying.value = false; // Update status
      } else {
        videoPlayerController!.play();
        isVideoPlaying.value = true; // Update status
      }
      update(); // Notify UI
    }
  }
}
