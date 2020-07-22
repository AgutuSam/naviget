import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signInWithFireBaseAuth({String email, String password});
  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithFacebook();
  Future<FirebaseUser> currentUser();
  Future<void> signOutFireBaseAuth();
  Future<void> signOutGoogle();
  Future<void> signOutFacebook();
}

class Auth extends BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookLogin _facebookSignIn = FacebookLogin();

//*************EmailPassword Sign*************
  //signIn
  Future<FirebaseUser> signInWithFireBaseAuth(
      {String email, String password}) async {
    AuthResult res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = res.user;
    return user;
  }

  //signOut
  Future<void> signOutFireBaseAuth() async {
    return await _auth.signOut();
  }

//*************Google Sign*************
  //signIn
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  //signOut
  Future<void> signOutGoogle() async {
    return await _googleSignIn.signOut();
  }

//*************Facebook*************
  //signIn
  Future<FirebaseUser> signInWithFacebook() async {
    final FacebookLoginResult result =
        await _facebookSignIn.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = result.accessToken;
    AuthCredential authCredential = FacebookAuthProvider.getCredential(
        accessToken: facebookAccessToken.token);
    FirebaseUser user = (await _auth.signInWithCredential(authCredential)).user;
    //Token: ${accessToken.token}

    return user;
  }

  //signOut
  Future<void> signOutFacebook() async {
    return await _facebookSignIn.logOut();
  }

//*************Current User*************
  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }
}
