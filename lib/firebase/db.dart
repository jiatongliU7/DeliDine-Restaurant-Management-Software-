import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';

String collection = 'restaurant';

Future<Map?> getUsersInfo() async {
  Map? data;

  await FirebaseFirestore.instance
      .collection(collection)
      .doc('users')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map;
      // print('Document data: ${data}');
    } else {
      print('Document does not exist on the database');
      return null;
    }
  });

  return data;
}

Future<Map?> getMyInfo() async {
  String uid = AuthenticationHelper().uid;
  Map? info;
  Map? data = await getUsersInfo();
  if (data != null) {
    info = data[uid];
  }
  return info;
}

Future<bool> editUserInfo(Map<String, dynamic> data) async {
  String uid = AuthenticationHelper().uid;
  FirebaseFirestore.instance
      .collection(collection)
      .doc('users')
      .set({uid: data}, SetOptions(merge: true));
  return true;
}

Future<bool> addEvents(Map data, String uid) async {

  FirebaseFirestore.instance
      .collection(collection)
      .doc('users')
      .set({uid: data}, SetOptions(merge: true));
  return true;
}