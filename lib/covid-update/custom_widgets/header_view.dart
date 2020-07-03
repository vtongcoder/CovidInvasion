import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HeaderView extends StatefulWidget {
  final String imagePath;
  final String headlineText;
  final String detailsText;
  final List<Color> gradientColors;
  const HeaderView({
    Key key,
    this.detailsText,
    this.headlineText,
    this.imagePath,
    this.gradientColors,
  }) : super(key: key);

  @override
  _HeaderViewState createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        height: _height / 2,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradientColors,
            // [
            //   Color(0xFF3383CD),
            //   Color(0xFF11249F),
            // ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/virus.png'),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 20,
              left: _width * 0.5 * 0.1,
              // height: _height/2,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.fitWidth,
                width: _width * 0.75,
                height: _height * 0.5 * 0.75
              ),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: Text(
                widget.headlineText + '\n' + widget.detailsText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.1),
              ),
            ),
            // Container(),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const _offset = 0;

    // Offset firstControlPoint = Offset(size.width * .25, size.height - _offset/2);
    // Offset firstEndPoint = Offset(size.width * .5, size.height - _offset);

    // Offset secondControlPoint = Offset(size.width * .75, size.height);
    // Offset secondEndPoint = Offset(size.width, size.height/2);

    final path = Path()
      ..lineTo(0, size.height - _offset)
      ..quadraticBezierTo(
          size.width / 2, size.height - 60, size.width, size.height - _offset)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
