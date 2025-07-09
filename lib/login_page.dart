import 'package:dress_down_2/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/button.dart';
import 'components/my_textfield.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
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
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(
                message,
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
                    width: 207,
                    height: 207,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 30),

                //hello again
                Text(
                  'Welcome Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                SizedBox(height: 20),

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
                  obscureText: true,
                ),

                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPwPage();
                                },
                          ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                //Login button
                Button(text: 'Login', onTap: signUserIn),

                //not a member? register now
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegisterPage(onTap: () {  },);
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
