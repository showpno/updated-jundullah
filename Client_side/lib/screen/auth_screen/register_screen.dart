import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexara_cart/screen/auth_screen/login_screen.dart';
import 'package:nexara_cart/utility/extensions.dart';

import '../../utility/functions.dart';
import '../../utility/snack_bar_helper.dart';
import '../../utility/app_color.dart';
import 'components/login_button.dart';
import 'components/login_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  signUserUp() async {
    if (!mounted) return;
    
    showLoadingDialog(context);

    try {
      final result = await context.userProvider.register();
      
      if (!mounted) return;
      
      // Pop the loading dialog first
      Navigator.of(context).pop();

      // Wait a frame for the dialog to close
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      if (result == null) {
        // Clear controllers
        context.userProvider.emailController.clear();
        context.userProvider.passwordController.clear();
        context.userProvider.passwordController2.clear();

        // Show success message
        SnackBarHelper.showSuccessSnackBar('Registration successful!');

        // Navigate to login after showing snackbar
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          // Use GetX navigation since we're using GetMaterialApp
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted) {
            Get.offAll(() => const LoginScreen());
          }
        }
      } else {
        // Show error message
        SnackBarHelper.showErrorSnackBar(result);
      }
    } catch (error) {
      // Handle any errors
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        SnackBarHelper.showErrorSnackBar('An error occurred during registration: ${error.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // logo
                Image.asset(
                  'assets/images/jundullah_logo.png',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 25),

                // welcome text
                Text(
                  'Welcome to Jundulah Family!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                // email textfield
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

                // confirm password textfield
                LoginTextField(
                  controller: context.userProvider.passwordController2,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                LoginButton(
                  onTap: signUserUp,
                  buttonText: 'Sign Up',
                ),

                const SizedBox(height: 50),

                // already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Use GetX navigation since we're using GetMaterialApp
                        Get.offAll(() => const LoginScreen());
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: AppColor.primary,
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