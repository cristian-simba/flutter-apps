import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'src/api/item.dart';
import 'src/catalog.dart';
import 'src/item_tile.dart';

import '../../main.dart' as Principal;

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Infinite List');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Catalog>(
      create: (context) => Catalog(),
      child: MaterialApp(
        title: 'Infinite List Sample',
        theme: ThemeData.light(),
        home: const MyHomePage(),
        routes: {
          '/home': (context) => const Principal.MyApp()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite List Sample'),
      ),
      body: Column(
        children: [
          Selector<Catalog, int?>(
            selector: (context, catalog) => catalog.itemCount,
            builder: (context, itemCount, child) => Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                padding: const EdgeInsets.symmetric(vertical: 18),
                itemBuilder: (context, index) {
                  var catalog = Provider.of<Catalog>(context);
                  return switch (catalog.getByIndex(index)) {
                    Item(isLoading: true) => const LoadingItemTile(),
                    var item => ItemTile(item: item)
                  };
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: const Text('Ir a la Página Principal'),
          ),
        ],
      ),
    );
  }
}
