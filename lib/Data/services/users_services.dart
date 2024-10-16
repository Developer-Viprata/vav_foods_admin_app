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
}
