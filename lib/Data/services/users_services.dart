// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vav_foods_admin_app/Data/models/user_model.dart';
import '../interfaces/interfaces.dart';

class UsersServices implements Interfaces {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<List<UserModel>> fetchUsersFromFirebase() async {
    List<UserModel> userList = [];
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('users').get();
      for (var doc in snapshot.docs) {
        userList.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error in fetching users: $e");
    }
    return userList;
  }

  @override
  Future<UserModel?> fetchsingleUserFromFirebase(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching single user: $e");
    }
    return null; //it will return null if there is no user
  }

  @override
  Future<List<UserModel>> addUsersToFirebase(
    String fullName,
    String email,
    String phoneNumber,
    String password,
    UserRole role,
  ) async {
    List<UserModel> userList = [];
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user model object
      UserModel newUser = UserModel(
        userId: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        role: role, // Assign default role
        userDeviceToken: '',
        userImg: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        password: password,
      );

      // Save user data in Firestore
      await firebaseFirestore
          .collection('users')
          .doc(newUser.userId)
          .set(newUser.toMap());

      // Fetch updated list of users from Firestore
      userList = await fetchUsersFromFirebase();
    } catch (e) {
      print("Error adding user: $e");
    }
    return userList;
  }

  @override
  Future<List<UserModel>> deleteUser(String userId) async {
    List<UserModel> userList = [];
    try {
      // Delete the user from Firestore
      await firebaseFirestore.collection('users').doc(userId).delete();

      // Optionally, you can also delete the user from Firebase Authentication if needed
      User? user = firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }

      // Fetch the updated list of users
      userList = await fetchUsersFromFirebase();
    } catch (e) {
      print("Error deleting user: $e");
    }
    return userList;
  }
}
