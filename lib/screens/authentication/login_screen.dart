import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/screens/authentication/signup_screen.dart';
import 'package:ecommerce_app/screens/authentication/forgetpassword_screen.dart';
import 'package:ecommerce_app/widgets/bottom_nav_bar.dart';
import 'package:ecommerce_app/config/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/screens/authentication/bloc/login_bloc.dart';

import '../../consts/colors.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final _auth = Authentication();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;
  bool _rememberMe = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.close(); // Close the LoginBloc to prevent memory leaks
    super.dispose();
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null) {
      _emailController.text = savedEmail;
      setState(() {
        _rememberMe = true;
      });
    }

    if (savedPassword != null) {
      _passwordController.text = savedPassword;
    }
  }

  void _validateForm(BuildContext context) {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      // Dispatch a LoginButtonPressed event to the LoginBloc
      _loginBloc.add(LoginButtonPressed(email: email, password: password));

      _auth.login(email, password).then((userCredential) async {
        if (userCredential != null) {
          if (_rememberMe) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', email);
            prefs.setString('password', password);
          }

          try {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          } catch (e) {
            print('Navigation Error: $e');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User does not exist')),
          );
        }
      }).catchError((e) {
        print('Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: blackColor,
          ),
        ),
        centerTitle: true,
      ),
      body:BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state){
          if (state is LoginInitial){
            // Return your initial UI here
            return  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Sign in with your email\n or continue with social media',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                              errorText: _emailErrorText,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!_isValidEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
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
                              errorText: _passwordErrorText,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text('Remember Me'),
                              const Spacer(),
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
                                },
                                child: const Text(
                                  'Forget Password',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _validateForm(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialCards(
                          press: () {},
                          socialIcons:
                          'https://pngimg.com/uploads/google/google_PNG19635.png',
                        ),
                        SocialCards(
                          press: () {},
                          socialIcons:
                          'https://cdn3.iconfinder.com/data/icons/picons-social/57/46-facebook-512.png',
                        ),
                        SocialCards(
                          press: () {},
                          socialIcons:
                          'https://1000logos.net/wp-content/uploads/2017/06/Twitter-Log%D0%BE.png',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, SignUpScreen.routeName);
                          },
                          child: const Text(
                            ' Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          } else if (state is LoginLoading) {
            // Return a loading indicator or screen here
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoginSuccess) {
            // Navigate to the success screen or perform any other actions
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          } else if (state is LoginFailure) {
            // Handle the login failure state
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          return  Container(); //what do i return here?
        },
      ),
    );
  }
}

class SocialCards extends StatelessWidget {
  final String socialIcons;
  final GestureTapCallback press;

  const SocialCards({super.key, 
    required this.socialIcons,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(12),
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: Image.network(
          socialIcons,
        ),
      ),
    );
  }
}