import 'package:flutter/material.dart';
import 'package:ecommerce_app/config/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/signup_bloc.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/signup";

  final Authentication _authentication = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  SignUpScreen({super.key}); // Added

  Future<void> _signUp(BuildContext context) async {
    final name = _nameController.text.trim(); // Get name from text field
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await _authentication.signUp(email, password, name); // Pass name to signUp method

      // Show success message in a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('You have successfully signed up.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pop(context); // Close the signup screen and go back to the login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Use the button color from the theme
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error Signing Up'),
            content: const Text('An error occurred while signing up.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Use the button color from the theme
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      print('Error signing up: $e');
    }
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state){
          if (state is SignUpLoading){
            return const CircularProgressIndicator();
          } else if (state is SignUpSuccess){
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('You have successfully signed up.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pop(context); // Close the signup screen and go back to the login screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Use the button color from the theme
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          } else if (state is SignUpFailure){
            return AlertDialog(
              title: const Text('Error Signing Up'),
              content: const Text('An error occurred while signing up.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Use the button color from the theme
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: "Enter your Name",
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },


                    ),// Adjust as needed
                    const SizedBox(height: 20,),

                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }

                          final RegExp emailRegex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email address';
                          }

                          return null;
                        },


                      ),
                    ),
                    const SizedBox(height: 20), // Adjust as needed
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: "Enter your password",
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
                        suffixIcon: const Icon(
                          Icons.password,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Adjust as needed
                    SizedBox(
                      width: double.infinity, // Constrain the width to match parent width
                      child: ElevatedButton(
                        onPressed: () => _signUp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange, // Use the button color from the theme
                          padding: const EdgeInsets.symmetric(vertical: 15), // Keep vertical padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Adjust as needed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 30,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // Adjust as needed
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


