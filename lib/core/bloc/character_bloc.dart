import 'package:flutter/material.dart';
import 'package:rick_and_morty_example/core/models/characters_response.dart';

class CharacterBloc extends ChangeNotifier {

  Character character;
  double tappedHeight;
  double tappedWidth;
  Offset tappedOffset;

  void updateCharacter({
    Character character,
    double tappedHeight,
    double tappedWidth,
    Offset tappedOffset
  }) {
    this.character = character;
    this.tappedHeight = tappedHeight;
    this.tappedWidth = tappedWidth;
    this.tappedOffset = tappedOffset;
    notifyListeners();
  }

}