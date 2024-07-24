import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalRepo {
  void saveUserCredentiails(
      {required String userName,
      required String userEmail,
      required String userProfileUrl,
      required String user_id}) async {
        SharedPreferences sharePref = await SharedPreferences.getInstance();
        sharePref.setString(AuthKeys.USER_ID, user_id);
    final DocumentReference<Map<String, dynamic>> _userDetails =
        FirebaseFirestore.instance.collection("users").doc(user_id);
    try {
      _userDetails.set({
        "name": userName,
        "email": userEmail,
        "user_image": userProfileUrl,
      });
    } catch (e) {
      throw Exception("User Data not saved: $e");
    }
  }

  Future<UserModel> getUserCredentials() async {
      SharedPreferences sharePref = await SharedPreferences.getInstance();
       final uid =  sharePref.getString(AuthKeys.USER_ID);
    final CollectionReference<Map<String, dynamic>> _uid =
        FirebaseFirestore.instance.collection("users");

    final userDetails = await _uid.doc(uid.toString()).get();

    return UserModel(
        name: userDetails["name"] ?? "User Name not found",
        email: userDetails["email"] ?? "Email not found",
        profileUrl: userDetails["user_image"] ?? userDetails["name"].toString()[0].toUpperCase());
  }

  Future<bool?> signInDone() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getBool(AuthKeys.LOGGEDIN);
  }
}
