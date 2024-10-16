// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_text.dart';
import '../../../Constants/colors.dart';
import '../../../Controllers/all_users_controller.dart';
import '../../../Data/models/user_model.dart';
import '../widgets/my_app_bar.dart';

class SingleUserDetailsScreen extends StatelessWidget {
  final AllUsersController allUsersController = Get.find<AllUsersController>();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = allUsersController.selectedUser.value;

    if (user == null) {
      return Scaffold(
        appBar: MyAppBar(title: 'User Details'),
        body: Center(
          child: MyText(text: 'No user data found.'),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'User Details'),
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
              MyText(text: 'Role: ${user.role.toString().split('.').last}'),
              const SizedBox(height: 10),
              MyText(text: 'Created At: ${user.createdAt}'),
              const SizedBox(height: 10),
              MyText(text: 'Updated At: ${user.updatedAt}'),
            ],
          ),
        ),
      ),
    );
  }
}
