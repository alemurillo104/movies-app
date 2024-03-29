
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';

import '../widgets/casting_cards.dart';

class DetailHomeScreen extends StatelessWidget {
   
  const DetailHomeScreen({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie  = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers:  [
          _CustomAppBar( movie: movie ),
          SliverList(
           delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: movie),
            _Overview( movie: movie),
            CastingCards(movieId: movie.id)
           ]),
          )
          
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  
  final Movie movie;
  
  const _Overview({
    Key? key, required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child:  Text(movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      )
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle({
    Key? key, 
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, 
                  style: textTheme.headline5, 
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 2
                ),
                Text(
                  movie.originalTitle, 
                  style: textTheme.subtitle1, 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, 
                ),
                
                Row(
                  children:  [
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: textTheme.caption,)
                  ],
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}



class _CustomAppBar extends StatelessWidget {

  final Movie movie;
  const _CustomAppBar({ Key? key, required this.movie }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity, 
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold
            ),
          )
        ),
        background:  FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}