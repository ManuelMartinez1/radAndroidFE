import 'package:flutter/material.dart';

import 'home.dart';
import 'search.dart';
import 'user.dart';
import 'package:rad/volume.dart';
import 'package:rad/api_service.dart';
import 'package:rad/models/title_model.dart';
import 'package:rad/models/volume_model.dart';

final Color scaffoldBackgroundColor = Color(0xFF100C08); // Fondo general del Scaffold
final Color appBarColor = Color(0xFF383838); // Color de la AppBar
final Color bottomNavBarColor = Color(0xFF383838); // Color del bottomNavigationBar
final Color iconColor = Color(0xFFD9D9D9); // Color de los íconos

class TitleScreen extends StatelessWidget {
  final String titleId;
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.56.1:8000');

  TitleScreen({required this.titleId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TitlesModel>(
      future: apiService.getTitles(titleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No se encontraron datos');
        } else {
          // Obtén los detalles del título desde el snapshot
          TitlesModel titleDetails = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Title details', style: TextStyle(
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
                      image: NetworkImage(titleDetails.cover),
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
                              child: Image.network(
                                titleDetails.cover,
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
                                  titleDetails.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 11.0),
                                Text(
                                  titleDetails.publishDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      titleDetails.rating.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
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
                          titleDetails.description,
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
                      children: titleDetails.tags.map((tag) {
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
                  child: Text(
                    'Volumes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Lista horizontal de Volumes
                Container(
                  height: 230.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: titleDetails.volumes.length,
                    itemBuilder: (context, index) {
                      String volumeId = titleDetails.volumes[index];

                      return FutureBuilder<VolumesModel>(
                        future: apiService.getVolumes(volumeId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return Text('No se encontraron detalles del volumen');
                          } else {
                            VolumesModel volume = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VolumeScreen(volumeId: volume.id),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    // Columna izquierda para la portada del volumen
                                    Container(
                                      width: 160.0,
                                      height: 230.0,
                                      child: ClipRRect(
                                        child: Image.network(
                                          volume.cover,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Separador
                                    SizedBox(width: 16.0),
                                  Expanded(
                                    // Columna derecha para el nombre del título asociado al volumen
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            titleDetails.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            'Vol. ${volume.volumeNumber}',
                                            style: TextStyle(
                                              color: Colors.white,
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
            ),),
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
