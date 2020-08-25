import 'package:flutter/material.dart';
//
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  //
  final movieProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _createAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 30),
              _createMoviePoster(context, pelicula),
              _createDescription(pelicula),
              _createCasting(pelicula),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _createAppBar(Pelicula pelicula) {
    return SliverAppBar(
      // elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title, textAlign: TextAlign.center),
        background: FadeInImage(
          image: NetworkImage(pelicula.backImgUrl),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 200),
        ),
      ),
    );
  }

  Widget _createMoviePoster(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(pelicula.imgUrl),
                height: 150,
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.title,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pelicula.originalTitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_border),
                      Text(
                        '${pelicula.voteAverage}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createDescription(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Pelicula pelicula) {
    return FutureBuilder(
      future: movieProvider.getCast(pelicula.id),
      builder: (context, AsyncSnapshot<List> snapshot) {
        return snapshot.hasData
            ? _createActoresPageView(snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: .3,
          initialPage: 1,
        ),
        itemCount: actores.length,
        itemBuilder: (context, index) => _createActorCard(actores[index]),
      ),
    );
  }

  Widget _createActorCard(Actor actor) {
    //
    final image = actor.imgUrl.endsWith('null')
        ? Image(
            image: AssetImage('assets/img/no-image.jpg'),
            height: 150,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(actor.imgUrl),
            height: 150,
            fit: BoxFit.cover,
          );

    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image,
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
