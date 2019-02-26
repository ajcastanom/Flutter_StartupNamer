import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // El callbabck de itemBuilder se llama una vez por cada par de palabras sugerido,
        // y coloca cada sugerencia en una fila de ListTile.
        // Para las filas pares, la función añade una fila ListTile para el par de palabras.
        // Para filas impares, la función añade un widget Divider
        // para separar visualmente las entradas. Ten en cuenta que el divisor puede ser difícil
        // de ver en dispositivos más pequeños.
        itemBuilder: (context, i) {
          // Añade un widget divisor de un píxel de alto antes de cada fila en theListView.
          if (i.isOdd) return Divider();
          // La sintaxis "i ~/ 2" divide i entre 2 y devuelve un resultado entero.
          // Por ejemplo: 1, 2, 3, 4, 5 se convierte en 0, 1, 1, 2, 2.
          // Esto calcula el número real de pares de palabras en el ListView,
          // menos los widgets divider.
          final index = i ~/ 2;
          // Si ha llegado al final de los pares de palabras disponibles...
          if (index >= _suggestions.length) {
            // ... luego generar 10 más y agregarlos a la lista de sugerencias.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),

    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
            );
            final List<Widget> divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          }
      )
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
