import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/my_textfield.dart';

class ForgotPwPage extends StatefulWidget {
  const ForgotPwPage({Key? Key}) : super(key: Key);

  @override
  State<ForgotPwPage> createState() => _ForgetPwPageState();
}

class _ForgetPwPageState extends State<ForgotPwPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(backgroundColor: Colors.deepPurple[200]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Enter your Email and we will send you a password reset link",
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 0),

          //email textfield
          MyTextField(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 10),

          //Reset Password
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(35),
            ),
            child: MaterialButton(
              onPressed: passwordReset,
              color: Colors.black,
              child: Text(
                "Reset Password",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
