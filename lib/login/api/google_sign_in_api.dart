import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static Future<GoogleSignIn> handleSignIn() async {
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
      return _googleSignIn;
    }

  static Future handleSignOut() => _googleSignIn.disconnect();
}
