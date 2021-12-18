import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ytfy_desktop/navigator.dart';
import 'package:ytfy_desktop/providers/currentsong.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
var box;
var box2;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  box = await Hive.openBox("Favourites");
  box2 = await Hive.openBox("prefered");
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>CurrentSong()),
      ChangeNotifierProvider(create: (_)=>StreamUrl())
    ],child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationPage()
    );
  }
}
