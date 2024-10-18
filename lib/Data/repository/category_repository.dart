import 'package:vav_foods_admin_app/Data/interfaces/categories_interfaces.dart';
import 'package:vav_foods_admin_app/Data/models/category_model.dart';

class CategoryRepository {
  final CategoriesInterfaces interfaces;

  CategoryRepository({required this.interfaces});

  Future<List<CategoryModel>> addCategoriesToFirebase(
    String categoryName,
    String categoryDescription,
    String categoryImg,
  ) async {
    return interfaces.addCategoriesToFirebase(
      categoryName,
      categoryDescription,
      categoryImg,
    );
  }
}
