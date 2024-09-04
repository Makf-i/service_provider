import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isAuthenticating = false;
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  final _form = GlobalKey<FormState>(); //for form

  //submitting the form
  void _submit() async {
    final isValid = _form.currentState!
        .validate(); //returns a boolean, true if no error popped when validating the input fields of form

    if (!isValid) {
      return; //simply return means code below this line wont be executed
    }

    _form.currentState!
        .save(); //save(): This method calls the onSaved callbacks for each form field, which allows you to capture the values entered into the form fields.

    try {
      //if there is no error then we are authenticating the user
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        //logging users in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        //creating new users
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('service providers')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'role': 'service provider'
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
          ),
        );
      } else if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already in use'),
          ),
        );
      } else if (error.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network Error'),
          ),
        );
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Password'),
          ),
        );
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 500, right: 500),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    if (!_isLogin) Text("Create new Account"),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'email'),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!_isLogin)
                      // inputting email from user
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'username'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length < 4) {
                            return 'Please enter atleast 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredUsername = value!;
                        },
                      ),
                    const SizedBox(height: 16),
                    //inputting password from user
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'password'),
                      obscureText: true, //hides the characters
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 6) {
                          return 'Password must be atleast six characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_isAuthenticating) const CircularProgressIndicator(),
                    if (!_isAuthenticating)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        onPressed: _submit,
                        //if logging in then label will be login or else signup
                        child: Text(_isLogin ? "LogIn" : "SignUp"),
                      ),
                    if (!_isAuthenticating)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            if (!_isLogin) {
                              _form.currentState!.reset();
                            }
                          });
                        },
                        child: Text(_isLogin
                            ? "new Account"
                            : "already have an account"),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
