// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vav_foods_admin_app/Data/interfaces/categories_interfaces.dart';
import 'package:vav_foods_admin_app/Data/models/category_model.dart';

class CategoriesServices implements CategoriesInterfaces {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//fetch

  @override
  Future<List<CategoryModel>> fetchCategoriesFromFirebase() async {
    List<CategoryModel> categoriesList = [];

    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('categories').get();
      snapshot.docs.forEach((element) {
        categoriesList
            .add(CategoryModel.fromMap(element.data() as Map<String, dynamic>));
      });
    } catch (e) {
      print("Error in fetching the categories: $e");
    }
    return categoriesList;
  }

//add
  @override
  Future<List<CategoryModel>> addCategoriesToFirebase(String categoryName,
      String categoryDescription, String categoryImg) async {
    List<CategoryModel> categoriesList = [];

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

  //single category
  @override
  Future<CategoryModel?> fetchsingleCategoryFromFirebase(
      String categoryId) async {
    try {
      DocumentSnapshot categoryDoc = await firebaseFirestore
          .collection("categories")
          .doc(categoryId)
          .get();
      if (categoryDoc.exists) {
        return CategoryModel.fromMap(
            categoryDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching single category: $e");
    }
    return null;
  }

//store
  @override
  Future<String> uploadCategoryImageToStorage(XFile image) async {
    TaskSnapshot reference;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      reference = await firebaseStorage
          .ref('category-images/${image.name + DateTime.now().toString()}')
          .putData(bytes);
    } else {
      reference = await firebaseStorage
          .ref('category-images/${image.name + DateTime.now().toString()}')
          .putFile(File(image.path));
    }

    return await reference.ref.getDownloadURL();
  }
}
