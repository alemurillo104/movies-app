import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies_app/providers/movie_provider.dart';
import '../widgets/widgets.dart';
   
class HomeScreen extends StatelessWidget {
   
  const HomeScreen({ Key? key }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cine'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  [
            
            //Card Swiper
            CardSwiper(movies: movieProvider.nowPlayingMoviesList),

            //Listado horizontal de peliculas
            MovieSlider(
              title: 'Populares',
              movies: movieProvider.popularMoviesList,
              onNextPage: () {
                movieProvider.getPopularDisplay();
              },
            ),
            // Text('HomeScreen')
          ],
        ),
      )
    );
  }
}