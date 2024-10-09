import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp()); // Makes Flutter run app defined in `MyApp`
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'tap_counter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // build is called automatically every time the widget's circumstances change so the widget stays up to date.
    var appState = context.watch<
        MyAppState>(); // Changes to the app's current state using `watch` method.
    var pair = appState.current;

    // Every build method MUST return a widget (or tree of widgets).
    return Scaffold(
      body: Column(
        children: [
          Text('A new idea to think about:'),
          BigCard(pair: pair),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Requests the app's current theme.

    // Access the app's font theme.
    //It's class members include: bodyMedium, caption, and headlineLarge.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme
          .primary, // Defines the card's color to match the theme's `colorScheme`
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asCamelCase, style: style),
      ),
    );
  }
}
