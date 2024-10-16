import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Constants/colors.dart';

import '../../../Routes/routes.dart';
import 'my_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 25),
      child: Drawer(
        backgroundColor: primarygreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Vav Foods Admin",
                  color: white,
                ),
                subtitle: MyText(
                  text: "Version 1.0.1",
                  color: white,
                ),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: background,
                  child: MyText(
                    text: "V",
                    color: secondary,
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1.5,
            ),
            //home
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.mainScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Home",
                  color: white,
                ),
                leading: const Icon(
                  Icons.home,
                  color: white,
                ),
              ),
            ),

            //products
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.allUsersScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Users",
                  color: white,
                ),
                leading: const Icon(
                  Icons.group,
                  color: white,
                ),
                /* trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ), */
              ),
            ),

            //orders
            /*  Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.allOrdersScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Orders",
                  color: AppConstant.appTextColor,
                ),
                leading: Icon(
                  Icons.shopping_bag,
                  color: AppConstant.appTextColor,
                ),
                /* trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ), */
              ),
            ), */
            //contact
            /*  Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Contact",
                  color: AppConstant.appTextColor,
                ),
                leading: Icon(
                  Icons.help,
                  color: AppConstant.appTextColor,
                ),
              ),
            ), */
            //logout
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () async {
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                  await firebaseAuth.signOut();
                  // Get.toNamed(AppRoutes.welcomeScreen);
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: MyText(
                  text: "Logout",
                  color: white,
                ),
                leading: const Icon(
                  Icons.logout,
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
