// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Constants/colors.dart';
import '../../../../Controllers/all_users_controller.dart';
import '../../../../Data/models/user_model.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_text.dart';

class SingleUserDetailsScreen extends StatefulWidget {
  @override
  State<SingleUserDetailsScreen> createState() =>
      _SingleUserDetailsScreenState();
}

class _SingleUserDetailsScreenState extends State<SingleUserDetailsScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();
  String? userId;

  @override
  void initState() {
    super.initState();
    // Get userId from arguments
    userId = (Get.arguments as UserModel?)?.userId;

    // Fetch the user by userId safely within initState
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allUsersController.fetchUserById(userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'User Details'),
        body: Obx(() {
          // Show loading indicator
          if (allUsersController.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator());
          }

          // Check if the user is null
          final user = allUsersController.selectedUser.value;
          if (user == null) {
            return Center(child: MyText(text: 'No user data found.'));
          }

          // Display the user details
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(text: 'Full Name: ${user.fullName}'),
                    const SizedBox(height: 10),
                    MyText(text: 'Email: ${user.email}'),
                    const SizedBox(height: 10),
                    MyText(text: 'Phone: ${user.phoneNumber}'),
                    const SizedBox(height: 10),
                    MyText(text: 'isActive: ${user.isActive}'),
                    const SizedBox(height: 10),
                    MyText(
                        text: 'Role: ${user.role.toString().split('.').last}'),
                    const SizedBox(height: 10),
                    MyText(text: 'Created At: ${user.createdAt}'),
                    const SizedBox(height: 10),
                    MyText(text: 'Updated At: ${user.updatedAt}'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
