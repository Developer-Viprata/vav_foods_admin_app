import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // For detecting platform
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_text.dart';

class PickImagesController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  RxList<XFile> selectImage = <XFile>[].obs;
  final RxList<String> arrImageUrl = <String>[].obs;
  RxList<Uint8List> webImageBytes =
      <Uint8List>[].obs; // For storing web image bytes
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagesPickDialog() async {
    // For web, no need to request permissions
    if (kIsWeb) {
      // Directly show the image picking options
      showPickDialog();
    } else {
      // Handle mobile permissions
      PermissionStatus status;
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

      // For Android versions less than 32
      if (androidDeviceInfo.version.sdkInt < 32) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.mediaLibrary.request();
      }

      // If permission granted, show dialog
      if (status == PermissionStatus.granted) {
        showPickDialog();
      } else if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied) {
        print("Error: Permission denied, open app settings.");
        openAppSettings(); // Ask user to enable permissions from settings
      }
    }
  }

  // Function to show dialog for choosing Camera or Gallery
  void showPickDialog() {
    Get.defaultDialog(
      title: "Choose Image",
      middleText: "Pick an image from the camera or gallery",
      actions: [
        ElevatedButton(
          onPressed: () {
            selectImages("Camera");
            Get.back(); // Close the dialog after selecting Gallery
          },
          child: MyText(text: 'Camera'),
        ),
        ElevatedButton(
          onPressed: () {
            selectImages("gallery");
            Get.back(); // Close the dialog after selecting Gallery
          },
          child: MyText(text: 'Gallery'),
        ),
      ],
    );
  }

  // Select multiple images (handles both web and mobile)
  Future<void> selectImages(String type) async {
    List<XFile> images = [];

    if (kIsWeb) {
      // Web-specific image picking (only gallery is supported)
      try {
        images = await _picker.pickMultiImage(imageQuality: 80);
        update();
      } catch (e) {
        print("Error selecting images on web: $e");
      }
    } else {
      // Mobile platform image picking logic
      if (type == "gallery") {
        try {
          images = await _picker.pickMultiImage(imageQuality: 80);
          update();
        } catch (e) {
          print("Error: $e");
        }
      } else {
        final img = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
        if (img != null) {
          images.add(img);
          update();
        }
      }
    }

    if (images.isNotEmpty) {
      selectImage.addAll(images);
      // For web, read image bytes
      if (GetPlatform.isWeb) {
        for (var image in images) {
          final bytes = await image.readAsBytes();
          webImageBytes.add(bytes);
        }
      }
      update();
      print("Selected images count: ${selectImage.length}");
    }
  }

  void removeImages(int index) {
    selectImage.removeAt(index);
    update();
  }

  //upload images into storage.
  Future<void> uploadFunction(List<XFile> _images) async {
    arrImageUrl.clear();
    for (int i = 0; i < _images.length; i++) {
      dynamic imageUrl = await uploadFile(_images[i]);
      arrImageUrl.add(imageUrl.toString());
    }
    update();
  }

  Future<String> uploadFile(XFile _image) async {
    TaskSnapshot reference;

    if (kIsWeb) {
      // For web platform, use `Uint8List` for uploading.
      final bytes = await _image.readAsBytes(); // Read file bytes
      reference = await storageRef
          .ref()
          .child('category-images/${_image.name + DateTime.now().toString()}')
          .putData(bytes); // Use putData for Uint8List
    } else {
      // For mobile platforms, use the `File` class.
      reference = await storageRef
          .ref()
          .child('category-images/${_image.name + DateTime.now().toString()}')
          .putFile(File(_image.path)); // Use putFile for File
    }

    return await reference.ref.getDownloadURL();
  }

/*   Future<String> uploadFile(XFile _image) async {
    TaskSnapshot reference = await storageRef
        .ref()
        .child('product-images')
        .child(_image.name + DateTime.now().toString())
        .putFile(File(_image.path));

    return await reference.ref.getDownloadURL();
  } */
}
