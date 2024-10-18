import 'package:vav_foods_admin_app/Data/models/category_model.dart';

import '../models/user_model.dart';

abstract class CategoriesInterfaces {
  //categories

  Future<List<CategoryModel>> addCategoriesToFirebase(
    String categoryName,
    String categoryDescription,
    String categoryImg,
  );
}
