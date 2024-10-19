// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vav_foods_admin_app/Data/models/category_model.dart';
import 'package:vav_foods_admin_app/Data/repository/category_repository.dart';

class AllCategoriesController extends GetxController {
  final CategoryRepository categoryRepository;
  AllCategoriesController({required this.categoryRepository});

  var isLoading = false.obs;
  var categoriesList = <CategoryModel>[].obs;
  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  final ImagePicker _picker = ImagePicker(); // Image picker instance
  RxList<XFile> selectedImages = <XFile>[].obs; // Selected images
  RxList<Uint8List> webImageBytes = <Uint8List>[].obs; // For web image bytes
  final RxList<String> uploadedImageUrls =
      <String>[].obs; // Image URLs after upload

  // For category inputs
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromFirebase();
  }

  @override
  void onClose() {
    super.onClose();
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
  }

  //fetch categories

  Future<void> fetchCategoriesFromFirebase() async {
    try {
      isLoading(true);
      final fetchCategories =
          await categoryRepository.fetchCategoriesFromFirebase();
      if (fetchCategories != null && fetchCategories.isNotEmpty) {
        categoriesList.value = fetchCategories;
      } else {
        print("No Categories Found");
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoryById(String categoryId) async {
    try {
      isLoading(true);
      final CategoryModel? category =
          await categoryRepository.fetchsingleCategoryFromFirebase(categoryId);
      if (category != null) {
        selectedCategory.value = category;

        categoryNameController.text = category.categoryName;

        categoryDescriptionController.text = category.categoryDescription;
        // Handle category images
        uploadedImageUrls.clear(); // Clear any previously stored image URLs

        if (category.categoryImg != null && category.categoryImg.isNotEmpty) {
          // Add the fetched image URLs to the list
          uploadedImageUrls.add(category.categoryImg);
        }
      }
    } catch (e) {
      print("Error fetching single category details: $e");
    } finally {
      isLoading(false);
    }
  }

  // Method to pick images (handles web and mobile)
  Future<void> pickImages(String sourceType) async {
    List<XFile> images = [];

    if (kIsWeb) {
      // Web-specific logic
      images = await _picker.pickMultiImage(imageQuality: 80) ?? [];
      for (var image in images) {
        final bytes = await image.readAsBytes();
        webImageBytes.add(bytes);
      }
    } else {
      if (sourceType == 'gallery') {
        images = await _picker.pickMultiImage(imageQuality: 80) ?? [];
      } else {
        final image = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
        if (image != null) {
          images.add(image);
        }
      }
    }

    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  // Remove image from list
  void removeImage(int index) {
    selectedImages.removeAt(index);
    if (kIsWeb && index < webImageBytes.length) {
      webImageBytes.removeAt(index);
    }
  }

  // Upload images to Firebase (delegated to repository)
  Future<void> uploadSelectedImages() async {
    uploadedImageUrls.clear(); // Clear any previous URLs
    for (int i = 0; i < selectedImages.length; i++) {
      final imageUrl = await categoryRepository
          .uploadCategoryImageToStorage(selectedImages[i]);
      uploadedImageUrls.add(imageUrl);
    }
  }

  // Add category to Firebase with image URLs
  Future<void> addCategory() async {
    if (categoryNameController.text.isEmpty ||
        categoryDescriptionController.text.isEmpty ||
        uploadedImageUrls.isEmpty) {
      Get.snackbar('Error', 'Please provide all required fields and images');
      return;
    }

    try {
      isLoading.value = true;

      // Add category
      await categoryRepository.addCategoriesToFirebase(
        categoryNameController.text.trim(),
        categoryDescriptionController.text.trim(),
        uploadedImageUrls.first, // Assuming first image is the category image
      );

      categoryNameController.clear();
      categoryDescriptionController.clear();
      selectedImages.clear();
      webImageBytes.clear();
      uploadedImageUrls.clear();

      Get.snackbar('Success', 'Category added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
