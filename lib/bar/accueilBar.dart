import 'dart:collection';

import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:shish/background.dart';
import 'package:shish/bars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shish/client/chichaLayout.dart';

import '../config.dart';
import 'bloc/bar_nav.dart';

class AccueilB extends StatefulWidget with NavStates {
  @override
  _AccueilBState createState() => _AccueilBState();
}

int selectedOption = 1;

class _AccueilBState extends State<AccueilB> {
  GoogleMapController mapController;
  String searchAdr;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _shishaIcon;
  Position current;
  String mapAddress = 'Vous etes ici';
  bool showMap;
  double lat,long;

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition()
        .then((Position position) {
          setState(() async {
            current = position;
            FirebaseFirestore.instance
                .collection("bars")
                .doc(Shish.sharedPreferences.getString(Shish.barUID))
                .get()
                .then((value) async {
              if (value.data()[Shish.barAutorise] == '1') {
                FirebaseFirestore.instance
                    .collection("bars")
                    .doc(Shish.sharedPreferences.getString(Shish.barUID))
                    .update({
                  Shish.barLatitude: current.latitude,
                  Shish.barLongitude: current.longitude,
                  Shish.barAutorise: '2'
                });
                await Shish.sharedPreferences
                    .setString(Shish.barLatitude, current.latitude.toString());
                await Shish.sharedPreferences.setString(
                    Shish.barLongitude, current.longitude.toString());
              }
            });
          });
        })
        .catchError((e) {
          print(e);
        })
        .then((value) => _setMarkerIcon())
        .then((value) {
          setState(() {
            showMap = true;
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap = false;
    if(Shish.sharedPreferences.getString('bar_address_latitude')!=null)
    {
      var latitude=Shish.sharedPreferences.getString('bar_address_latitude');
      var longitude=Shish.sharedPreferences.getString('bar_address_longitude');
      mapAddress=Shish.sharedPreferences.getString('bar_address_edit');
      lat=double.parse(latitude.toString());
      long=double.parse(longitude.toString());
      print("LATLNG ${lat.toString()}  ${long.toString()}");
      current =Position(
          latitude: lat,
          longitude: long);
      _setMarkerIcon();
      showMap = true;

    }
    else if ((Shish.sharedPreferences.getString(Shish.barLatitude) == '0') &&
        (Shish.sharedPreferences.getString(Shish.barLongitude) == '0')) {
      _getCurrentLocation();
    } else {
      current = Position(
          latitude: double.parse(
              Shish.sharedPreferences.getString(Shish.barLatitude)),
          longitude: double.parse(
              Shish.sharedPreferences.getString(Shish.barLongitude)));
      _setMarkerIcon();
      showMap = true;
    }
  }

  void _setMarkerIcon() async {
    _shishaIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/shisha.png');
    _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(current.latitude, current.longitude),
        infoWindow:
            InfoWindow(title: mapAddress, snippet: "Votre adresse"),
        icon: _shishaIcon));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showMap
          ? Stack(children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(current.latitude, current.longitude),
                  zoom: 15.0,
                ),
                onMapCreated: onMapCreated,
                markers: _markers,
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.white,
                    elevation: 220,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     Container(
                        //       width: MediaQuery.of(context).size.width,
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(50),
                        //         color: Colors.white,
                        //       ),
                        //       child: Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 8.0),
                        //         child: TextField(
                        //           style: GoogleFonts.abel(
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.black45),
                        //           decoration: InputDecoration(
                        //             hintText: 'Indiquer une adresse',
                        //             border: InputBorder.none,
                        //             contentPadding:
                        //                 EdgeInsets.only(left: 15, top: 20),
                        //             suffixIcon: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: IconButton(
                        //                 icon: Icon(Icons.search),
                        //                 onPressed: searchAndNavigate,
                        //                 iconSize: 30,
                        //               ),
                        //             ),
                        //           ),
                        //           onChanged: (val) {
                        //             setState(() {
                        //               searchAdr = val;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        SearchMapPlaceWidget(
                          apiKey: 'AIzaSyBFjWzxSa4FUq7ICn88jh9iUtchn8VUjd4',
                          // The language of the autocompletion
                          language: 'en',
                          // The position used to give better recomendations. In this case we are using the user position
                          location: LatLng(05.721160, 06.394435),
                          radius: 30000,
                          hasClearButton: true,

                          // placeType: PlaceType.cities,
                          placeholder: "chercher",
                          onSelected: (Place place) async {
                            print('place=>>>${place.description}');
                            setState(() {
                              searchAdr = place.description;
                              searchAndNavigate();
                            });
                          },
                        ),
                        Divider(
                          height: 24,
                          thickness: 2,
                          color: Colors.black.withOpacity(0.6),
                          indent: 0,
                          endIndent: 0,
                        ),
                        Center(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.3),
                          child: FlatButton(
                            color: Shish.sharedPreferences
                                        .getString(Shish.barOuvert) ==
                                    '1'
                                ? Colors.redAccent.withOpacity(0.8)
                                : Colors.green.shade400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Text(
                                  Shish.sharedPreferences
                                              .getString(Shish.barOuvert) ==
                                          '1'
                                      ? 'Fermer'
                                      : 'Ouvrir',
                                  style: GoogleFonts.abel(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () async {
                              if (Shish.sharedPreferences
                                      .getString(Shish.barOuvert) ==
                                  '1') {
                                await Shish.sharedPreferences
                                    .setString(Shish.barOuvert, '0');
                                await FirebaseFirestore.instance
                                    .collection("bars")
                                    .doc(Shish.sharedPreferences
                                        .getString(Shish.barUID))
                                    .update({
                                  Shish.barOuvert: '0'
                                }).whenComplete(() {
                                  setState(() {});
                                });
                              } else {
                                await Shish.sharedPreferences
                                    .setString(Shish.barOuvert, '1');
                                await FirebaseFirestore.instance
                                    .collection("bars")
                                    .doc(Shish.sharedPreferences
                                        .getString(Shish.barUID))
                                    .update({
                                  Shish.barOuvert: '1'
                                }).whenComplete(() {
                                  setState(() {});
                                });
                              }
                            },
                          ),
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Material(
                              animationDuration: Duration(milliseconds: 200),
                              elevation: 18,
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    child: Image.asset(
                                      bars[0].imgPath,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)),
                                  ),
                                  Expanded(
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("bars")
                                            .doc(Shish.sharedPreferences
                                                .getString(Shish.barUID))
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          return !snapshot.hasData
                                              ? Center(
                                                  child: Text("Chargement ..."),
                                                )
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Etat : " +
                                                            (snapshot.data.data()[
                                                                        Shish
                                                                            .barOuvert] ==
                                                                    '1'
                                                                ? 'Ouvert'
                                                                : 'Fermé'),
                                                        style: GoogleFonts.abel(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: snapshot.data
                                                                            .data()[
                                                                        Shish
                                                                            .barOuvert] ==
                                                                    '1'
                                                                ? Colors.green
                                                                : Colors.red),
                                                      ),
                                                      Text(
                                                        "Ceci est votre adresse,",
                                                        style: GoogleFonts.abel(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      Text(
                                                        "nos livreurs viendront à cette adresse ",
                                                        style: GoogleFonts.abel(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      Text(
                                                        "pour récuperer les commandes ",
                                                        style: GoogleFonts.abel(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      Text(
                                                        Shish.sharedPreferences
                                                            .getString(
                                                                Shish.barName),
                                                        style: GoogleFonts.abel(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // Stack(
                                                      //   children: [
                                                      //     Padding(
                                                      //       padding:
                                                      //           const EdgeInsets
                                                      //                   .only(
                                                      //               top: 8.0,
                                                      //               left: 12.0),
                                                      //       child: RatingBar(
                                                      //         initialRating: double
                                                      //             .parse(snapshot
                                                      //                 .data
                                                      //                 .data()[Shish
                                                      //                     .barRating]
                                                      //                 .toString()),
                                                      //         direction: Axis
                                                      //             .horizontal,
                                                      //         allowHalfRating:
                                                      //             true,
                                                      //         itemCount: 5,
                                                      //         ratingWidget:
                                                      //             RatingWidget(
                                                      //                 full: Image
                                                      //                     .asset(
                                                      //                   'assets/heart.png',
                                                      //                   color: Colors
                                                      //                       .redAccent,
                                                      //                 ),
                                                      //                 half: Image.asset(
                                                      //                     'assets/heart_half.png',
                                                      //                     color: Colors
                                                      //                         .redAccent),
                                                      //                 empty: Image.asset(
                                                      //                     'assets/heart_border.png',
                                                      //                     color:
                                                      //                         Colors.redAccent)),
                                                      //         itemSize: 15,
                                                      //         itemPadding: EdgeInsets
                                                      //             .symmetric(
                                                      //                 horizontal:
                                                      //                     1.0),
                                                      //         onRatingUpdate:
                                                      //             (rating) {
                                                      //           setState(() {});
                                                      //         },
                                                      //       ),
                                                      //     ),
                                                      //     Container(
                                                      //       color: Colors.black
                                                      //           .withOpacity(
                                                      //               0.01),
                                                      //       height: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .height *
                                                      //           0.05,
                                                      //       width: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width *
                                                      //           0.3,
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      // Text(
                                                      //   "Note : " +
                                                      //       double.parse(snapshot
                                                      //               .data
                                                      //               .data()[Shish
                                                      //                   .barRating]
                                                      //               .toString())
                                                      //           .toStringAsFixed(
                                                      //               1) +
                                                      //       "/5",
                                                      //   style: GoogleFonts.abel(
                                                      //       fontSize: 14,
                                                      //       fontWeight:
                                                      //           FontWeight
                                                      //               .bold),
                                                      // ),
                                                    ],
                                                  ),
                                                );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ])
          : Center(
              child: Text('Veuillez attendre un instant !'),
            ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchAndNavigate() {
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) {
      setState(() {
        _markers.add(Marker(
            markerId:
                MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
            position: LatLng(value[0].latitude, value[0].longitude),
            icon: _shishaIcon));
      });
      return mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(value[0].latitude, value[0].longitude),
              zoom: 10)));
    });
  }
}

bool rated = false;

class PlatCardShape extends ShapeBorder {
  final double width;
  final double height;

  const PlatCardShape(this.width, this.height);
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(Size(width, height));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }

  Path getClip(Size size) {
    Path clippedPath = new Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.27);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }
}
