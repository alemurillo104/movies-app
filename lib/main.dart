
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';


class MyHttpOverrides extends HttpOverrides{

  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

// void main() => runApp(const MyApp());
void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => MovieProvider() ), lazy: false,)
      ],
      child: MaterialApp(
        title: 'Peliculas App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home'    : (context) => const HomeScreen(),
          'details' : (context) => const DetailHomeScreen()
        },
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.indigo
          )
        ),
      ),
    );
  }
}