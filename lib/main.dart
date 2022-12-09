import 'dart:async';
import 'dart:convert';

import 'package:api_gif/models/Gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Gif>> _listadoGifts;

  Future<List<Gif>> _getGifs() async {
    //revisar error
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=ugyoLmTS0I5A2V2G63GtqVx1KXtp1wbW&limit=10&rating=g"));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      print(response.body);
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }

      return gifs;
    } else {
      throw Exception("Falló la conexión");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoGifts = _getGifs();
  }

//interface
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Material App Bar'),
          ),
          body: FutureBuilder(
            future: _listadoGifts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return Text("hola");
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Error");
              } else {
                return Text("nada");
              }
            },
          )),
    );
  }
}
