import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rad/api_service.dart';
import 'package:rad/main.dart';
import 'package:rad/home.dart';

class SubscriptionPlan extends StatelessWidget {
  final ApiService apiservice = ApiService(baseUrl: 'http://192.168.1.246:8000');
  SubscriptionPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color(0xFF00023B),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Elige tu plan',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '¡Explota todos los beneficios que puedes \n obtener ccon nuestros diferentes planes!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 32),
            _buildPlanButton(
              context: context,
              title: '   Basic   ',
              price: '\$0/mes',
              backgroundColor: const Color.fromRGBO(245, 245, 245, .30),
              textColor: Colors.white,
              labelColor: const Color(0xFF00023B),
              bulletPoints: const [
                '•  Acceso limitado para leer cómics',
                '•  Navega y descubre todos los cómics disponibles',
              ],
              onPress: () async {
                try{
                final prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString('email');
                String? username = prefs.getString('username');
                String? password = prefs.getString('password');
                await apiservice.SignUp(email, username,password,'', 'Free');
                showMessage(context, 'Usuario creado exitosamente');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                );
                }
                catch (e){
                  showMessage(context, 'Failed to login ${e.toString()}');
                }
              },
            ),
            const SizedBox(height: 40),
            _buildPlanButton(
              context: context,
              title: 'Premium',
              price: '\$15.99/mes',
              backgroundColor: const Color(0xFFD7142B),
              textColor: Colors.white,
              labelColor: const Color(0xFFD7142B) ,
              bulletPoints: const [
                '•  Acceso ilimitado a todos los cómics',
                '•  Agrega a favoritos cuántos cómics quieras',
              ],
              onPress: () async {
                try{
                  final prefs = await SharedPreferences.getInstance();
                  String? email = prefs.getString('email');
                  String? username = prefs.getString('username');
                  String? password = prefs.getString('password');
                  await apiservice.SignUp(email, username,password,'', 'premium');
                  showMessage(context, 'Usuario creado exitosamente');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                }
                catch (e){
                  showMessage(context, 'Failed to login ${e.toString()}');
                }
              }
            ),
          ],
        ),
      ),
    );
  }
  void showMessage(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildPlanButton({
    required BuildContext context,
    required String title,
    required String price,
    required labelColor,
    required Color backgroundColor,
    required Color textColor,
    required List<String> bulletPoints,
    required VoidCallback onPress,
  }) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: textColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Container(
              color: textColor,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      price,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var point in bulletPoints)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          point,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}