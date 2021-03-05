import 'package:flutter/material.dart';
import 'package:rick_and_morty_example/pages/main_menu_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: MainMenuPage(), 
      )
    );
  }
}