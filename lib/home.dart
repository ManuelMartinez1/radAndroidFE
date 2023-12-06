import 'package:flutter/material.dart';

import 'search.dart';
import 'user.dart';

import 'package:rad/api_service.dart';
import 'package:rad/models/title_model.dart';
import 'package:rad/title.dart';

final Color scaffoldBackgroundColor = Color(0xFF100C08); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383838); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383838); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0,),
          Container(
            height: 100.0, // Ajusta la altura según sea necesario
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                List<String> imagePaths = [
                  'https://assetsio.reedpopcdn.com/Spider-Banner_AVVWjOb.jpg?width=1200&height=1200&fit=bounds&quality=70&format=jpg&auto=webp',
                  'https://cdn.businessinsider.es/sites/navi.axelspringer.es/public/media/image/2022/03/batman-comics-2636505.jpg?tf=3840x',
                  'https://img2.rtve.es/i/?w=1600&i=1685615057917.jpg',
                  'https://www.cinemascomics.com/wp-content/uploads/2021/06/superman-comics-dest.jpg',
                ]; // Lista de rutas de imágenes

                return GestureDetector(
                  onTap: () {
                    // Agrega aquí la lógica para navegar a la pantalla o URL deseada
                    print('Tapped on image $index');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imagePaths[index]),
                      radius: 47.0,
                    ),
                  ),
                );
              },
            ),
          ),
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
