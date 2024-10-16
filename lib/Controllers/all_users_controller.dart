// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Data/models/user_model.dart';
import '../Data/repository/users_repository.dart';

class AllUsersController extends GetxController {
  final UsersRepository usersRepository;
  AllUsersController({required this.usersRepository});

  final isLoading = false.obs;
  final usersList = <UserModel>[].obs;

  //adding for to select single user
  var selectedUser = Rxn<UserModel>();

  final TextEditingController userFullName = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsersFromFirebase();
  }

  Future<void> fetchUsersFromFirebase() async {
    try {
      isLoading.value = true;
      final fetchedUsers = await usersRepository.fetchUsersFromFirebase();
      usersList.value = fetchedUsers;
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Set the selected user
  void selectUser(UserModel user) {
    selectedUser.value = user;
  }
}
