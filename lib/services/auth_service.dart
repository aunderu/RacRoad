import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/user_login.dart';

const url = "https://api.racroad.com/api";

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Future<UserLogin?> signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) return null;

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await signInAccount.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    try {
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        final response = await http.post(
          Uri.parse('$url/google/login'),
          body: {
            'email': user.email,
            'name': user.displayName,
            'avatar': user.photoURL ?? "no user profile",
          },
        );
        // print(response.body);

        if (response.statusCode == 200) {
          String responseString = response.body;
          // if (mounted) Navigator.pop(context);

          return userLoginFromJson(responseString);
        } else {
          // if (mounted) Navigator.pop(context);
          throw Fluttertoast.showToast(msg: "กรุณาทำการเข้าสู่ระบบใหม่");
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn().signOut(),
      sharedPreferences.clear(),
    ]);
  }

}
