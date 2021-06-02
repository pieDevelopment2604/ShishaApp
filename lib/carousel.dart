import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/bar/barLayout.dart';
import 'package:shish/client/clientLayout.dart';
import 'package:shish/config.dart';
import 'package:shish/coursier/coursierLayout.dart';
import 'package:shish/magasin/magasinLayout.dart';
import 'package:shish/main.dart';
import 'package:shish/users_accueil.dart';

final List<String> imgList = [
  'assets/c1.png',
  'assets/c2.png',
  'assets/c3.png',
];

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/coverr.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.6),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.5,
                    aspectRatio: 16 / 2,
                    viewportFraction: 0.7,
                    reverse: false,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: imgList.map((
                  item,
                ) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Image.asset(
                                  item,
                                  height: 220,
                                  width: 220,
                                ),
                              )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      _current == 0
                                          ? 'Localisation'
                                          : _current == 1
                                              ? "Paiement"
                                              : 'Livraison',
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      _current == 0
                                          ? 'Déterminez votre position ou entrez votre adresse'
                                          : _current == 1
                                              ? "Payez via notre plateforme sécurisée "
                                              : 'Recevez votre commande rapidement',
                                      style: GoogleFonts.roboto(
                                          color: Colors.black, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 15.0,
                    height: 15.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Colors.blue
                          : Colors.lightBlueAccent.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 5,
            left: 80,
            right: 80,
            child: Container(
                child: _current == 2
                    ? FlatButton(
                        child: Text('Commencer',
                            style: GoogleFonts.roboto(
                                fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          preferences.setBool('isFirstTime', true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccueilC()));
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(22.0)),
                        color: Colors.greenAccent)
                    : null),
          )
        ],
      ),
    );
  }
}
