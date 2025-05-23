import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this for current user UID
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:safe/components/custom_button.dart';
import 'package:safe/widgets/contacts/firebase.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  //* Add contact
  uploadContact() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 400,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('Fill Details'),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  hintText: 'Enter Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Add Contact",
                onPressed: () async {
                  if (nameController.text.trim().isEmpty ||
                      numberController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please fill in all fields");
                    return;
                  }

                  String id = randomAlphaNumeric(9);
                  String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

                  Map<String, dynamic> details = {
                    "id": id,
                    "uid": uid,
                    "Name": nameController.text.trim(),
                    "Number": numberController.text.trim(),
                  };

                  await FirebaseMethods().addContact(details, id).then((value) {
                    Fluttertoast.showToast(msg: "Contact Added");
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Edit contact
  void _editContactDialog(BuildContext context, String docId, String currentName, String currentNumber) {
    final nameController = TextEditingController(text: currentName);
    final numberController = TextEditingController(text: currentNumber);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text('Edit Contact'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                hintText: 'Enter Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Update Contact",
              onPressed: () async {
                if (nameController.text.trim().isEmpty || numberController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please fill in all fields");
                  return;
                }

                Map<String, dynamic> updatedData = {
                  "Name": nameController.text.trim(),
                  "Number": numberController.text.trim(),
                };

                await FirebaseFirestore.instance
                    .collection('Contacts')
                    .doc(docId)
                    .update(updatedData);

                Fluttertoast.showToast(msg: "Contact Updated");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //* Read Data
  Stream? contactsStream;

  getAllList() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    contactsStream = FirebaseFirestore.instance
        .collection('Contacts')
        .where('uid', isEqualTo: uid)
        .snapshots();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllList();
  }

  //* Store data locally
  List<Map<String, dynamic>> phoneBook = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              uploadContact();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Contacts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: contactsStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Contacts Found',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      final data = ds.data() as Map<String, dynamic>?;

                      final name = (data?['Name'] ?? '').toString().trim();
                      final number = (data?['Number'] ?? '').toString().trim();

                      if (name.isEmpty && number.isEmpty) {
                        return const SizedBox.shrink(); // Skip bad docs
                      }

                      phoneBook.add({
                        "Name": name,
                        "Number": number,
                      });

                      return Dismissible(
                        key: Key(ds.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) async {
                          await FirebaseMethods().deleteContact(ds.id);
                          Fluttertoast.showToast(msg: "Contact Deleted");
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              name.isNotEmpty ? name : 'Unnamed',
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              number.isNotEmpty ? number : 'No number',
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              _editContactDialog(
                                  context,
                                  ds.id,
                                  name,
                                  number
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
