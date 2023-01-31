import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String? get searchFieldLabel => "Buscar Película";



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Text("buildactions"),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Text("buildactions");
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("buildSuggestions: $query");
  }
}
