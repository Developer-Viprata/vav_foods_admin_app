// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Controllers/get_auto_id_controller.dart';
import 'package:vav_foods_admin_app/Data/interfaces/categories_interfaces.dart';
import 'package:vav_foods_admin_app/Data/models/category_model.dart';

class CategoriesServices implements CategoriesInterfaces {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> addCategoriesToFirebase(String categoryName,
      String categoryDescription, String categoryImg) async {
    List<CategoryModel> categoriesList = [];
    final GetAutoIdController getAutoIdController =
        Get.find<GetAutoIdController>();
    try {
      DocumentReference docRef =
          firebaseFirestore.collection('categories').doc();
      final String categoryId = docRef.id;
      CategoryModel categoryModel = CategoryModel(
        categoryId: categoryId,
        categoryName: categoryName,
        categoryDescription: categoryDescription,
        categoryImg: categoryImg,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      // Add category to Firebase (or perform any other operation)
      await firebaseFirestore
          .collection('categories')
          .doc(categoryId)
          .set(categoryModel.toMap());

      categoriesList.add(categoryModel);
    } catch (e) {
      print('Error adding category: $e');
    }
    return categoriesList;
  }
}
