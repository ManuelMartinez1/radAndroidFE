import 'dart:developer';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      theme: ThemeData(
        // Define your theme data here
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPress;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;

  const Button({
  Key? key,
  required this.label,
  required this.onPress,
  required this.backgroundColor,
  this.width,
  this.height,
  this.textColor = Colors.white
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Usando width
      height: height, // Usando height
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Background(),
          TransparentOverlay(),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00023B),
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class TransparentOverlay extends StatelessWidget {
  const TransparentOverlay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.0),
            topRight:  Radius.circular(60.0),
          ),
          color: Color.fromRGBO(245, 245, 245, .25),
        ),
        height: MediaQuery.of(context).size.height * 0.4,
        child: const RegistryWidget(),
      ),
    );
  }
}

class RegistryWidget extends StatelessWidget {
  const RegistryWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bienvenido',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 36,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15),
          const Text(
            'Empieza a buscar tus comics \n favoritos!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),
          Button(
            label: 'Log in',
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogInPage()),
              );
            },
            backgroundColor:const Color(0xFFD7142B),
            height: 54.0,
            width: 320.0,
          ),
          const SizedBox(height: 20,),
          Button(
            label: 'Sign Up',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            backgroundColor: Color(0xFF00023B),
            height: 54.0,
            width: 320.0,
          )
        ],
      )
    );
  }
  void nothing(){
    log("nada");
  }
}
