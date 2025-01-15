import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  /// Login with Email and Password
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null || user.email == null) {
      throw Exception('User or email is null after login');
    }
    return user;
  }

  /// Register with Email and Password
  Future<User> registerWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null || user.email == null) {
      throw Exception('User or email is null after registration');
    }
    return user;
  }

  /// Login with Google
  Future<User> loginWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in canceled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null || user.email == null) {
      throw Exception('User or email is null after Google login');
    }
    return user;
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Logout
  Future<void> logout() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
  
}
