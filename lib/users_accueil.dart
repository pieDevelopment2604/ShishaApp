import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/bar/barLayout.dart';
import 'package:shish/client/clientLayout.dart';
import 'package:shish/login.dart';

import 'coursier/coursierLayout.dart';

class AccueilC extends StatefulWidget {
  AccueilC({
    Key key,
  }) : super(key: key);

  @override
  _AccueilCState createState() => _AccueilCState();
}

class _AccueilCState extends State<AccueilC> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                WavyImageHomePage(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Choisissez le type de compte qui vous correspond :",
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Material(
                      color: Colors.blue.withBlue(240),
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Text(
                        "Client",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Login(
                                  option: 0,
                                )));
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Material(
                      color: Colors.blue.withBlue(240),
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Text(
                        "Shisha",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Login(
                                  option: 1,
                                )));
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Material(
                      color: Colors.blue.withBlue(240),
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Text(
                        "Coursier",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Login(
                                  option: 2,
                                )));
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Material(
                      color: Colors.blue.withBlue(240),
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Text(
                        "Magasin",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Login(
                                  option: 3,
                                )));
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WavyImageHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset(
        'assets/coverr.jpg',
      ),
      clipper: BottomWaveClipperHomePage(),
    );
  }
}

class BottomWaveClipperHomePage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.9);
    path.cubicTo(size.width / 3, size.height * 0.7, 2 * size.width / 3,
        size.height * 0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
