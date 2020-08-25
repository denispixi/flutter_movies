import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Batman',
    'Superman',
    'Ironman 1',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
    'Aquaman'
  ];

  final peliculasRecientes = ['Batman', 'Superman', 'Ironman'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Iconos a la derecha del appbar de búsqueda
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar de búsqueda
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: this.transitionAnimation,
      ),
      onPressed: () {
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        color: Colors.indigoAccent,
        child: Center(child: Text(selection)),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //
    // final listaSugerida = query.isEmpty
    //     ? peliculasRecientes
    //     : peliculas.where((p) {
    //         return p.toLowerCase().startsWith(query.toLowerCase());
    //       }).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[index]),
    //       onTap: () {
    //         selection = listaSugerida[index];
    //         this.showResults(context);
    //       },
    //     );
    //   },
    // );
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (context, AsyncSnapshot<List<Pelicula>> snapshot) {
          //
          if (snapshot.hasData) {
            final results = snapshot.data.map((peli) {
              return ListTile(
                title: Text(peli.title),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                leading: peli.imgUrl.endsWith('null')
                    ? Image(
                        image: AssetImage('assets/img/no-image.jpg'),
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        image: NetworkImage(peli.imgUrl),
                        width: 50,
                        fit: BoxFit.contain,
                      ),
              );
            }).toList();
            //
            return ListView(children: results);
          } //
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }
}
