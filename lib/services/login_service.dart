import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginService {
  Future<void> signInToGoogleAccount() async {
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? auth = await user?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: auth!.accessToken, idToken: auth.idToken);
      FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<User> getCredentialsFromGoogleAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print("user ${user!.displayName}");
      return user;
    } catch (e) {
      throw Exception('from user credential : No user signed in');
    }
  }

  Future<bool> isUserLoggedIn() async {
    return await GoogleSignIn().isSignedIn();
  }

  Future<bool> logoutUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
