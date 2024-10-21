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
  int _taps = 0;

  int get taps => _taps;

  void incrementTaps() {
    _taps++;
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>{}; // Initializes the favorites property.
  // Ensured only 'WordPair's are added to the list.
  // Created a Set to store WordPairs.
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// HomePage 1st Draft

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // build is called automatically every time the widget's circumstances change so the widget stays up to date.
//     var appState = context.watch<
//         MyAppState>(); // Changes to the app's current state using `watch` method.
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     // Every build method MUST return a widget (or tree of widgets).
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text('New words:'),// removing this looks cleaner.
//             BigCard(pair: pair),
//             SizedBox(
//                 height: 10), // Adds separation between the card and button.
//             Row(
//               mainAxisSize: MainAxisSize
//                   .min, // Tells Row to not take all available horizontal space.
//               children: [
//                 ElevatedButton.icon(
//                     onPressed: () {
//                       appState.toggleFavorite();
//                     },
//                     icon: Icon(icon),
//                     label: Text('Favorite')),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     appState.getNext();
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// HomePage 2nd Draft
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = TapCountPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              // Ensures the child is not obscured by a hardware notch/status bar.
              child: NavigationRail(
                extended:
                    constraints.maxWidth <= 600, // Shows labels next to icons.
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.thumb_up),
                    label: Text('Tap Counter'),
                  )
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
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
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class TapCountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // IconData icon;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                appState.incrementTaps();
              },
              label: Text('Tap'),
            ),
          ),
          Text('Taps: ${appState.taps}'),
          Image.asset('assets/images/thumbs_up.jpg')
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No Favorites yet.'),
      );
    }

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have '
            '${appState.favorites.length} favorites:'),
      ),
      for (var pair in appState.favorites)
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(pair.asLowerCase),
        )
    ]);

    // Favorites 1st draft
    // var favoriteList = appState.favorites;
    // List<String> favorites =
    //     favoriteList.map((WordPair) => WordPair.asPascalCase).toList();

    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       ListTile(
    //         isThreeLine: false,
    //         enabled: false,
    //         title: Text("Favorites Saved"),
    //       ),
    //       Text('Favorites:'),
    //       for (var words in favorites) Text(words),
    //     ],
    //   ),
    // );
  }
}
