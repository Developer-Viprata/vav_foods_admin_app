// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Constants/colors.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_button.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_drawer.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_textFormField.dart';
import '../../../../Constants/responsive.dart';
import '../../../../Controllers/all_categories_controller.dart';
import '../../../../Controllers/pick_image_controller.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_text.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final PickImagesController pickImagesController =
      Get.find<PickImagesController>();
  final AllCategoriesController allCategoriesController =
      Get.find<AllCategoriesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: MyAppBar(
          title: "Add Category Screen",
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
              child: Column(
                children: [
                  //select images
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: 'Select Images',
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickImagesController.showImagesPickDialog();
                          },
                          child: MyText(text: 'Select Images'),
                        ),
                      ],
                    ),
                  ),
                  //pick images

                  GetBuilder<PickImagesController>(
                      builder: (pickImagesController) {
                    return pickImagesController.selectImage.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                              height: 300,
                              width: 500,
                              child: GridView.builder(
                                itemCount:
                                    pickImagesController.selectImage.length,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final isValidIndex = kIsWeb
                                      ? index <
                                          pickImagesController
                                              .webImageBytes.length
                                      : true;
                                  final imageFile =
                                      pickImagesController.selectImage[index];
                                  return Stack(
                                    children: [
                                      isValidIndex
                                          ? (kIsWeb
                                              ? Image.memory(
                                                  pickImagesController
                                                      .webImageBytes[index],
                                                  fit: BoxFit.cover,
                                                  height: 500,
                                                  width: 500,
                                                )
                                              : Image.file(
                                                  File(imageFile.path),
                                                  fit: BoxFit.cover,
                                                  height: 500,
                                                  width: 500,
                                                ))
                                          : Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    Text("Image Not Available"),
                                              ),
                                            ),
                                      Positioned(
                                        right: 10,
                                        top: 0,
                                        child: InkWell(
                                          onTap: () {
                                            pickImagesController.selectImage
                                                .removeAt(index);
                                            if (kIsWeb &&
                                                index <
                                                    pickImagesController
                                                        .webImageBytes.length) {
                                              pickImagesController.webImageBytes
                                                  .removeAt(index);
                                            }
                                            pickImagesController.update();
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
                        : const SizedBox.shrink();
                  }),

                  const SizedBox(
                    height: 25,
                  ),

                  //category name
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              hintText: 'Category Name',
                              controller: allCategoriesController
                                  .categoryNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Category Name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: allCategoriesController
                                  .categoryDescriptionController,
                              hintText: 'Category Description',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Category Description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => allCategoriesController.isLoading.value
                                  ? const CupertinoActivityIndicator()
                                  : MyButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // If the form is valid, display a snackbar. If the form is invalid, display
                                          await pickImagesController
                                              .uploadFunction(
                                                  pickImagesController
                                                      .selectImage);
                                          print(
                                              pickImagesController.arrImageUrl);

                                          await allCategoriesController
                                              .addCategoriesToFirebase(
                                            categoryName: allCategoriesController
                                                .categoryDescriptionController
                                                .text,
                                            categoryDescription:
                                                allCategoriesController
                                                    .categoryDescriptionController
                                                    .text,
                                            categoryImg: pickImagesController
                                                .arrImageUrl[0]
                                                .toString(),
                                          );
                                        }
                                        pickImagesController.selectImage
                                            .clear();
                                        pickImagesController.arrImageUrl
                                            .clear();
                                        pickImagesController.webImageBytes
                                            .clear();
                                        pickImagesController.update();
                                      },
                                      text: 'Add Category',
                                    ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
