import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_text.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_textFormField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomTextFormField(),
          CustomTextFormField(),
          CustomTextFormField(),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            Get.toNamed('/SidebarWidget');

          }, child: MyText(text: "Login"))
        ],
      ),

    );
  }
}