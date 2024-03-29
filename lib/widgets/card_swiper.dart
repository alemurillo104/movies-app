
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:movies_app/models/cast_model.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;
  const CardSwiper({ 
    Key? key, 
    required this.movies 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return (movies.isEmpty)
      ? _moviesEmpty(size)
      : _cardSwiperW(size);
  }

  Widget _cardSwiperW(Size size) {
    return SizedBox(
    width: double.infinity,
    height: size.height * 0.5,
    child: Swiper(
      itemCount: movies.length,
      layout: SwiperLayout.STACK,
      itemWidth: size.width * 0.6,
      itemHeight: size.height * 0.4,
      itemBuilder: (context, index) {

        Movie movie = movies[index];

        movie.heroId = 'swiper-${movie.id}';

        return  GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
          child : Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg') , 
                image:  NetworkImage(movie.fullPosterImg),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );
  }

  Widget _moviesEmpty(Size size) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}