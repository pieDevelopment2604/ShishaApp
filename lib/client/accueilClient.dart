import 'dart:collection';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shish/background.dart';
import 'package:shish/bars.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/client/chichaLayout.dart';

import '../config.dart';
import 'magasin.dart';

class Accueil extends StatefulWidget with NavigationStates {
  @override
  _AccueilState createState() => _AccueilState();
}

int selectedOption = 1;

class _AccueilState extends State<Accueil> with SingleTickerProviderStateMixin {
  List<double> distances = [];
  List<String> barindex = [];
  List<String> barName = [];
  List<String> filteredBarName = [];
  List<String> filteredBarIndex = [];
  List<double> filterDistances = [];

  List<String> magindex = [];
  List<String> magName = [];
  List<String> filteredMagName = [];
  List<String> filteredMagIndex = [];
  List<double> filterDistancesMag = [];
  List<double> distancesMag = [];

  bool isFiltered = false;
  GoogleMapController mapController;
  String searchAdr;
  Position current;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon, _shishaIcon, _magaIcon;
  bool showMap;
  bool rated;
  int tabIndex = 0;
  final searchController = TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap = false;
    rated = false;
    _getCurrentLocation();
    _setMarkerIcon();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
        print("tabIndex: $tabIndex");
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future _calculateDistances() async {
    int i = 0;
    int j = 0;
    distances.clear();
    barindex.clear();
    distancesMag.clear();
    magindex.clear();
    FirebaseFirestore.instance.collection("bars").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) async {
        if (((Geolocator.distanceBetween(
                        current != null ? current.latitude : 0,
                        current != null ? current.longitude : 0,
                        double.parse(element.data()[Shish.barLatitude].toString()),
                        double.parse(element.data()[Shish.barLongitude].toString())) /
                    1000) <
                5.0) &&
            (element.data()[Shish.barAutorise] == '2') &&
            (element.data()[Shish.barOuvert] == '1')) {
          distances.add(double.parse((Geolocator.distanceBetween(
                      current != null ? current.latitude : 0,
                      current != null ? current.longitude : 0,
                      double.parse(element.data()[Shish.barLatitude].toString()),
                      double.parse(element.data()[Shish.barLongitude].toString())) /
                  1000)
              .toStringAsFixed(1)));
          barindex.add(element.id);
          barName.add(element.data()[Shish.barName]);
          print('barMag=>>>${element.data()[Shish.barName]}');
        }
      });
    });
    FirebaseFirestore.instance.collection("magasins").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        // print('************************' +
        //     double.parse((Geolocator.distanceBetween(
        //                     current.latitude,
        //                     current.longitude,
        //                     element.data()[Shish.magasinLatitude],
        //                     element.data()[Shish.magasinLongitude]) /
        //                 1000)
        //             .toStringAsFixed(1))
        //         .toString());
        // print('element ${element.get('magasinEmail')}');

        distancesMag.add(double.parse((Geolocator.distanceBetween(
                    current != null ? current.latitude : 0,
                    current != null ? current.longitude : 0,
                    double.parse(element.data()[Shish.magasinLatitude]?.toString() ?? "0.0"),
                    double.parse(element.data()[Shish.magasinLongitude]?.toString() ?? "0.0")) /
                1000)
            .toStringAsFixed(1)));
        print('distancesMag=>>>$distancesMag');
        magindex.add(element.id);
        magName.add(element.data()[Shish.magasinName]);
        print('distancesMag=>>>${element.data()[Shish.magasinName]}');

        if (((Geolocator.distanceBetween(
                        current != null ? current.latitude : 0,
                        current != null ? current.longitude : 0,
                        double.parse(element.data()[Shish.magasinLatitude]?.toString() ?? "0.0"),
                        double.parse(element.data()[Shish.magasinLongitude]?.toString() ?? "0.0")) /
                    1000) <
                5.0) &&
            (element.data()[Shish.magasinAutorise] == '2') &&
            (element.data()[Shish.magasinOuvert] == '1')) {
          distancesMag.add(double.parse((Geolocator.distanceBetween(
                      current != null ? current.latitude : 0,
                      current != null ? current.longitude : 0,
                      double.parse(element.data()[Shish.magasinLatitude]?.toString() ?? "0.0"),
                      double.parse(element.data()[Shish.magasinLongitude]?.toString() ?? "0.0")) /
                  1000)
              .toStringAsFixed(1)));
          print('distancesMag=>>>$distancesMag');
          magindex.add(element.id);
        }
      });
      print('distancesMag1=>>>$distancesMag');
      print('distancesMag1=>>>$magName');
    });
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/marker.png');
    _shishaIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/shisha.png');
    _magaIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/shop.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showMap
          ? NestedScrollView(
              headerSliverBuilder: (context, bool) {
                return [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 1.8,
                    floating: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: GoogleMap(
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(current.latitude, current.longitude),
                          zoom: 15.0,
                        ),
                        onMapCreated: onMapCreated,
                        markers: _markers,
                      ),
                    ),
                  )
                ];
              },
              body: Material(
                color: Colors.white,
                elevation: 220,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: searchController,
                              style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black45),
                              decoration: InputDecoration(
                                hintText: tabIndex == 0 ? "tapez le nom d'un Bar" : "tapez le nom d'un Magasin",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15, top: 20),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(isFiltered ? Icons.close : Icons.search),
                                    onPressed: () {
                                      if (tabIndex == 0) {
                                        if (isFiltered) {
                                          FocusScope.of(context).unfocus();
                                          searchController.clear();
                                          clearfilterBar();
                                        } else {
                                          if (searchController.text.isNotEmpty) {
                                            FocusScope.of(context).unfocus();
                                            filterBar(searchController.text);
                                          }
                                        }
                                      } else {
                                        if (isFiltered) {
                                          FocusScope.of(context).unfocus();
                                          searchController.clear();
                                          clearfilterMagsin();
                                        } else {
                                          if (searchController.text.isNotEmpty) {
                                            FocusScope.of(context).unfocus();
                                            filterMagsin(searchController.text);
                                          }
                                        }
                                      }
                                    },
                                    iconSize: 30,
                                  ),
                                ),
                              ),
                              /*onChanged: (val) {
                                filterMagsin (val);
                                 setState(() {
                                  searchAdr = val;
                                });
                              },*/
                            ),
                          ),
                        ),
                      ],
                    ),

                    // SearchMapPlaceWidget(
                    //   apiKey: 'AIzaSyBFjWzxSa4FUq7ICn88jh9iUtchn8VUjd4',
                    //   // The language of the autocompletion
                    //   language: 'en',
                    //   // The position used to give better recomendations. In this case we are using the user position
                    //   location: LatLng(05.721160, 06.394435),
                    //   radius: 30000,
                    //   hasClearButton: true,
                    //
                    //   placeType: PlaceType.cities,
                    //   onSelected: (Place place) async {
                    //     //   final geolocation = await place.geolocation;
                    //     //
                    //     //   // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                    //     //   final GoogleMapController controller = await _mapController.future;
                    //     //   controller
                    //     //       .animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                    //     //   controller.animateCamera(
                    //     //       CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                    //     print('place=>>>${place.description}');
                    //     setState(() {
                    //       searchAdr = place.description;
                    //       searchAndNavigate();
                    //     });
                    //   },
                    // ),

                    Divider(
                      height: 24,
                      thickness: 2,
                      color: Colors.black.withOpacity(0.6),
                      indent: 0,
                      endIndent: 0,
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width,
                    //     // height: MediaQuery.of(context).size.height * 0.3,
                    //     child: DefaultTabController(
                    //       length: 2,
                    //       child: Column(
                    //         children: [
                    //           ButtonsTabBar(
                    //               backgroundColor: Colors.green.shade100,
                    //               unselectedBackgroundColor: Colors.white,
                    //               labelStyle: TextStyle(
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.bold),
                    //               borderColor: Colors.white,
                    //               unselectedLabelStyle:
                    //                   TextStyle(color: Colors.black),
                    //               buttonMargin: EdgeInsets.symmetric(
                    //                   horizontal:
                    //                       MediaQuery.of(context).size.width *
                    //                           0.13),
                    //               tabs: [
                    //                 Tab(
                    //                   text: "Bars",
                    //                 ),
                    //                 Tab(
                    //                   text: "Magasins",
                    //                 )
                    //               ]),
                    //           Expanded(
                    //             child: TabBarView(children: [
                    //               Center(
                    //                 child: PageView.builder(
                    //                   itemCount: distances.length,
                    //                   controller: PageController(
                    //                       viewportFraction: 0.85),
                    //                   itemBuilder: (context, index) {
                    //                     double lat;
                    //                     double long;
                    //                     DocumentSnapshot snap;
                    //                     return Padding(
                    //                       padding: EdgeInsets.all(15),
                    //                       child: InkWell(
                    //                         child: Material(
                    //                           animationDuration:
                    //                               Duration(milliseconds: 200),
                    //                           elevation: 18,
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.start,
                    //                             children: [
                    //                               SizedBox(
                    //                                 width:
                    //                                     MediaQuery.of(context)
                    //                                             .size
                    //                                             .width *
                    //                                         0.3,
                    //                                 height:
                    //                                     MediaQuery.of(context)
                    //                                         .size
                    //                                         .height,
                    //                                 child: ClipRRect(
                    //                                   child: Image.asset(
                    //                                     'assets/1.jpg',
                    //                                     fit: BoxFit.cover,
                    //                                   ),
                    //                                   borderRadius:
                    //                                       BorderRadius.only(
                    //                                           bottomLeft: Radius
                    //                                               .circular(8),
                    //                                           topLeft: Radius
                    //                                               .circular(8)),
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 width:
                    //                                     MediaQuery.of(context)
                    //                                             .size
                    //                                             .width *
                    //                                         0.04,
                    //                               ),
                    //                               StreamBuilder<
                    //                                       DocumentSnapshot>(
                    //                                   stream: FirebaseFirestore
                    //                                       .instance
                    //                                       .collection("bars")
                    //                                       .doc(barindex[index])
                    //                                       .snapshots(),
                    //                                   builder:
                    //                                       (context, snapshot) {
                    //                                     if (snapshot.hasData) {
                    //                                       lat = snapshot.data
                    //                                               .data()[
                    //                                           Shish
                    //                                               .barLatitude];
                    //                                       long = snapshot.data
                    //                                               .data()[
                    //                                           Shish
                    //                                               .barLongitude];
                    //                                       snap = snapshot.data;
                    //                                     }
                    //                                     return !snapshot.hasData
                    //                                         ? Center(
                    //                                             child: Text(
                    //                                                 "Chargement"),
                    //                                           )
                    //                                         : Column(
                    //                                             crossAxisAlignment:
                    //                                                 CrossAxisAlignment
                    //                                                     .center,
                    //                                             mainAxisAlignment:
                    //                                                 MainAxisAlignment
                    //                                                     .center,
                    //                                             children: [
                    //                                               Text(
                    //                                                 snapshot.data
                    //                                                         .data()[
                    //                                                     Shish
                    //                                                         .barName],
                    //                                                 style: GoogleFonts.abel(
                    //                                                     fontSize:
                    //                                                         18,
                    //                                                     fontWeight:
                    //                                                         FontWeight.bold),
                    //                                               ),
                    //                                               Text(
                    //                                                 "Distance : " +
                    //                                                     (distances ==
                    //                                                             null
                    //                                                         ? 'Calcul ...'
                    //                                                         : distances[index].toString()) +
                    //                                                     " Km",
                    //                                                 style: GoogleFonts.abel(
                    //                                                     fontSize:
                    //                                                         14,
                    //                                                     fontWeight:
                    //                                                         FontWeight.bold),
                    //                                               ),
                    //                                               Text(
                    //                                                 "Livraison à : " +
                    //                                                     (distances ==
                    //                                                             null
                    //                                                         ? 'Calcul ...'
                    //                                                         : distances[index] < 1
                    //                                                             ? '2 €'
                    //                                                             : (distances[index] + 1).toString() + ' €'),
                    //                                                 style: GoogleFonts.abel(
                    //                                                     fontSize:
                    //                                                         12,
                    //                                                     fontWeight:
                    //                                                         FontWeight.normal),
                    //                                               ),
                    //                                               Stack(
                    //                                                 children: [
                    //                                                   Padding(
                    //                                                     padding: const EdgeInsets.only(
                    //                                                         top:
                    //                                                             8.0,
                    //                                                         left:
                    //                                                             12.0),
                    //                                                     child:
                    //                                                         RatingBar(
                    //                                                       initialRating: double.parse(snapshot
                    //                                                           .data
                    //                                                           .data()[Shish.barRating]
                    //                                                           .toString()),
                    //                                                       direction:
                    //                                                           Axis.horizontal,
                    //                                                       allowHalfRating:
                    //                                                           true,
                    //                                                       itemCount:
                    //                                                           5,
                    //                                                       ratingWidget: RatingWidget(
                    //                                                           full: Image.asset(
                    //                                                             'assets/heart.png',
                    //                                                             color: Colors.redAccent,
                    //                                                           ),
                    //                                                           half: Image.asset('assets/heart_half.png', color: Colors.redAccent),
                    //                                                           empty: Image.asset('assets/heart_border.png', color: Colors.redAccent)),
                    //                                                       itemSize:
                    //                                                           15,
                    //                                                       itemPadding:
                    //                                                           EdgeInsets.symmetric(horizontal: 1.0),
                    //                                                       onRatingUpdate:
                    //                                                           (rating) {
                    //                                                         setState(() {});
                    //                                                       },
                    //                                                     ),
                    //                                                   ),
                    //                                                   Container(
                    //                                                     color: Colors
                    //                                                         .black
                    //                                                         .withOpacity(0.01),
                    //                                                     height: MediaQuery.of(context).size.height *
                    //                                                         0.05,
                    //                                                     width: MediaQuery.of(context).size.width *
                    //                                                         0.3,
                    //                                                   ),
                    //                                                 ],
                    //                                               ),
                    //                                               Text(
                    //                                                 "Note : " +
                    //                                                     double.parse(snapshot.data.data()[Shish.barRating].toString())
                    //                                                         .toStringAsFixed(1) +
                    //                                                     "/5",
                    //                                                 style: GoogleFonts.abel(
                    //                                                     fontSize:
                    //                                                         14,
                    //                                                     fontWeight:
                    //                                                         FontWeight.bold),
                    //                                               ),
                    //                                             ],
                    //                                           );
                    //                                   })
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         onTap: () async {
                    //                           final coordinates =
                    //                               new Coordinates(lat, long);
                    //                           await Geocoder.local
                    //                               .findAddressesFromCoordinates(
                    //                                   coordinates)
                    //                               .then((value) => Navigator.push(
                    //                                   context,
                    //                                   PageRouteBuilder(
                    //                                       transitionDuration:
                    //                                           const Duration(
                    //                                               milliseconds:
                    //                                                   350),
                    //                                       pageBuilder: (context,
                    //                                               _, __) =>
                    //                                           BarDetails(
                    //                                               bar: snap,
                    //                                               adr: value
                    //                                                   .first
                    //                                                   .addressLine,
                    //                                               distance:
                    //                                                   distances[
                    //                                                       index]))));
                    //                         },
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               ),
                    //               StreamBuilder<QuerySnapshot>(
                    //                   stream: FirebaseFirestore.instance
                    //                       .collection("magasins/" +
                    //                           Shish.sharedPreferences
                    //                               .getString(Shish.magasinUID) +
                    //                           "/produits")
                    //                       .snapshots(),
                    //                   builder: (context, datasnapshot) {
                    //                     return !datasnapshot.hasData
                    //                         ? Center(
                    //                             child: Text(
                    //                                 "Veuillez ajouter des produits"),
                    //                           )
                    //                         : SizedBox(
                    //                             height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height,
                    //                             width: double.infinity,
                    //                             child: ListView.builder(
                    //                               itemCount: datasnapshot
                    //                                   .data.docs.length,
                    //                               itemBuilder:
                    //                                   (context, index) {
                    //                                 return Column(
                    //                                   crossAxisAlignment:
                    //                                       CrossAxisAlignment
                    //                                           .start,
                    //                                   children: [
                    //                                     Padding(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                                   .only(
                    //                                               left: 30),
                    //                                       child: Text(
                    //                                         datasnapshot.data
                    //                                             .docs[index]
                    //                                             .data()["id"],
                    //                                         style: GoogleFonts.abel(
                    //                                             color: Colors
                    //                                                 .black,
                    //                                             fontSize: 18,
                    //                                             fontWeight:
                    //                                                 FontWeight
                    //                                                     .bold),
                    //                                       ),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       height: MediaQuery.of(
                    //                                                   context)
                    //                                               .size
                    //                                               .height *
                    //                                           0.38,
                    //                                       child: StreamBuilder<
                    //                                               QuerySnapshot>(
                    //                                           stream: FirebaseFirestore
                    //                                               .instance
                    //                                               .collection("magasins/" +
                    //                                                   Shish
                    //                                                       .sharedPreferences
                    //                                                       .getString(Shish
                    //                                                           .magasinUID) +
                    //                                                   "/produits/" +
                    //                                                   datasnapshot
                    //                                                           .data
                    //                                                           .docs[
                    //                                                               index]
                    //                                                           .data()[
                    //                                                       "id"] +
                    //                                                   "/articles")
                    //                                               .snapshots(),
                    //                                           builder: (context,
                    //                                               snapshot) {
                    //                                             return !snapshot
                    //                                                     .hasData
                    //                                                 ? Center(
                    //                                                     child: Text(
                    //                                                         "..."),
                    //                                                   )
                    //                                                 : PageView
                    //                                                     .builder(
                    //                                                     itemCount: snapshot
                    //                                                         .data
                    //                                                         .docs
                    //                                                         .length,
                    //                                                     controller:
                    //                                                         PageController(viewportFraction: 0.8),
                    //                                                     itemBuilder:
                    //                                                         (context,
                    //                                                             i) {
                    //                                                       return InkResponse(
                    //                                                         onTap:
                    //                                                             () {
                    //                                                           Navigator.push(
                    //                                                               context,
                    //                                                               new MaterialPageRoute(
                    //                                                                   builder: (context) => Magasin(
                    //                                                                         magasin: snapshot.data.docs[i],
                    //                                                                         distance: distancesMag[index],
                    //                                                                       )));
                    //                                                         },
                    //                                                         child:
                    //                                                             Container(
                    //                                                           margin: EdgeInsets.symmetric(
                    //                                                             horizontal: 10,
                    //                                                           ),
                    //                                                           child: Stack(
                    //                                                             children: [
                    //                                                               Hero(
                    //                                                                 tag: "background-${i.toString()}",
                    //                                                                 child: Material(
                    //                                                                   elevation: 10,
                    //                                                                   shape: PlatCardShape(MediaQuery.of(context).size.width * 0.55, MediaQuery.of(context).size.height * 0.32),
                    //                                                                   color: Colors.white,
                    //                                                                 ),
                    //                                                               ),
                    //                                                               Padding(
                    //                                                                 padding: const EdgeInsets.fromLTRB(70, 12, 0, 0),
                    //                                                                 child: Align(
                    //                                                                   child: Image.network(
                    //                                                                     snapshot.data.docs[i].data()['img'],
                    //                                                                     height: 100,
                    //                                                                     width: 100,
                    //                                                                   ),
                    //                                                                   alignment: Alignment(0, 1),
                    //                                                                 ),
                    //                                                               ),
                    //                                                               Positioned(
                    //                                                                 top: 80,
                    //                                                                 left: 15,
                    //                                                                 right: 32,
                    //                                                                 child: Column(
                    //                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                                                                   children: <Widget>[
                    //                                                                     Row(
                    //                                                                       mainAxisAlignment: MainAxisAlignment.center,
                    //                                                                       children: [
                    //                                                                         Text(
                    //                                                                           snapshot.data.docs[i].data()["nom"],
                    //                                                                           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    //                                                                         ),
                    //                                                                       ],
                    //                                                                     ),
                    //                                                                     SizedBox(
                    //                                                                       height: MediaQuery.of(context).size.height * 0.02,
                    //                                                                     ),
                    //                                                                     Text(
                    //                                                                       "Prix : " + (double.parse(snapshot.data.docs[i].data()["prix"]) * 0.83333).toStringAsFixed(2) + " €",
                    //                                                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    //                                                                     ),
                    //                                                                     // Padding(
                    //                                                                     //   padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.13),
                    //                                                                     //   child: FlatButton(
                    //                                                                     //     color: snapshot.data.docs[i].data()['etat'] == '1' ? Colors.redAccent.withOpacity(0.8) : Colors.green.shade400,
                    //                                                                     //     child: Row(
                    //                                                                     //       children: <Widget>[
                    //                                                                     //         Icon(snapshot.data.docs[i].data()['etat'] == '1' ? Icons.pause : Icons.play_arrow),
                    //                                                                     //         SizedBox(
                    //                                                                     //           width: MediaQuery.of(context).size.width * 0.01,
                    //                                                                     //         ),
                    //                                                                     //         Text(
                    //                                                                     //           snapshot.data.docs[i].data()['etat'] == '1' ? 'Suspendre' : 'Activer',
                    //                                                                     //           style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                    //                                                                     //         ),
                    //                                                                     //       ],
                    //                                                                     //     ),
                    //                                                                     //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    //                                                                     //     onPressed: () async {
                    //                                                                     //       snapshot.data.docs[i].data()['etat'] == '1'
                    //                                                                     //           ? await FirebaseFirestore.instance.collection("magasins/" + Shish.sharedPreferences.getString(Shish.magasinUID) + "/produits/" + datasnapshot.data.docs[index].data()["id"] + "/articles").doc(snapshot.data.docs[i].id).update({'etat': '0'}).whenComplete(() {
                    //                                                                     //               setState(() {});
                    //                                                                     //             })
                    //                                                                     //           : await FirebaseFirestore.instance.collection("magasins/" + Shish.sharedPreferences.getString(Shish.magasinUID) + "/produits/" + datasnapshot.data.docs[index].data()["id"] + "/articles").doc(snapshot.data.docs[i].id).update({'etat': '1'}).whenComplete(() {
                    //                                                                     //               setState(() {});
                    //                                                                     //             });
                    //                                                                     //     },
                    //                                                                     //   ),
                    //                                                                     // )
                    //                                                                     SizedBox(
                    //                                                                       width: 180,
                    //                                                                       child: RaisedButton(
                    //                                                                         onPressed: () {
                    //                                                                           print('${datasnapshot.data.docs[index].data()["id"] + "/articles/" + snapshot.data.docs[i].id}');
                    //                                                                           Firestore.instance.collection('AddToCart').add({
                    //                                                                             'collectionPath': '${"magasins/" + Shish.sharedPreferences.getString(Shish.magasinUID) + "/produits/" + datasnapshot.data.docs[index].data()["id"] + "/articles"}',
                    //                                                                             'mainId': Shish.sharedPreferences.getString(Shish.magasinUID),
                    //                                                                             'docId': snapshot.data.docs[i].id
                    //                                                                           }).then((value) {
                    //                                                                             return Toast.show('Items add in card', context);
                    //                                                                           }).catchError((e) => print('error $e'));
                    //                                                                         },
                    //                                                                         color: Colors.green[800],
                    //                                                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    //                                                                         child: Align(
                    //                                                                           alignment: Alignment.centerLeft,
                    //                                                                           child: Row(
                    //                                                                             mainAxisSize: MainAxisSize.min,
                    //                                                                             mainAxisAlignment: MainAxisAlignment.start,
                    //                                                                             children: [
                    //                                                                               Icon(Icons.add_shopping_cart),
                    //                                                                               SizedBox(
                    //                                                                                 width: 5,
                    //                                                                               ),
                    //                                                                               Text(
                    //                                                                                 'Add to cart',
                    //                                                                                 style: TextStyle(color: Colors.black),
                    //                                                                               ),
                    //                                                                             ],
                    //                                                                           ),
                    //                                                                         ),
                    //                                                                       ),
                    //                                                                     )
                    //                                                                   ],
                    //                                                                 ),
                    //                                                               ),
                    //                                                             ],
                    //                                                           ),
                    //                                                         ),
                    //                                                       );
                    //                                                     },
                    //                                                   );
                    //                                           }),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       height: 50,
                    //                                     )
                    //                                   ],
                    //                                 );
                    //                               },
                    //                             ),
                    //                           );
                    //                   }),
                    //             ]),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: DefaultTabController(
                        length: 2,
                        child: Builder(builder: (BuildContext context) {
                          return Column(
                            children: [
                              /*Row(
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
                                        controller: searchController,
                                        style: GoogleFonts.abel(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                        decoration: InputDecoration(
                                          hintText: 'type a name of a magasign',
                                          border: InputBorder.none,
                                          contentPadding:
                                          EdgeInsets.only(left: 15, top: 20),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              icon: Icon(isFiltered ?  Icons.close : Icons.search),
                                              onPressed: () {
                                                if(isFiltered) {
                                                  FocusScope.of(context).unfocus();
                                                  searchController.clear();
                                                  clearfilterMagsin();
                                                } else{
                                                  if (searchController.text.isNotEmpty) {
                                                    FocusScope.of(context).unfocus();
                                                    filterMagsin(searchController.text);
                                                  }
                                                }
                                              },
                                              iconSize: 30,
                                            ),
                                          ),
                                        ),
                                        */ /*onChanged: (val) {
                                  filterMagsin (val);
                                  */ /* */ /*setState(() {
                                    searchAdr = val;
                                  });*/ /* */ /*
                                },*/ /*
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
                              ),*/
                              ButtonsTabBar(
                                  controller: _tabController,
                                  backgroundColor: Colors.green.shade100,
                                  unselectedBackgroundColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  borderColor: Colors.white,
                                  unselectedLabelStyle: TextStyle(color: Colors.black),
                                  buttonMargin:
                                      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.13),
                                  tabs: [
                                    Tab(
                                      text: "Bars",
                                    ),
                                    Tab(
                                      text: "Magasins",
                                    )
                                  ]),
                              Expanded(
                                child: TabBarView(controller: _tabController, children: [
                                  Center(
                                    child: (isFiltered && filterDistances.length > 0) ||
                                            (!isFiltered && distances.length > 0)
                                        ? PageView.builder(
                                            itemCount: isFiltered ? filterDistances.length : distances.length,
                                            controller: PageController(viewportFraction: 0.85),
                                            itemBuilder: (context, index) {
                                              double lat;
                                              double long;
                                              DocumentSnapshot snap;
                                              return Padding(
                                                padding: EdgeInsets.all(15),
                                                child: InkWell(
                                                  child: Material(
                                                    animationDuration: Duration(milliseconds: 200),
                                                    elevation: 18,
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.3,
                                                          height: MediaQuery.of(context).size.height,
                                                          child: ClipRRect(
                                                            child: Image.asset(
                                                              'assets/1.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(8),
                                                                topLeft: Radius.circular(8)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.04,
                                                        ),
                                                        StreamBuilder<DocumentSnapshot>(
                                                            stream: FirebaseFirestore.instance
                                                                .collection("bars")
                                                                .doc(isFiltered
                                                                    ? filteredBarIndex[index]
                                                                    : barindex[index])
                                                                .snapshots(),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) {
                                                                lat = snapshot.data.data()[Shish.barLatitude];
                                                                long = snapshot.data.data()[Shish.barLongitude];
                                                                snap = snapshot.data;
                                                              }
                                                              return !snapshot.hasData
                                                                  ? Center(
                                                                      child: Text("Chargement"),
                                                                    )
                                                                  : Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          snapshot.data.data()[Shish.barName],
                                                                          style: GoogleFonts.abel(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.place, size: 18),
                                                                            const SizedBox(width: 7),
                                                                            Text(
                                                                              isFiltered
                                                                                  ? "Distance : " +
                                                                                      (filterDistances == null
                                                                                          ? 'Calcul ...'
                                                                                          : filterDistances[index]
                                                                                              .toString()) +
                                                                                      " Km"
                                                                                  : "Distance : " +
                                                                                      (distances == null
                                                                                          ? 'Calcul ...'
                                                                                          : distances[index]
                                                                                              .toString()) +
                                                                                      " Km",
                                                                              style: GoogleFonts.abel(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.money, size: 14),
                                                                            const SizedBox(width: 10),
                                                                            Text(
                                                                              isFiltered
                                                                                  ? "Livraison à : " +
                                                                                      (filterDistances == null
                                                                                          ? 'Calcul ...'
                                                                                          : filterDistances[index] < 1
                                                                                              ? '2 €'
                                                                                              : (filterDistances[
                                                                                                              index] +
                                                                                                          1)
                                                                                                      .toString() +
                                                                                                  ' €')
                                                                                  : "Livraison à : " +
                                                                                      (distances == null
                                                                                          ? 'Calcul ...'
                                                                                          : distances[index] < 1
                                                                                              ? '2 €'
                                                                                              : (distances[index] + 1)
                                                                                                      .toString() +
                                                                                                  ' €'),
                                                                              style: GoogleFonts.abel(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // Stack(
                                                                        //   children: [
                                                                        //     Padding(
                                                                        //       padding: const EdgeInsets.only(
                                                                        //           top: 8.0, left: 12.0),
                                                                        //       child: RatingBar(
                                                                        //         initialRating: double.parse(snapshot
                                                                        //             .data
                                                                        //             .data()[Shish.barRating]
                                                                        //             .toString()),
                                                                        //         direction: Axis.horizontal,
                                                                        //         allowHalfRating: true,
                                                                        //         itemCount: 5,
                                                                        //         ratingWidget: RatingWidget(
                                                                        //             full: Image.asset(
                                                                        //               'assets/heart.png',
                                                                        //               color: Colors.redAccent,
                                                                        //             ),
                                                                        //             half: Image.asset(
                                                                        //                 'assets/heart_half.png',
                                                                        //                 color: Colors.redAccent),
                                                                        //             empty: Image.asset(
                                                                        //                 'assets/heart_border.png',
                                                                        //                 color: Colors.redAccent)),
                                                                        //         itemSize: 15,
                                                                        //         itemPadding: EdgeInsets.symmetric(
                                                                        //             horizontal: 1.0),
                                                                        //         onRatingUpdate: (rating) {
                                                                        //           setState(() {});
                                                                        //         },
                                                                        //       ),
                                                                        //     ),
                                                                        //     Container(
                                                                        //       color: Colors.black.withOpacity(0.01),
                                                                        //       height:
                                                                        //           MediaQuery.of(context).size.height *
                                                                        //               0.05,
                                                                        //       width: MediaQuery.of(context).size.width *
                                                                        //           0.3,
                                                                        //     ),
                                                                        //   ],
                                                                        // ),
                                                                        // Text(
                                                                        //   "Note : " +
                                                                        //       double.parse(snapshot.data
                                                                        //               .data()[Shish.barRating]
                                                                        //               .toString())
                                                                        //           .toStringAsFixed(1) +
                                                                        //       "/5",
                                                                        //   style: GoogleFonts.abel(
                                                                        //       fontSize: 14,
                                                                        //       fontWeight: FontWeight.bold),
                                                                        // ),
                                                                      ],
                                                                    );
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    final coordinates = new Coordinates(lat, long);
                                                    await Geocoder.local.findAddressesFromCoordinates(coordinates).then(
                                                        (value) => Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                                transitionDuration: const Duration(milliseconds: 350),
                                                                pageBuilder: (context, _, __) => BarDetails(
                                                                    bar: snap,
                                                                    adr: value.first.addressLine,
                                                                    distance: isFiltered
                                                                        ? filterDistances[index]
                                                                        : distances[index]))));
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Container(
                                              child: Text("Bar n'existe pas"),
                                            ),
                                          ),
                                  ),
                                  Center(
                                    child: (isFiltered && filterDistancesMag.length > 0) ||
                                            (!isFiltered && distancesMag.length > 0)
                                        ? PageView.builder(
                                            itemCount: isFiltered ? filterDistancesMag.length : distancesMag.length,
                                            controller: PageController(viewportFraction: 0.85),
                                            itemBuilder: (context, index) {
                                              // print(distancesMag.length.toString() + 'magasins');
                                              // print('magasinsr' +
                                              //     index.toString() +
                                              //     '//// distance' +
                                              //     distancesMag[index].toString());
                                              DocumentSnapshot snap;
                                              return Padding(
                                                padding: EdgeInsets.all(15),
                                                child: InkWell(
                                                  child: Material(
                                                    animationDuration: Duration(milliseconds: 200),
                                                    elevation: 18,
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.3,
                                                          height: MediaQuery.of(context).size.height,
                                                          child: ClipRRect(
                                                            child: Image.asset(
                                                              'assets/ts.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(8),
                                                                topLeft: Radius.circular(8)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.04,
                                                        ),
                                                        StreamBuilder<DocumentSnapshot>(
                                                            stream: FirebaseFirestore.instance
                                                                .collection("magasins")
                                                                .doc(isFiltered
                                                                    ? filteredMagIndex[index]
                                                                    : magindex[index])
                                                                .snapshots(),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) snap = snapshot.data;
                                                              return !snapshot.hasData
                                                                  ? Center(
                                                                      child: Text("Chargement"),
                                                                    )
                                                                  : Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          snapshot.data.data()[Shish.magasinName],
                                                                          style: GoogleFonts.abel(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.place, size: 18),
                                                                            const SizedBox(width: 7),
                                                                            Text(
                                                                              isFiltered
                                                                                  ? "Distance : " +
                                                                                      (filterDistancesMag == null
                                                                                          ? 'Calcul ...'
                                                                                          : filterDistancesMag[index]
                                                                                              .toString()) +
                                                                                      " Km"
                                                                                  : "Distance : " +
                                                                                      (distancesMag == null
                                                                                          ? 'Calcul ...'
                                                                                          : distancesMag[index]
                                                                                              .toString()) +
                                                                                      " Km",
                                                                              style: GoogleFonts.abel(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.money, size: 14),
                                                                            const SizedBox(width: 10),
                                                                            Text(
                                                                              isFiltered
                                                                                  ? "Livraison à : " +
                                                                                      (filterDistancesMag == null
                                                                                          ? 'Calcul ...'
                                                                                          : filterDistancesMag[index] <
                                                                                                  1
                                                                                              ? '2 €'
                                                                                              : (filterDistancesMag[
                                                                                                              index] +
                                                                                                          1)
                                                                                                      .toString() +
                                                                                                  ' €')
                                                                                  : "Livraison à : " +
                                                                                      (distancesMag == null
                                                                                          ? 'Calcul ...'
                                                                                          : distancesMag[index] < 1
                                                                                              ? '2 €'
                                                                                              : (distancesMag[index] +
                                                                                                          1)
                                                                                                      .toString() +
                                                                                                  ' €'),
                                                                              style: GoogleFonts.abel(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // Stack(
                                                                        //   children: [
                                                                        //     Padding(
                                                                        //       padding: const EdgeInsets.only(
                                                                        //           top: 8.0, left: 12.0),
                                                                        //       child: RatingBar(
                                                                        //         initialRating: double.parse(snapshot
                                                                        //             .data
                                                                        //             .data()[Shish.magasinRating]
                                                                        //             .toString()),
                                                                        //         direction: Axis.horizontal,
                                                                        //         allowHalfRating: true,
                                                                        //         itemCount: 5,
                                                                        //         ratingWidget: RatingWidget(
                                                                        //             full: Image.asset(
                                                                        //               'assets/heart.png',
                                                                        //               color: Colors.redAccent,
                                                                        //             ),
                                                                        //             half: Image.asset(
                                                                        //                 'assets/heart_half.png',
                                                                        //                 color: Colors.redAccent),
                                                                        //             empty: Image.asset(
                                                                        //                 'assets/heart_border.png',
                                                                        //                 color: Colors.redAccent)),
                                                                        //         itemSize: 15,
                                                                        //         itemPadding: EdgeInsets.symmetric(
                                                                        //             horizontal: 1.0),
                                                                        //         onRatingUpdate: (rating) {
                                                                        //           setState(() {});
                                                                        //         },
                                                                        //       ),
                                                                        //     ),
                                                                        //     Container(
                                                                        //       color: Colors.black.withOpacity(0.01),
                                                                        //       height:
                                                                        //           MediaQuery.of(context).size.height *
                                                                        //               0.05,
                                                                        //       width: MediaQuery.of(context).size.width *
                                                                        //           0.3,
                                                                        //     ),
                                                                        //   ],
                                                                        // ),
                                                                        // Text(
                                                                        //   "Note : " +
                                                                        //       double.parse(snapshot.data
                                                                        //               .data()[Shish.magasinRatingCount]
                                                                        //               .toString())
                                                                        //           .toStringAsFixed(1) +
                                                                        //       "/5",
                                                                        //   style: GoogleFonts.abel(
                                                                        //       fontSize: 14,
                                                                        //       fontWeight: FontWeight.bold),
                                                                        // ),
                                                                      ],
                                                                    );
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) => Magasin(
                                                                  magasin: snap,
                                                                  distance: isFiltered
                                                                      ? filterDistancesMag[index]
                                                                      : distancesMag[index],
                                                                )));
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Container(
                                              child: Text("magasin n'existe pas"),
                                            ),
                                          ),
                                  ),
                                ]),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )
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

  filterMagsin(String searchString) {
    FocusScope.of(context).unfocus();
    filterDistancesMag.clear();
    filteredMagIndex.clear();
    filteredMagName.clear();

    for (int i = 0; i < magName.length; i++) {
      print("${magName.elementAt(i)}");
      isFiltered = true;

      if (magName.elementAt(i) != null && magName.elementAt(i).startsWith(searchString)) {
        filterDistancesMag.add(distancesMag.elementAt(i));
        filteredMagName.add(magName.elementAt(i));
        filteredMagIndex.add(magindex.elementAt(i));
      }
    }
    setState(() {});
  }

  clearfilterMagsin() {
    FocusScope.of(context).unfocus();
    filterDistancesMag.clear();
    filteredMagIndex.clear();
    filteredMagName.clear();

    isFiltered = false;
    setState(() {});
  }

  filterBar(String searchString) {
    FocusScope.of(context).unfocus();
    filterDistances.clear();
    filteredBarIndex.clear();
    filteredBarName.clear();

    for (int i = 0; i < barName.length; i++) {
      print("${barName.elementAt(i)}");
      isFiltered = true;

      if (barName.elementAt(i) != null && barName.elementAt(i).startsWith(searchString)) {
        filterDistances.add(distances.elementAt(i));
        filteredBarName.add(barName.elementAt(i));
        filteredBarIndex.add(barindex.elementAt(i));
      }
    }
    setState(() {});
  }

  clearfilterBar() {
    FocusScope.of(context).unfocus();
    filterDistances.clear();
    filteredBarIndex.clear();
    filteredBarName.clear();

    isFiltered = false;
    setState(() {});
  }

  searchAndNavigate() {
    print('searchAdr=>>> $searchAdr');
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) {
      print('value[0].latitude ${value[0]}');
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
            position: LatLng(value[0].latitude, value[0].longitude),
            icon: _shishaIcon));
      });
      return mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(value[0].latitude, value[0].longitude), zoom: 10)));
    });
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition()
        .then((Position position) {
          setState(() {
            current = position;
            print('position=>>> ${current}');
            FirebaseFirestore.instance
                .collection("clients")
                .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                .update({Shish.clientLatitude: current.latitude, Shish.clientLongitude: current.longitude});
            FirebaseFirestore.instance
                .collection("bars")
                .where(Shish.barAutorise, isEqualTo: "2")
                .get()
                .whenComplete(() {
              setState(() {});
            }).then((querySnapshot) {
              querySnapshot.docs.forEach((element) {
                print(element.get(Shish.barUID).toString() + " -- " + element.get(Shish.barUID).toString());
                _markers.add(Marker(
                    markerId: MarkerId(element.get(Shish.barUID).toString()),
                    position: LatLng(element.get(Shish.barLatitude), element.get(Shish.barLongitude)),
                    infoWindow: InfoWindow(title: element.data()[Shish.barName], snippet: "Bar de Chicha"),
                    icon: _shishaIcon));
              });
            });
            FirebaseFirestore.instance
                .collection("magasins")
                .where(Shish.magasinAutorise, isEqualTo: "2")
                .get()
                .whenComplete(() {
              setState(() {});
            }).then((querySnapshot) {
              querySnapshot.docs.forEach((element) {
                print(element.get(Shish.magasinUID).toString() + " -- " + element.get(Shish.magasinUID).toString());
                _markers.add(Marker(
                    markerId: MarkerId(element.get(Shish.magasinUID).toString()),
                    position: LatLng(element.get(Shish.magasinLatitude), element.get(Shish.magasinLongitude)),
                    infoWindow: InfoWindow(title: element.data()[Shish.magasinName], snippet: "Magasins"),
                    icon: _magaIcon));
              });
            });
            _markers.add(Marker(
                markerId: MarkerId("0"),
                position: LatLng(current.latitude, current.longitude),
                infoWindow: InfoWindow(title: "Your are here", snippet: "This your current Address"),
                icon: _markerIcon));
          });
        })
        .catchError((e) {
          print(e);
        })
        .then((value) => _calculateDistances())
        .whenComplete(() => null)
        .then((value) => showMap = true);
  }
}

