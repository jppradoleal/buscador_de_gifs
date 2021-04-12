import 'dart:convert';

import 'package:buscador_de_gifs/widgets/gif_table.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String trendingUrl =
      "https://api.giphy.com/v1/gifs/trending?api_key=1GDmyw4i3ctGzGBqPbIgvvVHiGqdExVq&limit=25&rating=g";

  String _search;

  int _offset = 0;

  @override
  void initState() {
    super.initState();
  }

  Future _getTrendingGifs() async {
    final String searchUrl =
        "https://api.giphy.com/v1/gifs/search?api_key=1GDmyw4i3ctGzGBqPbIgvvVHiGqdExVq&q=$_search&limit=25&offset=$_offset&rating=g&lang=en";

    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get(Uri.parse(trendingUrl));
    } else {
      response = await http.get(Uri.parse(searchUrl));
    }
    return json.decode(response.body);
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  void _onSubmitted(String value) {
    setState(() {
      _search = value;
      _offset = 0;
    });
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: _onSubmitted,
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
                      return GifTable(
                        context: context,
                        snapshot: snapshot,
                        count: _getCount(snapshot.data["data"]),
                        searching: _search == null,
                        onTap: () {
                          setState(() {
                            _offset += 25;
                          });
                        },
                      );
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
