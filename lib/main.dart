import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

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
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),

    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