class BarDetails extends StatefulWidget {
  final DocumentSnapshot bar;
  final String adr;
  final double distance;

  const BarDetails({Key key, this.bar, this.adr, this.distance}) : super(key: key);

  @override
  _BarDetailsState createState() => _BarDetailsState();
}

class _BarDetailsState extends State<BarDetails> {
  bool rated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Background(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.blue.shade100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(
                        bars[0].imgPath,
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0, top: 6),
                    child: Align(
                      child: IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 36,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(widget.bar.data()[Shish.barName],
                                    style: GoogleFonts.abel(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  widget.adr,
                                  style: GoogleFonts.abel(
                                      fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Container(
                              width: 0.6,
                              height: MediaQuery.of(context).size.height * 0.07,
                              color: Colors.black45.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection("bars").doc(widget.bar.id).snapshots(),
                                  builder: (context, snapshot) {
                                    return !snapshot.hasData
                                        ? Center(
                                            child: Text("Chargement ...."),
                                          )
                                        : Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.place, size: 18),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      "Distance : " + widget.distance.toStringAsFixed(1) + " Km",
                                                      style: GoogleFonts.abel(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.money, size: 14),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "Livraison à : " +
                                                          (widget.distance <= 1
                                                              ? '2 €'
                                                              : (widget.distance + 1).toString() + ' €'),
                                                      style:
                                                          GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.normal),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.01,
                                                ),
                                                // RatingBar(
                                                //   initialRating:
                                                //       double.parse(snapshot.data.data()[Shish.barRating].toString()),
                                                //   direction: Axis.horizontal,
                                                //   allowHalfRating: true,
                                                //   itemCount: 5,
                                                //   ratingWidget: RatingWidget(
                                                //       full: Image.asset(
                                                //         'assets/heart.png',
                                                //         color: Colors.redAccent,
                                                //       ),
                                                //       half: Image.asset('assets/heart_half.png', color: Colors.redAccent),
                                                //       empty: Image.asset('assets/heart_border.png',
                                                //           color: Colors.redAccent)),
                                                //   itemSize: 15,
                                                //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                //   onRatingUpdate: (rating) {
                                                //     setState(() async {
                                                //       if (!rated) {
                                                //         FirebaseFirestore.instance
                                                //             .collection("bars")
                                                //             .doc(widget.bar.id)
                                                //             .update({
                                                //           Shish.barRatingCount:
                                                //               snapshot.data.data()[Shish.barRatingCount] + 1,
                                                //           Shish.barRating: (snapshot.data.data()[Shish.barRating]) +
                                                //               ((rating - snapshot.data.data()[Shish.barRating]) /
                                                //                   (snapshot.data.data()[Shish.barRatingCount] + 1))
                                                //         }).then((value) => rated = true);
                                                //       }
                                                //     });
                                                //   },
                                                // ),
                                                // SizedBox(
                                                //   height: MediaQuery.of(context).size.height * 0.01,
                                                // ),
                                                // Text(
                                                //   "Note " +
                                                //       double.parse(snapshot.data.data()[Shish.barRating].toString())
                                                //           .toStringAsFixed(1) +
                                                //       "/5",
                                                //   style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                                                // ),
                                              ],
                                            ),
                                        );
                                  })),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Nos Chichas',
                  style: GoogleFonts.abel(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("bars/" + widget.bar.data()[Shish.barUID] + "/barChichas")
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(
                                child: Text("Chargement ..."),
                              )
                            : PageView.builder(
                                itemCount: snapshot.data.docs.length,
                                controller: PageController(viewportFraction: 0.8),
                                itemBuilder: (context, index) {
                                  return Opacity(
                                    opacity: snapshot.data.docs[index].data()["etat"] == "1" ? 1.0 : 0.5,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: "background-${snapshot.data.docs[index].id}",
                                            child: Material(
                                              elevation: 10,
                                              shape: PlatCardShape(MediaQuery.of(context).size.width * 0.55,
                                                  MediaQuery.of(context).size.height * 0.32),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(70, 132, 0, 0),
                                            child: Align(
                                              child: Image.network(
                                                snapshot.data.docs[index].data()["img"],
                                                height: 140,
                                                width: 140,
                                              ),
                                              alignment: Alignment(0, 0),
                                            ),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 15,
                                            right: 32,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Chicha " + snapshot.data.docs[index].data()["type"],
                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.02,
                                                ),
                                                Text(
                                                  "Prix : " + snapshot.data.docs[index].data()["prix"] + ",00 €",
                                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.01,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.32),
                                                  child: FlatButton(
                                                    color: Colors.green.withOpacity(0.8),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(Icons.shopping_basket),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.02,
                                                        ),
                                                        Text(
                                                          'Choisir',
                                                          style: GoogleFonts.abel(
                                                              fontSize: 14, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    onPressed: () {
                                                      if (snapshot.data.docs[index].data()["etat"] == '0') {
                                                        Scaffold.of(context).showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Chicha non disponible pour le moment, veuillez essayer avec d'autres chichas")));
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (context) => ChichaLayout(
                                                                    bar: widget.bar,
                                                                    chicha: snapshot.data.docs[index],
                                                                    distanceLivraison: widget.distance)));
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    clippedPath.quadraticBezierTo(1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width, size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0, size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.27);
    clippedPath.quadraticBezierTo(1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }
}
