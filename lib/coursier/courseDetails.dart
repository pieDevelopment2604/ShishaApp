import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shish/bar/stripe/paymentService.dart';
import 'package:shish/coursier/bloc/coursierNav.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:sweetalert/sweetalert.dart';
import '../bars.dart';
import '../config.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'courses.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CourseDetails extends StatefulWidget with NavStates {
  final QueryDocumentSnapshot course;
  final String clientUID;
  final String adresse;
  final String adresseClient;
  final double distance;
  final String telephoneClient;
  final double clientLat;
  final double clientLong;

  const CourseDetails({
    Key key,
    this.course,
    this.adresse,
    this.distance,
    this.telephoneClient,
    this.clientLat,
    this.clientLong,
    this.clientUID,
    this.adresseClient,
  }) : super(key: key);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  Set<Polyline> polyline = Set<Polyline>();

  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyBFjWzxSa4FUq7ICn88jh9iUtchn8VUjd4");

  GoogleMapController mapController;
  String searchAdr;
  Position current;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon, _shishaIcon, _clientIcon;
  bool showMap;
  String adresses;
  double distances;
  int nb;

  Future _calculateDistance() async {
    distances = await (double.parse(((Geolocator.distanceBetween(
                double.parse(widget.course.data()['srcLat']),
                double.parse(widget.course.data()['srcLong']),
                widget.clientLat,
                widget.clientLong)) /
            1000)
        .toStringAsFixed(1)));
  }

  getSomePoints() async {
    await googleMapPolyline
        .getCoordinatesWithLocation(
            origin: LatLng(current.latitude, current.longitude),
            destination: LatLng(widget.clientLat, widget.clientLong),
            mode: RouteMode.driving)
        .whenComplete(() {})
        .then((value) {
      print("routecorrds.originlong++++++++++++++++++++++++++" +
          value.length.toString());
      polyline.add(new Polyline(
          polylineId: PolylineId('1'),
          visible: true,
          points: value,
          width: 6,
          color: Colors.black,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
      return null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap = false;
    StripeService.init();
    _getCurrentLocation();
    _setMarkerIcon();
    _calculateDistance().whenComplete(() => null).then((value) {
      setState(() {});
    });
    widget.course.reference
        .collection("courses")
        .doc(widget.clientUID)
        .collection('courses')
        .get()
        .then((value) {
      nb = value.docs.length;
    });
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

  bool clicked = false;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
                polylines: polyline,
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 45,
                ),
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
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(
                                    child: Text(
                                        "Veuillez passez par le bar/magasin pour récuperer la commande, ensuite la livrer à l'adresse du client, Bonne route !",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.abel(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 12,
                          thickness: 2,
                          color: Colors.black.withOpacity(0.6),
                          indent: 0,
                          endIndent: 0,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "De chez",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          widget.course.data()["srcName"],
                                          style: GoogleFonts.abel(
                                            fontSize: 14,
                                          ),
                                        )),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.add_road,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Distance ",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          distances.toString() + " km",
                                          style: GoogleFonts.abel(
                                            fontSize: 14,
                                          ),
                                        )),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Icon(Icons.location_on, size: 18),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Adresse client",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: SingleChildScrollView(
                                          child: Text(
                                            widget.adresseClient,
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
                                        child:
                                            Icon(Icons.location_on, size: 18),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Adresse bar",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: SingleChildScrollView(
                                          child: Text(
                                            widget.adresse,
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
                                          "Telephone client",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          widget.telephoneClient,
                                          style: GoogleFonts.abel(
                                            fontSize: 14,
                                          ),
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
                                          "Telephone bar",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          widget.course.data()["srcPhone"],
                                          style: GoogleFonts.abel(
                                            fontSize: 14,
                                          ),
                                        )),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Icon(Icons.shopping_cart, size: 18),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Produits",
                                          style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 20,
                                          width: double.infinity,
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('courses/' +
                                                      widget.course
                                                          .data()['srcName'] +
                                                      '/courses/' +
                                                      widget.clientUID +
                                                      '/courses')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return !snapshot.hasData
                                                    ? Center(
                                                        child:
                                                            Text('chargement'),
                                                      )
                                                    : ListView(
                                                        children: [
                                                          for (int i = 0;
                                                              i < nb;
                                                              i++)
                                                            Text(
                                                                snapshot.data
                                                                        .docs[i]
                                                                        .data()[
                                                                    'produit'],
                                                                style:
                                                                    GoogleFonts
                                                                        .abel(
                                                                  fontSize: 14,
                                                                ))
                                                        ],
                                                      );
                                              }),
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                                Divider(
                                  height: 12,
                                  thickness: 2,
                                  color: Colors.black.withOpacity(0.6),
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                Center(
                                    child: Text(
                                  'Vous avez livré la commande ?',
                                  style: GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      color: Colors.green.shade400,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () {
                                        if (!clicked) {
                                          clicked = true;
                                          double currentbalance;
                                          FirebaseFirestore.instance
                                              .collection("livreurs")
                                              .doc(Shish.sharedPreferences
                                                  .getString(Shish.livreurUID))
                                              .get()
                                              .then((value) {
                                                currentbalance = double.parse(
                                                    value.data()[
                                                        Shish.livreurBalance]);
                                              })
                                              .whenComplete(() => null)
                                              .then((value) {
                                                FirebaseFirestore.instance
                                                    .collection("livreurs")
                                                    .doc(Shish.sharedPreferences
                                                        .getString(
                                                            Shish.livreurUID))
                                                    .update({
                                                  Shish.livreurBalance:
                                                      (currentbalance +
                                                              ((distances) <= 1
                                                                  ? 2
                                                                  : ((distances) +
                                                                      1)))
                                                          .toStringAsFixed(2)
                                                });
                                              });
                                          FirebaseFirestore.instance
                                              .collection("courses")
                                              .doc(widget.course.id)
                                              .collection('courses')
                                              .doc(widget.clientUID)
                                              .delete()
                                              .whenComplete(() => null)
                                              .then((value) {
                                            FirebaseFirestore.instance
                                                .collection('courses')
                                                .doc(widget.course.id)
                                                .collection('courses')
                                                .get()
                                                .then((value) {
                                              if (value.docs.length == 0) {
                                                FirebaseFirestore.instance
                                                    .collection('courses')
                                                    .doc(widget.course.id)
                                                    .delete();
                                              }
                                            });
                                          });
                                          FirebaseFirestore.instance
                                              .collection('livreurs')
                                              .doc(Shish.sharedPreferences
                                                  .getString(Shish.livreurUID))
                                              .collection('historique')
                                              .doc()
                                              .set({
                                            'srcName':
                                                widget.course.data()["srcName"],
                                            'srcAdresse': widget.adresse,
                                            'distance':
                                                distances.toStringAsFixed(1),
                                            'clientAdr': widget.adresseClient,
                                            'total': (distances) <= 1
                                                ? 2
                                                : ((distances) + 1),
                                            'date': DateTime.now()
                                                .toLocal()
                                                .toString()
                                                .split('.')
                                                .first
                                          });
                                          _scaffoldkey.currentState
                                              .showSnackBar(new SnackBar(
                                                content: Text(
                                                    'Livraison validée avec succés'),
                                                duration: Duration(
                                                    milliseconds: 1000),
                                              ))
                                              .closed
                                              .then((value) {
                                            SweetAlert.show(context,
                                                title: "Merci à vous !",
                                                confirmButtonColor:
                                                    Colors.green.shade400,
                                                subtitle:
                                                    "Livrez d'autres commandes !",
                                                style: SweetAlertStyle.success,
                                                onPress: (bool isConfirm) {
                                              if (isConfirm) {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            Courses()));
                                              }
                                              return true;
                                            });
                                          });
                                        } else {
                                          _scaffoldkey.currentState
                                              .showSnackBar(new SnackBar(
                                            content: Text('Course déja validé'),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          ));
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Marquer comme terminée',
                                            style: GoogleFonts.abel(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
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
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) => {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(value[0].latitude, value[0].longitude),
                  zoom: 10)))
        });
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition()
        .then((Position position) {
          setState(() {
            current = position;
            _markers.add(Marker(
                markerId: MarkerId("2"),
                position: LatLng(double.parse(widget.course.data()["srcLat"]),
                    double.parse(widget.course.data()["srcLong"])),
                infoWindow: InfoWindow(
                    title: widget.course.data()["srcName"],
                    snippet: "Bar/Magasin"),
                icon: _shishaIcon));

            _markers.add(Marker(
                markerId: MarkerId("1"),
                position: LatLng(widget.clientLat, widget.clientLong),
                infoWindow: InfoWindow(title: "Client", snippet: ""),
                icon: _clientIcon));

            _markers.add(Marker(
                markerId: MarkerId("0"),
                position: LatLng(current.latitude, current.longitude),
                infoWindow: InfoWindow(
                    title: "Vous etes ici", snippet: "Votre adresse"),
                icon: _markerIcon));
          });
        })
        .catchError((e) {
          print(e);
        })
        .whenComplete(() => null)
        .then((value) {
          getSomePoints();
        })
        .then((value) => showMap = true);
  }
}
