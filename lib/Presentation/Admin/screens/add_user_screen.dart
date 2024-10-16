import 'package:flutter/material.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_textFormField.dart';
import '../../../Constants/colors.dart';
import '../widgets/my_app_bar.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'Add User Screen'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Full Name',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
