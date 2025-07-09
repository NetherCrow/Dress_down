import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/button.dart';
import 'components/my_textfield.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage ({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {

    //show loading circle
    showDialog(context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      //check if passwords match
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        //passwords don't match
        showErrorMessage('Passwords don\'t match!');
      }
      //pop
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //wrong email
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(
                'error',
                style: TextStyle(color: Colors.white),
              )
          ),
        );
      },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //LOGO
                ClipRRect(
                  borderRadius: BorderRadius.circular(119),
                  child: Image.asset(
                    'assets/images/dressdown.png',
                    width: 97,
                    height: 97,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 30),

                //hello again
                Text(
                  'Welcome to Dress Down',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                SizedBox(height: 30),

                //email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 10),

                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: false,
                ),

                const SizedBox(height: 40),

                //Login button
                Button(text: 'Create Account', onTap: signUserUp),

                //not a member? register now
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage(onTap: () {  },);
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}