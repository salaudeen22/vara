import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:vara/utility/constants.dart';

import 'package:vara/model/contactsm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:vara/db/db_service.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController searchControler = TextEditingController();
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    askPermission();
  }

  getAllContacts() async {
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+) | \D'), (Match m) {
      return m[0] == '+' ? '+' : ' ';
    });
  }

  filterContact() {
    contactsFiltered.clear(); // Clear the previous filtered list
    contactsFiltered.addAll(contacts.where((element) {
      String searchTerm = searchControler.text.toLowerCase();
      String searchTermFlattrn = flattenPhoneNumber(searchTerm);
      String contactName = element.displayName!.toLowerCase();

      bool nameMatch = contactName.contains(searchTerm);
      if (nameMatch) {
        return true;
      }
      if (searchTermFlattrn.isEmpty) {
        return false;
      }

      var phone = element.phones?.firstWhere(
        (p) {
          String phnFlattened = flattenPhoneNumber(p.value!);
          return phnFlattened.contains(searchTermFlattrn);
        },
        orElse: () =>
            Item(), // Provide a default Item or adjust according to your logic
      );

      return phone != null && phone.value != null;
    }));
  }

  Future<void> askPermission() async {
    PermissionStatus permissionStatus = await getContactsPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchControler.addListener(() {
        filterContact();
      });
    } else {
      handInvalidPermissions(permissionStatus);
    }
  }

  handInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialgoue(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialgoue(context, "May contact does not exist on this device");
    }
  }

  Future<PermissionStatus> getContactsPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;
    if (permissionStatus != PermissionStatus.granted &&
        permissionStatus != PermissionStatus.permanentlyDenied) {
      PermissionStatus newPermissionStatus =
          await Permission.contacts.request();
      return newPermissionStatus;
    } else {
      return permissionStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearhing = searchControler.text.isNotEmpty;
    bool listItemExit = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
        body: contacts.length == 0
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: "Search contact",
                          prefixIcon: Icon(Icons.search)),
                      controller: searchControler,
                    ),
                  ),
                  listItemExit == true
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isSearhing
                                ? contactsFiltered.length
                                : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = isSearhing
                                  ? contactsFiltered[index]
                                  : contacts[index];
                              return ListTile(
                                title: Text(contact.displayName ?? ''),
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  backgroundImage: MemoryImage(contact.avatar!),
                                ),
                                onTap: () {
                                  if (contact.phones!.length > 0) {
                                    final String phoneNum =
                                        contact.phones!.elementAt(0).value!;
                                    final String name = contact.displayName!;
                                    _addContact(TContact(phoneNum, name));



                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "phone does not exists");

                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          child: Text("Searching"),
                        )
                ]),
              ));
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);

    if (result != 0) {
      Fluttertoast.showToast(msg: "contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "contact failed to add");
    }
    Navigator.of(context).pop(true);
  }
}
