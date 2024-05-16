import 'package:flutter/material.dart';
import 'package:restaurantsoftware/employee/employee.dart';
import '../firebase/authentication.dart';
import '../firebase/db.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text('Register a New Employee',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignupForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController(); // New phone number controller
  TextEditingController password = TextEditingController();
  String? selectedRole; // Variable to hold the selected role
  List<String> roles = [
    'Manager',
    'Chef',
    'Waiter',
    'Cleaner'
  ]; // List of roles
  bool _obscureText = false;
  bool agree = false;

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    var space = const SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Name',
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.text,
            ),
            space,
            TextFormField(
              controller: lastName,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Last Name',
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.text,
            ),
            space,
            TextFormField(
              controller: phoneNumber, // Phone number field
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Phone Number',
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
            ),
            space,
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            space,
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: border,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: !_obscureText,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            space,
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: border,
              ),
              obscureText: true,
              validator: (value) {
                if (value != password.text) {
                  return 'Password does not match';
                }
                return null;
              },
            ),
            space,
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Select Role',
                border: border,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
              validator: (value) =>
              value == null ? 'Please select a role' : null,
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            space,
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    AuthenticationHelper()
                        .signUp(
                        email: email.text.trim(),
                        password: password.text.trim(),
                        name: name.text.trim(),
                        lastName: lastName.text.trim(),
                        role: selectedRole.toString(),
                        phoneNumber: phoneNumber.text.trim() // Pass phone number
                    )
                        .then((result) {
                      try {
                        if (result) {
                          if (selectedRole == 'Manager') {
                            editUserInfo({'role': selectedRole});
                          } else {
                            String uid = AuthenticationHelper().uid;
                            Employee employee = Employee(
                                name: name.text.trim(),
                                lastName: lastName.text.trim(),
                                email: email.text.trim(),
                                role: selectedRole,
                                uid: uid,
                                phoneNumber: phoneNumber.text.trim() // Set phone number
                            );
                            editUserInfo(employee.toMap());
                            reset_info();
                          }
                          snapBarBuilder('User has been added');
                        }
                      } catch (e) {
                        snapBarBuilder(result);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF68A268),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                child: const Text(
                  'Add User',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  void reset_info() {
    name.text = '';
    lastName.text = '';
    phoneNumber.text = ''; // Reset phone number
    email.text = '';
    selectedRole = null;
    password.text = '';
  }
}
