import 'package:app/firebase_auth_error.dart';
import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  Future<FirebaseAuthResultStatus> signInEmail(
      String email, String password) async {
    FirebaseAuthResultStatus result;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('succeed');
      if (userCredential.user! == null) {
        result = FirebaseAuthResultStatus.Undefined;
      } else {
        result = FirebaseAuthResultStatus.Successful;
      }
    } catch (e) {
      // result = FirebaseAuthExceptionHandler.handleException(e);
      result = FirebaseAuthResultStatus.Undefined;
    }
    return result;
  }

  void _showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(message!),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formPWKey = GlobalKey<FormState>();

    TextEditingController _email = new TextEditingController();
    TextEditingController _password = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    hintText: 'Email',
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                hintText: 'password',
              ),
            )),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 1.0,
            ),
            child: Text(
              'login',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              _formKey.currentState!.validate();
              final FirebaseAuthResultStatus signInResult =
                  await signInEmail(_email.text, _password.text);
              if (signInResult != FirebaseAuthResultStatus.Successful) {
                final errorMessage = exceptionMessage(signInResult);

                _showErrorDialog(context, errorMessage);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful')));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: 'My Home Page')));
              }
            },
          ),
        ]),
      ),
    );
  }
}
