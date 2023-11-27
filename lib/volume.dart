import 'package:flutter/material.dart';
import 'package:rad/issue.dart';
import 'package:rad/models/issue_model.dart';

import 'home.dart';
import 'search.dart';
import 'user.dart';
import 'package:rad/api_service.dart';
import 'package:rad/models/volume_model.dart';
import 'package:rad/models/title_model.dart';

final Color scaffoldBackgroundColor = Color(0xFF00023B); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383b59); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383b59); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9);


class VolumeScreen extends StatelessWidget {
  final String volumeId;
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  VolumeScreen({required this.volumeId});

  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VolumesModel>(
      future: apiService.getVolumes(volumeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No se encontraron datos');
        } else {
          // Obtén los detalles del título desde el snapshot
          VolumesModel volumeDetails = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Volume details'),
              backgroundColor: appBarColor,
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
                        image: NetworkImage(volumeDetails.cover),
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
                              width: 175.0, // Ancho deseado para la portada
                              height: 175.0, // Alto deseado para la portada
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  volumeDetails.cover,
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
                                  FutureBuilder<TitlesModel>(
                                    future: apiService.getTitles(volumeDetails.titleName),
                                    builder: (context, titleSnapshot) {
                                      if (titleSnapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (titleSnapshot.hasError) {
                                        return Text('Error: ${titleSnapshot.error}');
                                      } else if (!titleSnapshot.hasData) {
                                        return Text('No se encontraron detalles del título');
                                      } else {
                                        TitlesModel titleDetails = titleSnapshot.data!;
                                        return Text(
                                          '${titleDetails.name} vol. ${volumeDetails.volumeNumber}',  // Mostrar el nombre del título junto con el número de volumen
                                          style: TextStyle(
                                            color: Color(0xFFdcdcdc),
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                    volumeDetails.publishDate,
                                    style: TextStyle(
                                      color: Color(0xFFdcdcdc),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      Text(
                                        volumeDetails.rating.toString(),
                                        style: TextStyle(
                                          color: Color(0xFFdcdcdc),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                            isFavorited = !isFavorited;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFdcdcdc), // Color del botón
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0), // Radio del borde del botón
                                          ),
                                        ),
                                        child: Row(
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Separador vertical
                        SizedBox(height: 20.0),
                        // Container para la descripción
                        Container(
                          child: Text(
                            volumeDetails.description,
                            style: TextStyle(
                              color: Color(0xFFdcdcdc),
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
                        children: volumeDetails.tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                Chip(
                                  label: Text(tag),
                                  backgroundColor: Color(0xFFd7142b), // Puedes ajustar el color según tus preferencias
                                  labelStyle: TextStyle(color: Color(0xFFdcdcdc)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Text(
                      'Issues',
                      style: TextStyle(
                        color: Color(0xFFdcdcdc),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Lista vertical de Issues
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 360.0, // Altura deseada para la lista de Issues
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: volumeDetails.issues.length,
                      itemBuilder: (context, index) {
                        String issueId = volumeDetails.issues[index];

                        return FutureBuilder<IssueModel>(
                          future: apiService.getIssue(issueId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return Text('No se encontraron detalles del issue');
                            } else {
                              IssueModel issue = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IssueScreen(issueId: issue.id), // Ajusta según tu implementación
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      // Contenedor para la portada del issue
                                      Container(
                                        width: 160.0, // Ancho deseado para la portada
                                        height: 230.0, // Alto deseado para la portada
                                        child: ClipRRect(
                                          child: Image.network(
                                            issue.cover,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      // Columna derecha para el nombre y número del issue
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Utiliza un widget que maneje el desbordamiento y garantice que el texto se ajuste
                                            Center(
                                              child: Text(
                                                issue.issueName,
                                                style: TextStyle(
                                                  color: Color(0xFFdcdcdc),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2, // Ajusta el número máximo de líneas según sea necesario
                                                overflow: TextOverflow.ellipsis, // Ajusta el comportamiento de desbordamiento
                                              ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              'Issue #${issue.issueNumber}',
                                              style: TextStyle(
                                                color: Color(0xFFdcdcdc),
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
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