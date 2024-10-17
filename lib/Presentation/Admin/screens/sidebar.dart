import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/widgets/my_text.dart';
import 'package:vav_foods_admin_app/Routes/routes.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: MyText(text: "Add User"),
                    onTap: () {
                      Get.toNamed(AppRoutes.addUserScreen, id: 1);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: MyText(text: "All Users"),
                    onTap: () {
                      Get.toNamed(AppRoutes.allUsersScreen, id: 1);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit_note),
                    title: MyText(text: "Edit Details"),
                    onTap: () {
                      Get.toNamed(AppRoutes.editUserDetailsScreen, id: 1);
                    },
                  ),
                   ExpansionTile(
                  leading: Icon(Icons.build),
                  title: MyText(text: "Options"),
                  children: [
                     ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text("Dashboard"),
                      onTap: () {
                        Get.toNamed(AppRoutes.allUsersScreen, id: 1);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.analytics),
                      title: Text("Analytics"),
                      onTap: () {
                        Get.toNamed(AppRoutes.addUserScreen, id: 1);
                      },
                    ),

                  ])
                ],
              )),
          Expanded(
            child: Navigator(
              key: Get.nestedKey(1),
              initialRoute: AppRoutes.mainScreen, // Access AppRoutes directly
              onGenerateRoute: (route) {
                return GetPageRoute(
                  page: () {
                    // Fetch the correct page by matching the route name
                    final page = AppRoutes.routes
                        .firstWhere((element) => element.name == route.name)
                        .page;

                    return page();
                  },
                  routeName: route.name,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


