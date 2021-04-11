import 'package:flutter/material.dart';

class GifTable extends StatelessWidget {
  final BuildContext context;
  final AsyncSnapshot snapshot;

  const GifTable({this.context, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: int.parse(snapshot.data["data"].length.toString()),
      itemBuilder: (context, index) {
        return GestureDetector(
            child: Image.network(
          snapshot.data["data"][index]["images"]["fixed_height"]["url"]
              .toString(),
          height: 300,
          fit: BoxFit.cover,
        ));
      },
    );
  }
}
