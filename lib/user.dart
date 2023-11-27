import 'package:flutter/material.dart';
import 'search.dart';
import 'home.dart';
import 'package:rad/models/user_model.dart';
import 'package:rad/favorites.dart';
import 'profilewidget.dart';

final Color scaffoldBackgroundColor = Color(0xFF00023B); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383b59); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383b59); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos
// Nuevo color para el texto
final Color textColor = Colors.white;

// Theme personalizado
final ThemeData customTheme = ThemeData(
  textTheme: TextTheme(
    headlineMedium: TextStyle(color: textColor), // Estilo para el texto 'username'
    // Puedes agregar más estilos aquí según sea necesario
  ),
);

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://i.pinimg.com/564x/12/12/ba/1212ba0aeecc68177c3f0dff5d877c20.jpg'),
                            fit: BoxFit.cover, // Ajusta el fit a BoxFit.contain
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFd7142b)),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('username', style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              )),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFd7142b), side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text('Edit profile', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "My favorites", icon: Icons.settings, textColor: Colors.white,onPress: () {}),
              const Divider(),
              ProfileMenuWidget(title: "Billing details", icon: Icons.wallet,textColor: Colors.white, onPress: () {}),
              const Divider(),
              ProfileMenuWidget(title: "Change subscription", icon: Icons.verified_user_outlined,textColor: Colors.white, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Information", icon: Icons.info,textColor: Colors.white, onPress: () {}),
              const Divider(),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {}
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: bottomNavBarColor,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}