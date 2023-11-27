import 'package:flutter/material.dart';
import 'package:rad/issue.dart';
import 'home.dart';
import 'user.dart';
import 'package:rad/api_service.dart';
import 'package:rad/models/issue_model.dart';

final Color scaffoldBackgroundColor = Color(0xFF00023B); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383b59); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383b59); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos

class SearchScreen extends StatefulWidget {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<IssueModel> searchResults = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            performSearch(searchController.text);
                            setState(() {
                              isSearching = true;
                            });
                          } else {
                            // Si el campo de búsqueda está vacío, oculta el ícono de "tachita"
                            setState(() {
                              isSearching = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // Agrega aquí la acción de búsqueda
                      performSearch(searchController.text);
                    },
                  ),
                  // Mostrar el ícono de "tachita" solo cuando esté activa la búsqueda
                  if (isSearching)
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        // Al hacer clic en la "tachita", restablece los resultados
                        resetSearch();
                        // También limpia el campo de búsqueda
                        searchController.clear();
                      },
                    ),
                ],
              ),
            ),
          ),
          if (isSearching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Search results',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          Expanded(
            child: isSearching
                ? IssuesGrid(issues: searchResults)
                : FutureBuilder<List<IssueModel>>(
              future: widget.apiService.getAllIssues(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return IssuesGrid(issues: snapshot.data!);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: iconColor),
                onPressed: () {
                  // Agrega aquí la acción al tocar el ícono Search
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

  void performSearch(String query) async {
    setState(() {
      isSearching = true;
    });
    try {
      // Realiza la búsqueda y obtén los IDs
      final List<String> ids = await widget.apiService.search(query);

      // Inicializa la lista de resultados
      List<IssueModel> results = [];

      // Obtiene la información completa de cada issue usando los IDs
      for (String id in ids) {
        final IssueModel issue = await widget.apiService.getIssue(id);
        results.add(issue);
      }

      // Actualiza los resultados
      setState(() {
        searchResults = results;
      });
    } catch (error) {
      print('Error en la búsqueda: $error');
      // Manejar el error de manera apropiada (puede ser un error de red, etc.)
    }
  }




  void resetSearch() {
    setState(() {
      isSearching = false;
    });
  }
}

class IssuesGrid extends StatelessWidget {
  final List<IssueModel> issues;

  IssuesGrid({required this.issues});

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
      itemCount: issues.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navegar a la pantalla 'Title' con el ID correspondiente
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IssueScreen(issueId: issues[index].id),
              ),
            );
          },
          child: Container(
            // Mostrar la imagen del atributo 'cover' en lugar de un fondo azul
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(issues[index].cover),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

