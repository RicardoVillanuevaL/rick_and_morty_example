import 'package:flutter/material.dart';
import 'package:rick_and_morty_example/pages/episodes_page.dart';
import 'package:rick_and_morty_example/pages/locations_page.dart';

import 'characters_page.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MenuCard(
          mLabel: "Characters",
          mOnPressed: () => _goToPage(context, CharactersPage()),
        ),
        _MenuCard(
          mLabel: "Locations",
          mLeft: false,
          mOnPressed: () => _goToPage(context, LocationsPage()),
        ),
        _MenuCard(
          mLabel: "Episodes",
          mOnPressed: () => _goToPage(context, EpisodesPage()),
        ),
      ],
    );
  }

  void _goToPage(context, Widget mNewPage) {
    Navigator.of(context).push(
      MaterialPageRoute(builder:(_) => mNewPage)
    );
  } 
}

class _MenuCard extends StatefulWidget {

  final String mLabel;
  final Function mOnPressed;
  final bool mLeft;

  const _MenuCard({
    Key key, 
    @required this.mLabel, 
    this.mOnPressed,
    this.mLeft = true,
  }) : super(key: key);

  @override
  __MenuCardState createState() => __MenuCardState();
}

class __MenuCardState extends State<_MenuCard> {
  
  final _cardHorizontalMargin = 24.0;
  final _menuRadius = 16.0;
  final _cardPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      curve: Curves.elasticInOut,
        duration: const Duration(seconds: 2),
        tween: Tween(begin: -1.0, end: 0.0),
        child: GestureDetector(
          onTap: widget.mOnPressed,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_menuRadius),
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius:5
                )
              ]
            ),
            padding: EdgeInsets.all(_cardPadding),
            margin: EdgeInsets.symmetric(
              horizontal: _cardHorizontalMargin
            ),
            alignment: Alignment.bottomRight,
            child: Text(
              widget.mLabel,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
          ),
        ),
        builder: (BuildContext context, dynamic value, Widget child) {
          final offsetValue = MediaQuery.of(context).size.width * value;
          return Transform.translate(
            offset: Offset(
              widget.mLeft ? offsetValue : -offsetValue, 0.0
            ),
            child: Transform.scale(
              scale: value + 1.0,
              child: child,
            ),
          );
         },
     );
  }
}