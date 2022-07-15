

import 'package:flutter/material.dart';
import 'package:movies_app/models/cast_model.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';
   
class MovieSlider extends StatefulWidget {
   
  final String? title;
  final List<Movie> movies;
  final Function onNextPage;

  const MovieSlider({ 
     Key? key, 
     required this.movies, 
     required this.onNextPage, 
     this.title 
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {


  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500 ) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    if (widget.movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [

          if (widget.title != null) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold) ),
            ),
            
          const SizedBox( height: 5 ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) => _MoviePoster(movie: widget.movies[index],) 
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  
  const _MoviePoster({
    Key? key, 
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children:  [
          GestureDetector(
            onTap: () async {
              final movieProvider = Provider.of<MovieProvider>(context, listen: false);
              List<Cast> casts = await movieProvider.getCastByMovieId(movie.id) ?? []; 
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, 'details', arguments: {"movie": movie, "casts" : casts});
            },
            //  onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox( height: 5 ),

          Text(
            movie.title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}