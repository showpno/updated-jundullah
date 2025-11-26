import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexara_cart/screen/auth_screen/register_screen.dart';
import 'package:nexara_cart/utility/extensions.dart';

import '../../utility/functions.dart';
import '../../utility/snack_bar_helper.dart';
import '../home_screen.dart';
import 'components/login_button.dart';
import 'components/login_textfield.dart';
import 'components/square_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  signUserIn() async {
    if (!mounted) return;
    
    showLoadingDialog(context);

    try {
      final result = await context.userProvider.login();
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Wait a frame for the dialog to close
      await Future.delayed(const Duration(milliseconds: 100));

      if (result == null) {
        // Login successful
        context.userProvider.emailController.clear();
        context.userProvider.passwordController.clear();
        context.userProvider.passwordController2.clear();

        if (mounted) {
          // Use GetX navigation since we're using GetMaterialApp
          // Wait a bit more to ensure dialog is fully closed
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted) {
            Get.offAll(() => const HomeScreen());
          }
        }
      } else {
        // Login failed
        SnackBarHelper.showErrorSnackBar(result);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        SnackBarHelper.showErrorSnackBar('An error occurred: ${e.toString()}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkServerConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // logo
                Image.asset(
                  'assets/images/jundullah_logo.png',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 30),

                // welcome back, you've been missed!
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // username textfield
                LoginTextField(
                  controller: context.userProvider.emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  controller: context.userProvider.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // sign in button
                LoginButton(
                  onTap: signUserIn,
                  buttonText: 'Sign In',
                ),

                const SizedBox(height: 30),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // google + apple sign in buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'assets/images/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'assets/images/apple.png')
                  ],
                ),

                const SizedBox(height: 30),

                // not a member? register now
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
