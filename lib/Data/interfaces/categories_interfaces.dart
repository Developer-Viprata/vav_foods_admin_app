import 'package:image_picker/image_picker.dart';

import '../models/category_model.dart';

abstract class CategoriesInterfaces {
  //categories

  Future<List<CategoryModel>> fetchCategoriesFromFirebase();
//add
  Future<List<CategoryModel>> addCategoriesToFirebase(
    String categoryName,
    String categoryDescription,
    String categoryImg,
  );
  // Fetch a single category by their userId
  Future<CategoryModel?> fetchsingleCategoryFromFirebase(String categoryId);
//store
  Future<String> uploadCategoryImageToStorage(XFile image);
}
