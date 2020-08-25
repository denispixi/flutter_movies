import 'package:flutter/material.dart';

import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'detalle': (context) => PeliculaDetalle(),
      },
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     elevation: 0, // This removes the shadow from all App Bars.
      //   ),
      // ),
    );
  }
}
