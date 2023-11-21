import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rad/main.dart';

class LogInPage extends StatelessWidget{
  const LogInPage ({Key? key}): super(key: key);
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
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Bienvenido de nuevo \n !Tus comics te están esperando!',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Campos de texto
                  const SizedBox(height: 250,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
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
                      onPress: nothing, // Reemplaza con tu función
                      backgroundColor: Color(0xFFD7142B),
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
  void nothing(){
    log('nada');
  }
}