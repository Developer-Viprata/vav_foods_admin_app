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
  var selectedRole = UserRole.Admin.obs;
/* 
  TextEditingController userFullName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhoneNumber = TextEditingController();
  TextEditingController userPassword = TextEditingController(); */

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

  Future<void> addUsersToFirebase({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Fetch data from the input controllers
      /*   String fullName = userFullName.text;
      String email = userEmail.text;
      String phoneNumber = userPhoneNumber.text;
      String password = userPassword.text; */

      // Call the repository to add the user
      usersList.value = await usersRepository.addUsersToFirebase(
        fullName,
        email,
        phoneNumber,
        password,
        selectedRole.value, // Pass the selected role to the repository
      );

      Get.snackbar('Success', 'Added user  successfully');

      // Clear the input fields after successful addition
      /* userFullName.clear();
      userEmail.clear();
      userPhoneNumber.clear();
      userPassword.clear(); */
    } catch (e) {
      Get.snackbar("Error", "Failed while adding the user $e");
      print("Error adding user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;

      // Call the repository to delete the user
      usersList.value = await usersRepository.deleteUser(userId);

      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed to delete the user: $e");
      print("Error deleting user: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
