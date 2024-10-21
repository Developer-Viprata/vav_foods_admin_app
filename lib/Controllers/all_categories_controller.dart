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

  final ImagePicker imagePicker = ImagePicker(); // Image picker instance
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

  /*  Future<void> fetchCategoryById(String categoryId) async {
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
  } */

  //modified code to fetch category by id

  Future<void> fetchCategoryById(String categoryId) async {
    try {
      isLoading(true);

      // Fetch the category from the repository
      final CategoryModel? category =
          await categoryRepository.fetchsingleCategoryFromFirebase(categoryId);

      if (category != null) {
        // Set the selected category
        selectedCategory.value = category;

        // Update controllers with category details
        categoryNameController.text = category.categoryName;
        categoryDescriptionController.text = category.categoryDescription;

        // Handle category images

        uploadedImageUrls.clear(); // Clear any previously stored image URLs

        // Add the image URL to the list only if it's not null and not empty

        if (category.categoryImg.isNotEmpty) {
          uploadedImageUrls.add(category.categoryImg);
        } else {
          print("No image found for this category.");
        }
      } else {
        print("Category not found.");
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
      images = await imagePicker.pickMultiImage(imageQuality: 80) ?? [];
      for (var image in images) {
        final bytes = await image.readAsBytes();
        webImageBytes.add(bytes);
      }
    } else {
      if (sourceType == 'gallery') {
        images = await imagePicker.pickMultiImage(imageQuality: 80) ?? [];
      } else {
        final image = await imagePicker.pickImage(
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
  //this function will work when i user pick the wrong image he want to change the image he can able to remove the picked image
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

  //update
  Future<void> updateCategoryFromFirebase(
    String categoryName,
    String categoryDescription,
    String categoryImg,
  ) async {
    try {
      isLoading.value = true;
      if (categoryName.isEmpty ||
          categoryDescription.isEmpty ||
          categoryImg.isEmpty) {
        throw Exception("Fields cannot be empty");
      }
      await categoryRepository.updateCategoryFromFirebase(
        selectedCategory.value!.categoryId,
        categoryName,
        categoryDescription,
        categoryImg,
      );
      Get.snackbar('Success', 'Updated Category details successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed while updating the Category $e");
      print("Error while updating the category: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //delete images form storage

  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      isLoading.value = true;
      await categoryRepository.deleteImageFromStorage(imageUrl);
      print("Image deleted from Storage");
    } catch (e) {
      Get.snackbar("Error", "Failed while deleting the category image: $e");
      print("Error while deleting the category image: $e");
    } finally {
      isLoading.value = false;
    }
  }

//delete
  Future<void> deleteCategoryFromFirebase(String categoryId) async {
    try {
      isLoading.value = true;
      categoriesList.value =
          await categoryRepository.deleteUserFromFirebase(categoryId);
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed to delete the Category: $e");
      print("Error deleting category: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
