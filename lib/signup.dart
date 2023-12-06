import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rad/main.dart';
import 'package:rad/subscription.dart';

class SignUpPage extends StatelessWidget{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  SignUpPage ({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(), // Tu widget de fondo
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
                children: [
                  // Botón de regreso
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
                      'Registro',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '¡Crea tu cuenta para que puedas acceder \n a cientos de comics que tenemos \n disponibles!',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Usuario',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Correo electrónico',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Contraseña',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: confirmPassController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Confirmar contraseña',
                      ),
                    ),
                  ),
                  // Botón centrado
                  const SizedBox(height: 30.0),
                  Center(
                    child: Button(
                      label: 'Registrarme',
                      onPress: () async {
                        String username = usernameController.text;
                        String password = passwordController.text;
                        String email = emailController.text;
                        String confirm = confirmPassController.text;
                        if(username.isNotEmpty && password.isNotEmpty && confirm.isNotEmpty && email.isNotEmpty){
                          if(password == confirm){
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('username', username);
                              await prefs.setString('password', password);
                              await prefs.setString('email', email);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (
                                      context) => SubscriptionPlan()),);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Las contraseñas no coinciden')));
                          }
                        }
                        else {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Rellena los campos necesarios')));
                        }
                      },
                      backgroundColor: Color(0xFFF04A00),
                      width: 320.0,
                      height: 54,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showError(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}