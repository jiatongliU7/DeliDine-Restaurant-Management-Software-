import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../firebase/db.dart';
import 'employee.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber =
  PhoneNumber(isoCode: 'US'); // Set the initial country code as needed

  @override
  initState() {
    super.initState();
    print(widget.employee.phoneNumber);
    _phoneController.text = widget.employee.phoneNumber;
  }

  updateInfo() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    widget.employee.phoneNumber = _phoneController.text;


    Map<String, dynamic> userInfo = {
      'phoneNumber': _phoneController.text.trim(),
    };

    buildLoading();
    editUserInfo(userInfo).then((value) {
      Navigator.of(context).pop();
      snapBarBuilder('Phone Number was edited');
    });
  }

  buildLoading() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0xFF68A268),
        toolbarHeight: 80,
        // Set the desired height
        title: SizedBox(
          height: 80, // Adjust the height as needed
          width: double.infinity, // Set width to occupy the full space
          child: Image.asset(
            'assets/logo.png',
            // fit: BoxFit.fitWidth, // Use 'contain' for fitting the image within the container
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 20),
          child: Column(
            children: [
              const Text(
                "Contact",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(9, 71, 82, 1.0)),
              ),
              Container(
                height: 3,
                color: const Color.fromRGBO(80, 80, 74, 1.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    _phoneNumber = number;
                  },
                  textFieldController: _phoneController,
                  inputDecoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  initialValue: _phoneNumber,
                  inputBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                    onPressed: updateInfo,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF68A268)),
                    child: const Text(
                      'Update Contact',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )),
    );
  }
}