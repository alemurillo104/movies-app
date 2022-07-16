

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies_app/providers/movie_provider.dart';
import '../models/models.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon( Icons.arrow_back )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: Icon(
            Icons.movie_creation_outlined, 
            color: Colors.black38, 
            size: 130
          )
        )
      );
    }

    // print('peticion http');

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    movieProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: movieProvider.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>?> snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Movie> movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieItem(movie: movies[index]);
          },
        );
      },
    );
  }

}

class _MovieItem extends StatelessWidget {
  const _MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(movie.originalTitle),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie)
    );
  }
}