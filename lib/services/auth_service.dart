import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user/user_login.dart';
import '../utils/api_url.dart';

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
          Uri.parse('$currentApi/google/login'),
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

  Future<UserLogin?> signInWithApple() async {
    // final appleProvider = AppleAuthProvider();
    // appleProvider.addScope('email');
    // final result = await _auth.signInWithProvider(appleProvider);
    String? displayName;
    String? userEmail;

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final authResult = await _auth.signInWithCredential(oauthCredential);

      if (appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        displayName =
            "${appleCredential.givenName} ${appleCredential.familyName}";
      }
      userEmail = appleCredential.email;

      final firebaseUser = authResult.user;
      // print("Apple auth uid:  ${appleCredential.userIdentifier}");
      // print("Apple auth name:  $displayName");
      // print("Apple auth email:  $userEmail");
      // print("________________________________________");

      if (userEmail != null && displayName != null) {
        await firebaseUser!.updateDisplayName(displayName);
        await firebaseUser.updateEmail(userEmail);

        final response = await http.post(
          Uri.parse('$currentApi/apple/login'),
          body: {
            'apple_id': appleCredential.userIdentifier,
            'email': userEmail,
            'name': displayName,
          },
        );

        if (response.statusCode == 200) {
          String responseString = response.body;
          // if (mounted) Navigator.pop(context);
          return userLoginFromJson(responseString);
        } else {
          throw Fluttertoast.showToast(
            msg: "กรุณาทำการเข้าสู่ระบบใหม่",
            timeInSecForIosWeb: 5,
          );
        }
      } else {
        final response = await http.post(
          Uri.parse('$currentApi/apple/login'),
          body: {
            'apple_id': appleCredential.userIdentifier,
          },
        );

        if (response.statusCode == 200) {
          String responseString = response.body;
          // if (mounted) Navigator.pop(context);
          return userLoginFromJson(responseString);
        } else {
          throw Fluttertoast.showToast(
            msg: "กรุณาทำการเข้าสู่ระบบใหม่",
            timeInSecForIosWeb: 5,
          );
        }
      }
      // print(response.body);
    } catch (e) {
      // print(e);
      return null;
    }
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
