import 'dart:developer';

import 'package:flutter/material.dart';

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

  const Button({
  Key? key,
  required this.label,
  required this.onPress,
  this.backgroundColor = Colors.blue,
  this.textColor = Colors.white
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      )
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
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bienvenido',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 36,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 15),
          Text(
            'Empieza a buscar tus comics \n favoritos!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 40),
          Button(
            label: 'login',
            onPress: nothing,
          ),
          SizedBox(height: 3,),
          Button(
            label: 'Sign Up',
            onPress: nothing,
          )
        ],
      )
    );
  }
}
void nothing(){
  log("nada");
}
