import 'package:flutter/material.dart';

import 'search.dart';
import 'user.dart';

import 'package:rad/api_service.dart';
import 'package:rad/models/title_model.dart';
import 'package:rad/title.dart';

final Color scaffoldBackgroundColor = Color(0xFF00023B); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383b59); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383b59); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.1.246:8000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Popular titles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TitlesModel>>(
              future: apiService.getAllTitles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return TitlesGrid(titles: snapshot.data!);
                }
              },
            ),
          ),
        ],
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
                  // Agrega aquí la acción al tocar el ícono Home
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

class TitlesGrid extends StatelessWidget {
  final List<TitlesModel> titles;

  TitlesGrid({required this.titles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 92 / 140, // Proporción deseada (ancho / alto)
      ),
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navegar a la pantalla 'Title' con el ID correspondiente
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TitleScreen(titleId: titles[index].id),
              ),
            );
          },
          child: Container(
            // Mostrar la imagen del atributo 'cover' en lugar de un fondo azul
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(titles[index].cover),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
