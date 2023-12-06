import 'package:flutter/material.dart';
import 'package:rad/issue.dart';
import 'package:rad/models/issue_model.dart';

import 'home.dart';
import 'search.dart';
import 'user.dart';
import 'package:rad/api_service.dart';

final Color scaffoldBackgroundColor = Color(0xFF100C08); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383838); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383838); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos

class MyFavoritesScreen extends StatefulWidget {
  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: FutureBuilder<List<String>>(
        future: apiService.getUserFavoriteComics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Utiliza el widget que prefieras para mostrar los cómics favoritos
            return FavoriteTitlesGrid(favoriteComicIds: snapshot.data!);
          }
        },
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

class FavoriteTitlesGrid extends StatelessWidget {
  final List<String> favoriteComicIds;

  FavoriteTitlesGrid({required this.favoriteComicIds});
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

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
      itemCount: favoriteComicIds.length,
      itemBuilder: (context, index) {
        return FutureBuilder<IssueModel>(
          future: apiService.getIssue(favoriteComicIds[index]), // Reemplaza con tu método existente
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final issueDetails = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssueScreen(issueId: issueDetails.id),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(issueDetails.cover),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}