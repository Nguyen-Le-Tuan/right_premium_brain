import 'package:firebase_auth/firebase_auth.dart';
import 'package:right_premium_brain/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "user-not-found";
      } else if (e.code == 'wrong-password') {
        return "wrong-password";
      } else {
        print(e);
        return "user-not-found";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await DatabaseService().addUserData(userCredential.user!.uid);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "email exists";
      }
      return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<void> deleteUser(String passwordValue) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: passwordValue);
      try {
        await user.reauthenticateWithCredential(credential);
        await DatabaseService().deleteAccount();
        await user.delete();
        print("user deleted");
      } catch (e) {
        print("error: $e");
      }
    }
  }

  Future<bool> checkPassword(String oldPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        var authResult = await user.reauthenticateWithCredential(credential);
        return authResult != null;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> editPassword(String newPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Successful";
    } on FirebaseAuthException catch (e) {
      print(e);
      return "error";
    }
  }
}
