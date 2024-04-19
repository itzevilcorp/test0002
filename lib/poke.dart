import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'PaymentGatewayScreen.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<dynamic> pokemonData = [];
  List<dynamic> filteredPokemonData = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  Future<void> fetchPokemonData() async {
    final Uri url = Uri.parse('https://api.pokemontcg.io/v2/cards?q=name:gardevoir');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        pokemonData = json.decode(response.body)['data'];
        filteredPokemonData = List.from(pokemonData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterPokemon(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPokemonData = List.from(pokemonData);
      } else {
        filteredPokemonData = pokemonData
            .where((pokemon) => pokemon['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: PokemonSearch(filteredPokemonData, filterPokemon));
            },
          ),
        ],
      ),
      body: filteredPokemonData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: filteredPokemonData.length,
        itemBuilder: (BuildContext context, int index) {
          final pokemon = filteredPokemonData[index];
          final marketPrice = pokemon['tcgplayer'] != null &&
              pokemon['tcgplayer']['prices'] != null &&
              pokemon['tcgplayer']['prices']['holofoil'] != null &&
              pokemon['tcgplayer']['prices']['holofoil']['market'] != null
              ? pokemon['tcgplayer']['prices']['holofoil']['market']
              : 0.0;
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Image.network(pokemon['images']['small']),
              title: Text(
                pokemon['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Market Price: \$${marketPrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to PaymentGatewayScreen when Buy Now button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentGatewayScreen()),
                  );
                },
                child: Text('Buy Now'),
              ),
            ),
          );
        },
      ),
    );
  }
}


class PokemonSearch extends SearchDelegate<String> {
  final List<dynamic> pokemonList;
  final Function(String) filterFunction;

  PokemonSearch(this.pokemonList, this.filterFunction);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? []
        : pokemonList.where((pokemon) {
      final name = pokemon['name'].toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        final pokemon = suggestionList[index];
        return ListTile(
          title: Text(pokemon['name']),
          onTap: () {
            close(context, pokemon['name']);
          },
        );
      },
    );
  }
}
