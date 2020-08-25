import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwipper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwipper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * .7,
        itemHeight: _screenSize.height * .5,
        itemBuilder: (BuildContext context, int index) {
          // 
          peliculas[index].uniqueId = '${peliculas[index].id}-poster';
          // 
          // ClipRRect es para darle bordes redondeados a la tarjeta
          return Hero(
            tag: peliculas[index].uniqueId,
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].imgUrl),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
              },
            ),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
