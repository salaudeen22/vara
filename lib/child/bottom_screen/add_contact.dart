import 'package:flutter/material.dart';
import 'package:vara/components/primarybutton.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:vara/child/bottom_screen/contacts_page.dart';
import 'package:vara/db/db_service.dart';
import 'package:vara/model/contactsm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact> contactList = [];
  int count = 0;

  void showList() async {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
      databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result == 1) {
      Fluttertoast.showToast(msg: "Contact removed");
      showList();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            PrimaryButton(
              title: "Add Trusted Contact",
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
                if (result == true) {
                  showList();
                }
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(contactList[index].name),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              try {
                                await FlutterPhoneDirectCaller.callNumber(contactList[index].number);
                              } catch (e) {
                                print('Error making call: $e');
                                Fluttertoast.showToast(msg: 'Error making call');
                              }

                            },
                            icon: Icon(Icons.call),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteContact(contactList[index]);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
