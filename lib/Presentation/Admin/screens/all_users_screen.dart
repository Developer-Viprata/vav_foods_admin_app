import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../../Controllers/all_users_controller.dart';
import '../../../Routes/routes.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_drawer.dart';
import '../widgets/my_text.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: MyDrawer(),
      backgroundColor: AppColors.background,
      appBar: MyAppBar(
        title: 'All Users Screen',
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: AppColors.background,
              ))
        ],
      ),
      body: Obx(() {
        if (allUsersController.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (allUsersController.usersList.isEmpty) {
          return Center(
            child: MyText(text: 'No users found'),
          );
        }
        return ListView.builder(
          itemCount: allUsersController.usersList.length,
          itemBuilder: (context, index) {
            final user = allUsersController.usersList[index];
            return ListTile(
              onTap: () {
                Get.toNamed(AppRoutes.singleUserDetailsScreen);
              },
              title: Text(user.fullName),
              subtitle: Text(user.email),
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Text(
                  user.fullName.isNotEmpty
                      ? user.fullName[0].toUpperCase()
                      : '',
                  style: TextStyle(
                    color: AppColors.background,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text: user.role.toString().split('.').last,
                    color: AppColors.textcolor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.singleUserDetailsScreen);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.textcolor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    ));
  }
}
