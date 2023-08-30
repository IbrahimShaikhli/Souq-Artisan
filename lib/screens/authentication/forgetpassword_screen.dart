import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/config/auth.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static String routeName = "/forget_password";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Authentication _authentication = Authentication();
  final TextEditingController _emailController = TextEditingController();

  ForgetPasswordScreen({super.key});

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Show success message or navigate to confirmation screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
      // Navigate back to the login screen
      Navigator.pop(context);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        // Show message for non-existing email
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email Not Found'),
              content: const Text('The entered email does not exist.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
                  child: const Text('OK'), // Match button color with theme
                ),
              ],
            );
          },
        );
      } else {
        // Show general error message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error Resetting Password'),
              content: const Text('An error occurred while resetting your password.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
                  child: const Text('OK'), // Match button color with theme
                ),
              ],
            );
          },
        );
      }
      print('Error resetting password: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0), // Adjust vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Enter your email address to reset\n your password',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "Enter your email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  suffixIcon: const Icon(Icons.mail, color: Colors.grey),
                ),
                // Add your validation logic here
                // validator: (value) {
                //   // Your validation logic
                //   return null;
                // },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _resetPassword(context), // Call the reset function
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add navigation logic to your sign-up screen
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
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
