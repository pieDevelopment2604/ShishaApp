import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shish/coursier/bloc/coursierNav.dart';
import 'package:shish/coursier/courseDetails.dart';
import '../config.dart';

class Courses extends StatefulWidget with NavStates {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  GoogleMapController mapController;
  String searchAdr;
  Position current;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon, _shishaIcon, _clientIcon;
  bool showMap;

  String telephone;
  double clientLat;
  double clientLong;
  bool go = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap = false;
    _getCurrentLocation();
    _setMarkerIcon();
  }

  void _setMarkerIcon() async {
    _shishaIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/shisha.png');
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/scooter.png',
    );
    _clientIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/marker.png',
    );
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
                  target: LatLng(current.latitude + 0.0005, current.longitude),
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
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  style: GoogleFonts.abel(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                  decoration: InputDecoration(
                                    hintText: 'Indiquer une adresse',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 15, top: 20),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: searchAndNavigate,
                                        iconSize: 30,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      searchAdr = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 24,
                          thickness: 2,
                          color: Colors.black.withOpacity(0.6),
                          indent: 0,
                          endIndent: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              color: Colors.green.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {
                                setState(() async {
                                  showMap = true;
                                  await _getCurrentLocation();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.history,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Center(
                                      child: Text(
                                    'Rafraichir',
                                    style: GoogleFonts.abel(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("courses")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  int x = 0;
                                  return !snapshot.hasData
                                      ? Center(
                                          child: Text(""),
                                        )
                                      : ListView(
                                          key: Key(snapshot.data.docs.length
                                              .toString()),
                                          children: [
                                            for (int index = 0;
                                                index <
                                                    snapshot.data.docs.length;
                                                index++)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ExpansionTile(
                                                  key: ObjectKey(index),
                                                  title: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 0.5))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(Icons
                                                              .location_on),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'srcAdresse'],
                                                            style: GoogleFonts
                                                                .abel(
                                                                    fontSize:
                                                                        16),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 38.0),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                                child: Text(
                                                              "De chez",
                                                              style: GoogleFonts.abel(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                                child: Text(
                                                              snapshot.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  "srcName"],
                                                              style: GoogleFonts
                                                                  .abel(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 38.0),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons.phone,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                                child: Text(
                                                              "Téléphone bar",
                                                              style: GoogleFonts.abel(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                                child: Text(
                                                              snapshot.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  "srcPhone"],
                                                              style: GoogleFonts
                                                                  .abel(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 24,
                                                      thickness: 2,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      indent: 60,
                                                      endIndent: 60,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 28.0),
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                        child: StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "courses")
                                                                .doc(snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id)
                                                                .collection(
                                                                    "courses")
                                                                .snapshots(),
                                                            builder: (context,
                                                                dsnapshot) {
                                                              return !dsnapshot
                                                                      .hasData
                                                                  ? Center(
                                                                      child: Text(
                                                                          ""),
                                                                    )
                                                                  : ListView(
                                                                      children: [
                                                                        for (int i =
                                                                                0;
                                                                            i < dsnapshot.data.docs.length;
                                                                            i++)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                ExpansionTile(
                                                                              title: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Icon(Icons.location_on),
                                                                                    SizedBox(
                                                                                      width: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      dsnapshot.data.docs[i].data()['clientAdr'],
                                                                                      style: GoogleFonts.abel(fontSize: 16),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              children: [
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                                    stream: FirebaseFirestore.instance.collection("clients").doc(dsnapshot.data.docs[i].id).snapshots(),
                                                                                    builder: (context, ddsnapshot) {
                                                                                      !ddsnapshot.hasData ? telephone = "" : telephone = ddsnapshot.data.data()[Shish.clientPhone];
                                                                                      !ddsnapshot.hasData ? clientLat = null : clientLat = ddsnapshot.data.data()[Shish.clientLatitude];
                                                                                      !ddsnapshot.hasData ? clientLong = null : clientLong = ddsnapshot.data.data()[Shish.clientLongitude];
                                                                                      return !ddsnapshot.hasData
                                                                                          ? Center(
                                                                                              child: Text(""),
                                                                                            )
                                                                                          : Table(
                                                                                              children: [
                                                                                                TableRow(children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Icon(Icons.location_on, size: 18),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Center(
                                                                                                        child: Text(
                                                                                                      "Adresse client",
                                                                                                      style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                                    )),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Center(
                                                                                                        child: SingleChildScrollView(
                                                                                                      child: Text(
                                                                                                        dsnapshot.data.docs[i].data()['clientAdr'],
                                                                                                        style: GoogleFonts.abel(
                                                                                                          fontSize: 14,
                                                                                                        ),
                                                                                                      ),
                                                                                                      scrollDirection: Axis.horizontal,
                                                                                                    )),
                                                                                                  ),
                                                                                                ]),
                                                                                                TableRow(children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Icon(
                                                                                                      Icons.phone,
                                                                                                      size: 18,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Center(
                                                                                                        child: Text(
                                                                                                      "Téléphone client",
                                                                                                      style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                                    )),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Center(
                                                                                                        child: Text(
                                                                                                      ddsnapshot.data.data()[Shish.clientPhone],
                                                                                                      style: GoogleFonts.abel(
                                                                                                        fontSize: 14,
                                                                                                      ),
                                                                                                    )),
                                                                                                  )
                                                                                                ]),
                                                                                              ],
                                                                                            );
                                                                                    }),
                                                                                Center(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      FlatButton(
                                                                                        color: Colors.green.shade400,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => CourseDetails(course: snapshot.data.docs[index], adresseClient: dsnapshot.data.docs[i].data()['clientAdr'], clientUID: dsnapshot.data.docs[i].id, adresse: snapshot.data.docs[index].data()['srcAdresse'], telephoneClient: telephone, clientLat: clientLat, clientLong: clientLong))).then((value) async {
                                                                                            await _getCurrentLocation();
                                                                                          });
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Continuer',
                                                                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                      ],
                                                                    );
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                })),
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
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(value[0].latitude, value[0].longitude), zoom: 10)));
    });
  }

  void _getCurrentLocation() {
    _markers.clear();
    Geolocator.getCurrentPosition()
        .then((Position position) {
          setState(() {
            current = position;
            _markers.add(Marker(
                markerId: MarkerId("0"),
                position: LatLng(current.latitude, current.longitude),
                infoWindow: InfoWindow(
                    title: "Vous etes ici", snippet: "Votre position"),
                icon: _markerIcon));
          });
        })
        .catchError((e) {
          print(e);
        })
        .then((value) => null)
        .catchError((e) {
          print(e);
        })
        .then((value) {})
        .then((value) {
          setState(() {
            showMap = true;
          });
        });
  }
}
