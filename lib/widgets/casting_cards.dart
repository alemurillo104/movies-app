import 'package:flutter/material.dart';
import 'package:movies_app/models/cast_model.dart';

class CastingCards extends StatelessWidget {

  final List<Cast> casts;
  const CastingCards({ Key? key, required this.casts }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:casts.length,
        itemBuilder: (context, index) => _CastCard(cast: casts[index]),
      )
      
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;

  const _CastCard({
    Key? key, required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:  FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(cast.fullProfileImg), 
              fit: BoxFit.cover,
              height: 140,
              width: 100,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cast.name, 
            overflow: TextOverflow.ellipsis, 
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}