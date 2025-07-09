import 'package:dress_down_2/register_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class IntroPage extends StatelessWidget {
  final Function()? onTap;

  const IntroPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),

              //logo
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(78),
                  child: Image.asset(
                    'assets/images/dressdown.png',
                    width: 332,
                    height: 332,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              //written text under logo
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 36),
                  children: [
                    TextSpan(text: "Welcome\n\n"),
                    TextSpan(
                      text: "Your security and welfare is our priority",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              //buttons
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Login button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(onTap: () {}),
                        ),
                      );
                    },
                    child: Text('Login'),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "or",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(onTap: () {}),
                        ),
                      );
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
