import 'dart:convert';

import 'package:buscador_de_gifs/widgets/gif_table.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;

  int _offset = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> _getTrendingGifs() async {
    String search_url =
        "https://api.giphy.com/v1/gifs/search?api_key=1GDmyw4i3ctGzGBqPbIgvvVHiGqdExVq&q=$_search&limit=25&offset=$_offset&rating=g&lang=en";

    String trending_url =
        "https://api.giphy.com/v1/gifs/trending?api_key=1GDmyw4i3ctGzGBqPbIgvvVHiGqdExVq&limit=25&rating=g";

    http.Response response;

    if (_search == null) {
      response = await http.get(Uri.parse(trending_url));
    } else {
      response = await http.get(Uri.parse(search_url));
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getTrendingGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return GifTable(context: context, snapshot: snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
