import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurantsoftware/employee/employee.dart';


class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;
  get uid => user?.uid;

  // Creates a new user with email and password
  Future signUp({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String role,
    required String phoneNumber
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Employee employee = Employee(
        name: name,
        lastName: lastName,
        email: email,
        role: role,
        uid: userCredential.user?.uid ?? '',
      );

      await employee.saveToFirestore();

      // Explicitly sign in the user after sign-up
      await signIn(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }

  // Get User Role
  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc['role'];
    }
    return null;
  }
}
