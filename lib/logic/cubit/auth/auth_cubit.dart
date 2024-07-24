import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/models/user_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/grocery_list_firestore.dart';
import 'package:fridge_to_feast/repositary/share_preferences/user_credentials_share_preferences.dart';
import 'package:fridge_to_feast/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  LoginService userLogin = LoginService();
    GroceryListFireStore gf = GroceryListFireStore();
  LocalRepo repo = LocalRepo();
  AuthCubit() : super(AuthAuthenticatedState());

  Future<void> login({required context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      await userLogin.signInToGoogleAccount();
      if (await userLogin.isUserLoggedIn()) {
        // will make condition true in share preferences
        await sharedPreferences.setBool(AuthKeys.LOGGEDIN, true);
        saveDetails();
        // gf.initializingDatabase();  
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void saveDetails() {
    try {
      FirebaseAuth.instance.idTokenChanges().listen((User? user) {
        if (user != null) {
          repo.saveUserCredentiails(
            userName: user.displayName.toString(),
            userEmail: user.email.toString(),
            userProfileUrl: user.photoURL.toString(),
            user_id: user.uid.toString(),
          );
        }
      });
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      emit(AuthLoadingState());
      return await repo.getUserCredentials();
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
    return null;
  }

  Future<bool> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      await userLogin.logoutUser();
      if (await userLogin.isUserLoggedIn() == false) {
        await sharedPreferences.setBool(AuthKeys.LOGGEDIN, false);
        emit(AuthAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
    return false;
  }

  Future<bool?> isSignInDone() {
    return repo.signInDone();
  }
}
