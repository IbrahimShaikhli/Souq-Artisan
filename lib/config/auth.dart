import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  // Sign up with email and password
  Future<UserCredential?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a user document in the "users" collection
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name, // Add the name field
        // You can add more fields here as needed
      });



      return userCredential;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }


  // Log in with email and password
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
    }
  }

  // Log in with Google
  Future<UserCredential?> signInWithGoogleAndCreateUserDoc() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Create a user document in the "users" collection
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          // Add other user data as needed
        });
      }

      return userCredential;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  // Log out
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
