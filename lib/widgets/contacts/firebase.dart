import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethods {
  //* Create
  Future<void> addContact(
      Map<String, dynamic> contactDetails, String id) async {
    await FirebaseFirestore.instance
        .collection('Contacts')
        .doc(id)
        .set(contactDetails);
  }

  //* Read
  Future<Stream<QuerySnapshot>> getContactList() async {
    return FirebaseFirestore.instance.collection('Contacts').snapshots();
  }

  //* Delete
  Future<void> deleteContact(String id) async {
    await FirebaseFirestore.instance.collection('Contacts').doc(id).delete();
  }
}
