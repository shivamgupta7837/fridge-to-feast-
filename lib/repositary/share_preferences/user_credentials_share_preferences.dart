import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepo {
  void saveUserCredentiails(
      {required String userName,
      required String userEmail,
      required String userProfileUrl}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    await prefs.setString(AuthKeys.NAME_KEY, userName);
    await prefs.setString(AuthKeys.EMAIL_KEY, userEmail);
    await prefs.setString(AuthKeys.PROFILE_URL, userProfileUrl);
    }catch(e){
      throw  Exception("User Data not saved: $e");
    }
  }

  Future<UserModel> getUserCredentials()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   
      String?  name = prefs.getString(AuthKeys.NAME_KEY);
      String? email  = prefs.getString(AuthKeys.EMAIL_KEY);
      String? profileUrl =  prefs.getString(AuthKeys.PROFILE_URL);
      
     return UserModel(name: name ?? "User Name not found", email: email ?? "Email not found", profileUrl: profileUrl ?? name.toString()[0].toUpperCase() );
  }

  Future<bool?> signInDone()async{
    final SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
    return  sharedPreferences.getBool(AuthKeys.LOGGEDIN);

  }
}
