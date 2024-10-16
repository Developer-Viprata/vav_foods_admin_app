import 'package:flutter/material.dart';
import 'package:vav_foods_admin_app/Constants/colors.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_drawer.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: MyDrawer(),
      backgroundColor: background,
      appBar: MyAppBar(
        title: 'All Users Screen',
      ),
    ));
  }
}
