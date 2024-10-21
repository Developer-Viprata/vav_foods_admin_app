import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Constants/colors.dart';
import 'package:vav_foods_admin_app/Controllers/all_categories_controller.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_app_bar.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_button.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_textFormField.dart';

import '../../../../Constants/responsive.dart';
import '../../../../Data/models/category_model.dart';
import '../../widgets/my_text.dart';

class EditCategoriesScreen extends StatefulWidget {
  const EditCategoriesScreen({super.key});

  @override
  State<EditCategoriesScreen> createState() => _EditCategoriesScreenState();
}

class _EditCategoriesScreenState extends State<EditCategoriesScreen> {
  final AllCategoriesController allCategoriesController =
      Get.find<AllCategoriesController>();
  String? categoryId;

  @override
  void initState() {
    super.initState();

    // Retrieve the category ID from arguments if available
    categoryId = (Get.arguments as CategoryModel?)?.categoryId;
    if (categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allCategoriesController.fetchCategoryById(categoryId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (allCategoriesController.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          final category = allCategoriesController.selectedCategory.value;
          if (category == null) {
            return Scaffold(
              body: Center(
                child: MyText(text: 'No category data found.'),
              ),
            );
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: MyAppBar(
              title: category != null
                  ? "Edit ${category.categoryName} Details"
                  : "Loading category details...",
            ),
            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? MediaQuery.of(context).size.width * .4
                        : Responsive.isTablet(context)
                            ? MediaQuery.of(context).size.width * .7
                            : Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width * 1
                                : MediaQuery.of(context).size.width * .9,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        // Select images section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(text: 'Select Images'),
                              ElevatedButton(
                                onPressed: () async {
                                  // Trigger image selection
                                  await allCategoriesController
                                      .pickImages('gallery');

                                  // Replace the current image with the newly selected image
                                  if (allCategoriesController.selectedImages !=
                                      null) {
                                    // Delete the previous image from Firebase Storage and Firestore
                                    await allCategoriesController
                                        .deleteImageFromStorage(
                                            category.categoryImg);

                                    // Upload the new image and update the URL in Firebase
                                    await allCategoriesController
                                        .uploadedImageUrls();
                                  }
                                },
                                child: MyText(text: 'Select Images'),
                              ),
                            ],
                          ),
                        ),

                        // Display existing images from Firebase and newly added images
                        allCategoriesController.uploadedImageUrls.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  height: 300,
                                  width: 500,
                                  child: GridView.builder(
                                    itemCount: allCategoriesController
                                        .uploadedImageUrls.length,
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final imageUrl = allCategoriesController
                                          .uploadedImageUrls[index];
                                      final isWebImage = kIsWeb &&
                                          index <
                                              allCategoriesController
                                                  .webImageBytes.length;
                                      return Stack(
                                        children: [
                                          isWebImage
                                              ? Image.memory(
                                                  allCategoriesController
                                                      .webImageBytes[index],
                                                  fit: BoxFit.cover,
                                                  height: 500,
                                                  width: 500,
                                                )
                                              : Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  height: 500,
                                                  width: 500,
                                                ),
                                          Positioned(
                                            right: 10,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                allCategoriesController
                                                    .removeImage(index);
                                              },
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.secondary,
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.background,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 10),
                        Form(
                          child: Column(
                            children: [
                              // Autofill the category name and description
                              CustomTextFormField(
                                controller: allCategoriesController
                                    .categoryNameController,
                                hintText: "Category Name",
                              ),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller: allCategoriesController
                                    .categoryDescriptionController,
                                hintText: "Category Description",
                              ),
                              const SizedBox(height: 10),
                              MyButton(
                                minWidth: 200,
                                onPressed: () async {
                                  if (allCategoriesController
                                          .categoryNameController
                                          .text
                                          .isEmpty ||
                                      allCategoriesController
                                          .categoryDescriptionController
                                          .text
                                          .isEmpty ||
                                      allCategoriesController
                                          .uploadedImageUrls.isEmpty) {
                                    Get.snackbar('Error',
                                        'Please fill in all required fields.');
                                    return;
                                  }
                                  await allCategoriesController
                                      .updateCategoryFromFirebase(
                                    allCategoriesController
                                        .categoryNameController.text
                                        .trim(),
                                    allCategoriesController
                                        .categoryDescriptionController.text
                                        .trim(),
                                    allCategoriesController.uploadedImageUrls
                                        .toString(),
                                  );
                                },
                                text: "Update Category",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
