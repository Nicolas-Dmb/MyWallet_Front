import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'accueil.dart';
import 'login.dart';
import 'hoverView.dart';
import 'compte.dart';
import 'achat_vente.dart';
import 'component/getSetting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GetSettingAccount settings = GetSettingAccount();
  bool isReady = false;
  late Map<String, dynamic> colors;

  @override
  void initState() {
    super.initState();
    loadColors();
  }

  // Future qui récupère les données de SharedPreferences
  Future<void> loadColors() async {
    await settings.initialize();
    final prefs = await SharedPreferences.getInstance();
    String? colorsString = prefs.getString('colors');
    if (colorsString != null && colorsString.isNotEmpty) {
      setState(() {
        colors = jsonDecode(colorsString);
        isReady = true; // Retourner les couleurs
      });
    } else {
      setState(() {
        colors = {
          'background1': '0xFF181111',
          'background2': '0xFF1F1513',
          'interactive1': '0xFF391714',
          'interactive2': '0xFF4E1511',
          'interactive3': '0xFF5E1C16',
          'border1': '0xFF6E2920',
          'border2': '0xFF853A2D',
          'border3': '0xFFAC4D39',
          'button1': '0xFFE54D2E',
          'button2': '0xFFEC6142',
          'text1': '0xFFFF977D',
          'text2': '0xFFFBD3CB',
        };
        prefs.setString('colors', jsonEncode(colors));
        isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF181111),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(int.parse(colors['background1'])),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MediaQuery.of(context).size.width < 1367
            ? Login()
            : const Accueil(),
        '/login': (context) => Login(),
        '/main': (context) => const HoverView(),
        '/compte': (context) => SettingPage(),
        '/achat_vente': (context) => const AchatVente(),
      },
    );
  }
}
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // Configuration du thème (couleurs, typographie, etc.)
          ),
      initialRoute: '/', // Page d'accueil par défaut
      routes: {
        '/': (context) => const Accueil(),
        '/login': (context) => Login(),
        '/main':(context) => HoverView(),
        '/compte':(context) => SettingPage(),
        '/achat_vente':(context) => AchatVente(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
