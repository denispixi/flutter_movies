import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {
  //
  String _apiKey = '1848f5a0d4cd96c70507973bc2b9656f';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink {
    return _popularesStreamController.sink.add;
  }

  Stream<List<Pelicula>> get popularesStream {
    return _popularesStreamController.stream;
  }

  void dispose() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> processResponse(Uri url) async {
    final response = await http.get(url);
    final data = json.decode(response.body);
    final peliculas = Peliculas.fromJsonList(data['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });

    return await processResponse(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    print('cargando: $_cargando, _popularesPage: $_popularesPage');

    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;

    print('cargando siguientes');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': '$_popularesPage',
    });

    final peliculasResponse = await processResponse(url);

    _populares.addAll(peliculasResponse);
    popularesSink(_populares);

    Future.delayed(Duration(milliseconds: 500)).then((value) {
      _cargando = false;
    });

    return peliculasResponse;
  }

  Future<List<Actor>> getCast(int movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });
    final response = await http.get(url);
    final data = json.decode(response.body);

    final cast = Cast.fromJsonList(data['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    return await processResponse(url);
  }
}
