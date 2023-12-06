import 'package:flutter/material.dart';

import 'home.dart';
import 'search.dart';
import 'user.dart';
import 'package:rad/api_service.dart';
import 'package:rad/models/author_model.dart';
import 'package:rad/models/issue_model.dart';
import 'package:rad/auth_service.dart';
import 'package:rad/read.dart';

final Color scaffoldBackgroundColor = Color(0xFF100C08); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383838); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383838); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos

class IssueScreen extends StatefulWidget {
  final String issueId;
  final apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');


  IssueScreen({required this.issueId});

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  bool isFavorited = false;
  bool foundAuthorW = false;
  bool foundAuthorA = false;

  final apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    try {
      final isFavorited = await apiService.isComicInFavorites(widget.issueId);
      setState(() {
        this.isFavorited = isFavorited;
      });
    } catch (error) {
      print('Error al verificar estado de favoritos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IssueModel>(
      future: widget.apiService.getIssue(widget.issueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No se encontraron datos');
        } else {
          IssueModel issueDetails = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Issue details', style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),),
              backgroundColor: appBarColor,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            backgroundColor: scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenedor para la foto y detalles con fondo de opacidad
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(issueDetails.cover),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), // Ajusta la opacidad según tu preferencia
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row para la portada (cover) y detalles
                        Row(
                          children: [
                            // Columna izquierda para la portada (cover)
                            Container(
                              width: 165.0, // Ancho deseado para la portada
                              height: 240.0, // Alto deseado para la portada
                              child: ClipRRect(
                                child: Image.network(
                                  issueDetails.cover,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Separador
                            SizedBox(width: 16.0),
                            // Columna derecha para el nombre y la clasificación
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    issueDetails.issueName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 11.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      Text(
                                        issueDetails.rating.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 140.0, // Ancho deseado para el botón
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            String? userRole = await AuthService.getUserRole();
                                            // Verificar si el usuario tiene el rol "member"
                                            if (userRole == "premium") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ReadScreen()),
                                              );
                                              //ver si puedo hacer readscreen(issuedetails)
                                            } else if (issueDetails.free){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ReadScreen()),
                                              );
                                            }else {
                                              // Mostrar un mensaje indicando que el contenido solo está disponible para premium
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Contenido Premium"),
                                                    content: Text("Este contenido está disponible solo para usuarios premium."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFF04A00), // Color del botón
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), // Radio del borde del botón
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Read',
                                                style: TextStyle(
                                                  color: Colors.white, // Color del texto
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 140.0, // Ancho deseado para el botón
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isFavorited = !isFavorited;
                                            });
                                            if (isFavorited) {
                                              // Lógica para agregar a favoritos
                                              apiService.addToFavorites(widget.issueId);
                                            } else {
                                              // Lógica para quitar de favoritos
                                              apiService.removeFromFavorites(widget.issueId);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFdcdcdc), // Color del botón
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), // Radio del borde del botón
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isFavorited ? Icons.favorite : Icons.favorite_outline,
                                                color: Color(0xFF00032b),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                isFavorited ? 'Favorited' : 'Favorite',
                                                style: TextStyle(
                                                  color: Color(0xFF00032b), // Color del texto
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                        // Separador vertical
                        SizedBox(height: 15.0),
                        Container(
                          child: Text(
                            'Release date:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Container para la date
                        Container(
                          child: Text(
                            issueDetails.publishDate,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.0, // Ajusta la altura según tus preferencias
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: issueDetails.tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                Chip(
                                  label: Text(tag),
                                  backgroundColor: Color(0xFFF04A00),
                                  labelStyle: TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )

                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título para la descripción
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0), // Espacio adicional entre el título y el texto de la descripción
                        // Container para la descripción del issue
                        Container(
                          child: Text(
                            issueDetails.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Columna izquierda para "Written by"
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Written by:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Columna derecha para "Art by"
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Art by:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container para alinear los títulos
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        // Row para la información de los autores
                        child: Row(
                          children: [
                            // Columna izquierda para Written by
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.0),
                                  // Lista de autores con el rol de "Writer"
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: issueDetails.authors.map<Widget>((authorId) {
                                      return FutureBuilder<AuthorModel>(
                                        future: apiService.getAuthor(authorId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('HASERROR');
                                          } else {
                                            if (snapshot.hasData) {
                                              AuthorModel author = snapshot.data!;
                                              bool isWriter = author.role.contains('Writer');

                                              if (isWriter) {
                                                foundAuthorW = true;
                                                return Container(
                                                  alignment: Alignment.topLeft,  // Alinea el nombre del autor en la parte superior
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 4.0),
                                                      Text(
                                                        '${author.name} ${author.lastName}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }

                                            if (!foundAuthorW && issueDetails.authors.last == authorId) {
                                              return Text(
                                                'Unknown',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              );
                                            }

                                            return SizedBox.shrink();
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            // Columna derecha para Art by
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.0),
                                  // Lista de autores con el rol de "Artist"
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: issueDetails.authors.map<Widget>((authorId) {
                                      return FutureBuilder<AuthorModel>(
                                        future: apiService.getAuthor(authorId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            print(snapshot.error);
                                            print(snapshot.stackTrace);
                                            return Text('Error: ${snapshot.error}');
                                          } else if (!snapshot.hasData) {
                                            return SizedBox.shrink();
                                          } else {
                                            AuthorModel author = snapshot.data!;
                                            bool isArtist = author.role.contains('Artist');

                                            if (isArtist) {
                                              foundAuthorA = true;
                                              return Container(
                                                alignment: Alignment.topLeft,  // Alinea el nombre del autor en la parte superior
                                                child: Text(
                                                  '${author.name} ${author.lastName}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }

                                            if (issueDetails.authors.last == authorId && !foundAuthorA) {
                                              return Text(
                                                'Unknown',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              );
                                            }

                                            return SizedBox.shrink();
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Otros elementos del body (si es necesario)
               ],
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
      },
    );
  }
}
