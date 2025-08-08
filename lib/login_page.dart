import 'package:dress_down_2/services/user_service.dart';
import 'package:flutter/material.dart';
import 'components/button.dart';
import 'components/my_textfield.dart';
import 'forgot_pw_page.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRemembered();
  }

  Future<void> _loadRemembered() async {
    final data = await UserService.loadLoginState();

    if (!mounted) return;

    setState(() {
      _rememberMe = data['rememberMe'];
      emailController.text = data['email'];
    });
  }

  Future<void> signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final error = await UserService.signInUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (error != null) {
      _showError(error);
    } else {
      await UserService.saveLoginState(emailController.text.trim(), _rememberMe);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(119),
                  child: Image.asset(
                    'assets/images/dressdown.png',
                    width: 207,
                    height: 207,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Welcome Back',
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgotPwPage()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: colorScheme.primary,
                      onChanged: (val) {
                        setState(() => _rememberMe = val ?? false);
                      },
                    ),
                    Text('Remember Me', style: textTheme.bodyMedium),
                  ],
                ),

                const SizedBox(height: 20),
                Button(text: 'Login', onTap: signUserIn),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?', style: textTheme.bodyMedium),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

