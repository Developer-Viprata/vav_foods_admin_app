import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../../Controllers/all_users_controller.dart';
import '../widgets/my_app_bar.dart';

class SingleUserDetailsScreen extends StatefulWidget {
  const SingleUserDetailsScreen({super.key});

  @override
  State<SingleUserDetailsScreen> createState() =>
      _SingleUserDetailsScreenState();
}

class _SingleUserDetailsScreenState extends State<SingleUserDetailsScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'SingleUserDetailsScreen'),
      ),
    );
  }
}
