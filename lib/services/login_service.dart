import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginService{

  String? name =" ";
  String email =" ";

   googleSignIn()async{
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth!.accessToken,
      idToken: auth.idToken
    );


    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  isUserLoggedIn()async{
     FirebaseAuth.instance.userChanges().listen((user){
      if(user == null){
        print("User is logged out");
      }else{
        print("User is logged in");

      }
    });
   
  }

  logoutUse()async{
    final FirebaseAuth auth =  FirebaseAuth.instance;
    auth.signOut();

     final GoogleSignInAccount? user = await GoogleSignIn().signOut();
    if(user == null){
       print("User is logged out");
      }else{
        print("User is logged in");

      }
    //  if(auth == null){
    //     print("User is logged out");
    //   }else{
    //     print("User is logged in");

    //   }
  }
}


/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginService{
  GoogleSignInAccount? userSignIn;
   GoogleSignInAuthentication? auth;
  final FirebaseAuth? instance;
  OAuthCredential? credential;

  LoginService({required this.userSignIn, required this.auth, required this.instance, required this.credential});
  // String? _accessToken;
  // String? _idToken;

 void  googleSignIn()async{
   try{
    userSignIn = await GoogleSignIn().signIn();
    auth = await userSignIn?.authentication;

    // _accessToken = auth!.accessToken;
    // _idToken = auth!.idToken;
   }catch(e){
    throw  Exception(e);
   }
  }

   isUserLoggedIn(){
    print("in login");
     instance!.userChanges().listen((user){
      if(user == null){
     print(user);
      }
    });
  }


  void logoutUse()async{
  try{
    instance!.signOut();
  }catch(e){
    throw Exception(e);
  }
  }

  void saveUserCredential(){
    try{
      credential = GoogleAuthProvider.credential(
      accessToken: auth!.accessToken,
      idToken: auth!.idToken

    );
    print("tokeennnnnnnnnn");
      print(credential);
    }catch(e){
      throw Exception(e);
    }
  }
}

*/