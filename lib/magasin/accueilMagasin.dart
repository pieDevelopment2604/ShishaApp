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
import 'package:shish/bars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shish/magasin/bloc/magasin_bloc_nav.dart';
import '../config.dart';
import 'bloc/magasin_bloc_nav.dart';

class AccueilMagasin extends StatefulWidget with NaviStates {
  @override
  _AccueilMagasinState createState() => _AccueilMagasinState();
}

int selectedOption = 1;

class _AccueilMagasinState extends State<AccueilMagasin> {
  GoogleMapController mapController;
  String searchAdr;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon;
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
                .collection("magasins")
                .doc(Shish.sharedPreferences.getString(Shish.magasinUID))
                .get()
                .then((value) async {
              if (value.data()[Shish.magasinAutorise] == '1') {
                FirebaseFirestore.instance
                    .collection("magasins")
                    .doc(Shish.sharedPreferences.getString(Shish.magasinUID))
                    .update({
                  Shish.magasinLatitude: current.latitude,
                  Shish.magasinLongitude: current.longitude,
                  Shish.magasinAutorise: '2'
                });
                await Shish.sharedPreferences.setString(
                    Shish.magasinLatitude, current.latitude.toString());
                await Shish.sharedPreferences.setString(
                    Shish.magasinLongitude, current.longitude.toString());
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
    showMap = false;
    super.initState();
    if(Shish.sharedPreferences.getString('address_latitude')!=null)
    {
      var latitude=Shish.sharedPreferences.getString('address_latitude');
      var longitude=Shish.sharedPreferences.getString('address_longitude');
      mapAddress=Shish.sharedPreferences.getString('address_edit');
      lat=double.parse(latitude.toString());
      long=double.parse(longitude.toString());
      print("LATLNG ${lat.toString()}  ${long.toString()}");
      current =Position(
          latitude: lat,
          longitude: long);
      _setMarkerIcon();
      showMap = true;

    }
    else if ((Shish.sharedPreferences.getString(Shish.magasinLatitude) == '0') &&
        (Shish.sharedPreferences.getString(Shish.magasinLongitude) == '0')) {
      _getCurrentLocation();
    }
    else {
      current = Position(
          latitude: double.parse(
              Shish.sharedPreferences.getString(Shish.magasinLatitude)),
          longitude: double.parse(
              Shish.sharedPreferences.getString(Shish.magasinLongitude)));
      _setMarkerIcon();
      showMap = true;
    }
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/shop.png');
    _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(current.latitude, current.longitude),
        infoWindow:
            InfoWindow(title: mapAddress, snippet: "Votre magasin"),
        icon: _markerIcon));
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print('callinnnnn');
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
                        //       height: 55,
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
                            print('place=>>>${(await place.geolocation).coordinates}');
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
                                        .getString(Shish.magasinOuvert) ==
                                    '1'
                                ? Colors.redAccent.withOpacity(0.8)
                                : Colors.green.shade400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Text(
                                  Shish.sharedPreferences
                                              .getString(Shish.magasinOuvert) ==
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
                                      .getString(Shish.magasinOuvert) ==
                                  '1') {
                                await Shish.sharedPreferences
                                    .setString(Shish.magasinOuvert, '0');
                                await FirebaseFirestore.instance
                                    .collection("magasins")
                                    .doc(Shish.sharedPreferences
                                        .getString(Shish.magasinUID))
                                    .update({
                                  Shish.magasinOuvert: '0'
                                }).whenComplete(() {
                                  setState(() {});
                                });
                              } else {
                                await Shish.sharedPreferences
                                    .setString(Shish.magasinOuvert, '1');
                                await FirebaseFirestore.instance
                                    .collection("magasins")
                                    .doc(Shish.sharedPreferences
                                        .getString(Shish.magasinUID))
                                    .update({
                                  Shish.magasinOuvert: '1'
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
                                      magasins[1].imgPath,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)),
                                  ),
                                  Expanded(
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("magasins")
                                            .doc(Shish.sharedPreferences
                                                .getString(Shish.magasinUID))
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
                                                                            .magasinOuvert] ==
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
                                                                            .magasinOuvert] ==
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
                                                            .getString(Shish
                                                                .magasinName),
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
                                                      //                     .magasinRating]
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
                                                      //                   .magasinRating]
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
              child: Text("Veuillez attendre un instant ..."),
            ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 10));

    });
  }

  searchAndNavigate() {
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) {
      setState(() {
        _markers.add(Marker(
            markerId:
                MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
            position: LatLng(value[0].latitude, value[0].longitude),
            icon: _markerIcon));
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(value[0].latitude, value[0].longitude), zoom: 10)));
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
