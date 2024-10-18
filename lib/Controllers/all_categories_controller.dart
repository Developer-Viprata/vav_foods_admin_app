import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Data/models/category_model.dart';
import '../Data/repository/category_repository.dart';

class AllCategoriesController extends GetxController {
  final CategoryRepository categoryRepository;
  AllCategoriesController({required this.categoryRepository});
  var isLoading = false.obs;
  var categoriesList = <CategoryModel>[].obs;
  Rx<CategoryModel?> selectedUser = Rx<CategoryModel?>(null);

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
  }

  Future<void> addCategoriesToFirebase({
    required String categoryName,
    required String categoryDescription,
    required String categoryImg,
  }) async {
    try {
      isLoading.value = true;
      categoriesList.value = await categoryRepository.addCategoriesToFirebase(
        categoryNameController.text.trim(),
        categoryDescriptionController.text.trim(),
        categoryImg,
      );

      categoryNameController.clear();
      categoryDescriptionController.clear();
      Get.snackbar('Success', 'Added category successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed while adding the Categories $e");
      print("Error adding Categories: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
