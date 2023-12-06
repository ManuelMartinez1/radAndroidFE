import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rad/api_service.dart';
import 'package:rad/main.dart';
import 'home.dart';

class LogInPage extends StatelessWidget{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiservice = ApiService(baseUrl: 'http://192.168.56.1:8000');
  LogInPage ({Key? key}): super(key: key);
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
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Bienvenido de nuevo \n ¡Tus comics te están esperando!',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Campos de texto
                  const SizedBox(height: 250,),
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
                  const SizedBox(height: 15.0),
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
                  // Botón centrado
                  const SizedBox(height: 30.0),
                  Center(
                    child: Button(
                      label: 'Iniciar sesión',
                      onPress: () async {
                      String username = usernameController.text;
                      String password = passwordController.text;

                      if (username.isNotEmpty && password.isNotEmpty){
                        try{
                          var response = await apiservice.login(username, password);
                          SnackBar(content: Text('Welcome $username'));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen())
                          );
                        }
                        catch(e){
                          showError(context, 'Failed to login ${e.toString()}');
                        }
                      }else{
                       SnackBar(content: Text('Rellena los campos necesarios'));
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