import 'package:ecommerce_app/screens/authentication/bloc/login_bloc.dart';
import 'package:ecommerce_app/screens/authentication/bloc/signup_bloc.dart';
import 'package:ecommerce_app/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/screens/profile/bloc/profile_bloc.dart';
import 'package:ecommerce_app/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/consts/const_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()), //Provide the LoginBloc
        BlocProvider<SignUpBloc>(create: (context) => SignUpBloc()),// Provide the SignUpBloc
        BlocProvider<CartBloc>(create: (context) => CartBloc()),// Provide the SignUpBloc
        BlocProvider<ProfileBloc>(create:(context)=> ProfileBloc()),

        // You can add more BlocProviders here if needed
      ],
      child: MaterialApp(
        initialRoute: SplashScreen.routeName,
        routes: routes,
        debugShowCheckedModeBanner: false,
        title: appName,
        theme:ThemeData(
          focusColor: Colors.deepOrange,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            displayLarge: TextStyle(color: Colors.black),
            displayMedium: TextStyle(color: Colors.black),
            displaySmall: TextStyle(color: Colors.black),
            bodySmall:TextStyle(color: Colors.black),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: blackColor
            )
          ),
          fontFamily: regular,
        ),
      ),
    );
  }
}

