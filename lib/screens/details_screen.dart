import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cambiar por instanciacion de movie
    final String movie =
        ModalRoute.of(context)?.settings.arguments.toString() ?? "no-movie";

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(),
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black45,
          child: const Text(
            "movie.title",
            style: TextStyle(fontSize: 16),
          ),
        ),
        background: const FadeInImage(
          placeholder: AssetImage("assets/loading.gif"),
          image: NetworkImage("https://via.placeholder.com/500x300"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  //final TextTheme textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const FadeInImage(
            placeholder: AssetImage("assets/loading.gif"),
            image: NetworkImage("https://via.placeholder.com/200x300"),
            height: 150,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "movie.title",
              style: Theme.of(context).textTheme.headline5,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Text(
              "movie.originalTitle",
              style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  "movie.voteAverage",
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            )
          ],
        ),
      ]),
    );
  }
}
