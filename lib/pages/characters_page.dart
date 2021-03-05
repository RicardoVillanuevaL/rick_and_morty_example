import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rick_and_morty_example/core/bloc/character_bloc.dart';
import 'package:rick_and_morty_example/core/models/characters_response.dart';
import 'package:rick_and_morty_example/core/rick_and_morty_api.dart';

// int id;
// String name;
// Status status;
// Species species;
// String type;
// Gender gender;
// Location origin;
// Location location;
// String image;
// List<String> episode;
// String url;
// DateTime created;


class CharactersPage extends StatelessWidget {
  
  final CharacterBloc _characterBloc = CharacterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _CharacterInheritedWidget(
        string: "Hola",
        characterBloc: _characterBloc,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: FutureBuilder<List<Character>>(
                  future: RickAndMortyApi.getCharacters(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      List<Character> characters = snapshot.data;

                      return GridView.builder(
                        itemCount: characters.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2
                        ),
                        itemBuilder: (_, index) {
                          final character = characters[index];
                          return _CharacterCard(mCharacter: character, mCharacterBloc: _characterBloc);
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )
              ),
            ),

            AnimatedBuilder(
              animation: _characterBloc,
              builder: (_, child) {
                if (_characterBloc.character != null) {
                  return Positioned(
                    left: _characterBloc.tappedOffset.dx,
                    top: _characterBloc.tappedOffset.dy,
                    child: _CharacterFullCard(
                      mCharacter: _characterBloc.character,
                      mCharacterBloc: _characterBloc,
                    )
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _CharacterFullCard extends StatelessWidget {
  
  final Character mCharacter;
  final CharacterBloc mCharacterBloc;

  _CharacterFullCard({@required this.mCharacter, @required this.mCharacterBloc});

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // final charactersBloc = _CharacterInheritedWidget.of(context).characterBloc; 
    // final charactersBloc = _CharacterInheritedWidget.of(context).string;
    // print(charactersBloc); 
    final size = MediaQuery.of(context).size;

    return GestureDetector(
          key: _globalKey,
          child: AnimatedBuilder(
            animation: mCharacterBloc,
            builder: (_, child) {
              final selected = (mCharacterBloc.character != null && (mCharacter.id == mCharacterBloc.character.id));

              return TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                curve: Curves.elasticOut,
                tween: Tween(
                  begin: 0.0, 
                  end: selected ? 1.0 : 0.0
                ),
                child: Container(
                  height: selected ? mCharacterBloc.tappedHeight : .0,
                  width: selected ? mCharacterBloc.tappedWidth : .0,
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.bottomRight,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            mCharacter.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(mCharacter.image)
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black26,
                        spreadRadius: 3,
                        blurRadius: 3
                      )
                    ]
                  ),
                ),
                builder: (_, value, child) {
                  // print(value);
                  double distanceX;
                  double distanceY;
                  if (selected) {
                    // distanceX = (mCharacterBloc.tappedOffset.dx <= size.width / 2)
                                  // ?  size.width / 2 - mCharacterBloc.tappedOffset.dx
                                  // :  mCharacterBloc.tappedOffset.dx - size.width / 2;
                    distanceX = (size.width / 2) - mCharacterBloc.tappedWidth / 2  - mCharacterBloc.tappedOffset.dx; 
                    distanceY = (size.height / 2) - mCharacterBloc.tappedHeight / 2 - mCharacterBloc.tappedOffset.dy;
                  }

                  return Transform.translate(
                    offset: selected 
                            ? Offset((distanceX) * value, (distanceY) * value)
                            // ? Offset((size.width / 2) * value - (172.5/2), (size.height / 2) * value)
                            : Offset(0, 0),
                    child: child,
                  );
                },
              );
            },
          )
        );
  }
}

class _CharacterCard extends StatefulWidget {
  
  final Character mCharacter;
  final CharacterBloc mCharacterBloc;

  _CharacterCard({@required this.mCharacter, @required this.mCharacterBloc});
  
  @override
  __CharacterCardState createState() => __CharacterCardState();
}

class __CharacterCardState extends State<_CharacterCard> {
  
  final GlobalKey _globalKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      onTap: () {
        final RenderBox referenceBox = _globalKey.currentContext.findRenderObject();

        final position = referenceBox.localToGlobal(Offset.zero);
        final width = referenceBox.size.width;
        final height = referenceBox.size.height;

        widget.mCharacterBloc.updateCharacter(
          character: widget.mCharacter,
          tappedHeight: height,
          tappedWidth: width,
          tappedOffset: position
        );
      },
      child: AnimatedBuilder(
        animation: widget.mCharacterBloc,
        builder: (_, child) {
          final selected = (widget.mCharacterBloc.character != null && (widget.mCharacter.id == widget.mCharacterBloc.character.id));
          
          if (!selected) {
            return Container(
              padding: const EdgeInsets.all(4),
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          widget.mCharacter.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  )
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.mCharacter.image)
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 3,
                      spreadRadius: 3,
                      color: Colors.black26
                    )
                  ]
                ),
            );
          }
          return Container();
        },  
      ),
    );
  }
}

class _CharacterInheritedWidget extends InheritedWidget {

  final Widget child;
  final CharacterBloc characterBloc;
  final String string;

  _CharacterInheritedWidget({this.child, this.characterBloc, this.string});

  static _CharacterInheritedWidget of(context) => context.dependOnInheritedWidgetOfExactType(); 

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

}