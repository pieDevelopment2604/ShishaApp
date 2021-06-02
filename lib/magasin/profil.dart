import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:shish/main.dart';
import '../background.dart';
import '../config.dart';
import 'bloc/magasin_bloc_nav.dart';

class Profile extends StatefulWidget with NaviStates {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String code;
  TextEditingController tedc = TextEditingController();
  TextEditingController tedc2 = TextEditingController();
  DateTime dateTime;
  String adr;
  Position current;
  bool showAdr = false;
  bool showCode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress().then((value) {
      setState(() {
        showAdr = true;
      });
    });
  }

  TextEditingController addrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.blueAccent.shade100,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width,
                          ),
                          CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                              size: 50,
                            ),
                            radius: 40,
                            backgroundColor: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 2),
                            child: Text(
                              Shish.sharedPreferences
                                  .getString(Shish.magasinName),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 18.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Stack(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 top: 8.0, left: 12.0),
                          //             child: RatingBar(
                          //               initialRating: 0,
                          //               direction: Axis.horizontal,
                          //               allowHalfRating: true,
                          //               itemCount: 5,
                          //               ratingWidget: RatingWidget(
                          //                   full: Image.asset(
                          //                     'assets/heart.png',
                          //                     color: Colors.redAccent,
                          //                   ),
                          //                   half: Image.asset(
                          //                       'assets/heart_half.png',
                          //                       color: Colors.redAccent),
                          //                   empty: Image.asset(
                          //                       'assets/heart_border.png',
                          //                       color: Colors.redAccent)),
                          //               itemSize: 15,
                          //               itemPadding: EdgeInsets.symmetric(
                          //                   horizontal: 1.0),
                          //               onRatingUpdate: (rating) {},
                          //             ),
                          //           ),
                          //           Container(
                          //             color: Colors.black.withOpacity(0.01),
                          //             height:
                          //                 MediaQuery.of(context).size.height *
                          //                     0.05,
                          //             width: MediaQuery.of(context).size.width *
                          //                 0.3,
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          ListTile(
                            title: Text(
                              Shish.sharedPreferences
                                  .getString(Shish.magasinPhone),
                              style: TextStyle(
                                  color: Colors.black.withAlpha(100),
                                  fontSize: 15),
                            ),
                            leading: Icon(
                              Icons.phone,
                              color: Colors.blueAccent.shade100,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              Shish.sharedPreferences
                                  .getString(Shish.magasinEmail),
                              style: TextStyle(
                                  color: Colors.black.withAlpha(100),
                                  fontSize: 15),
                            ),
                            leading: Icon(
                              Icons.mail_outline,
                              color: Colors.blueAccent.shade100,
                            ),
                          ),
                          preferences.getString('address_edit') != null
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.blueAccent.shade100,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                        '${preferences.get('address_edit')}',
                                        style: TextStyle(
                                            color: Colors.black.withAlpha(100),
                                            fontSize: 15),
                                      ),
                                  ),
                                ],
                              )
                              : SearchMapPlaceWidget(
                                  apiKey: 'AIzaSyBFjWzxSa4FUq7ICn88jh9iUtchn8VUjd4',
                                  // The language of the autocompletion
                                  language: 'en',
                                  // The position used to give better recomendations. In this case we are using the user position
                                  location: LatLng(05.721160, 06.394435),
                                  radius: 30000,
                                  hasClearButton: true,

                                  // placeType: PlaceType.address,
                                  placeholder: "votre position",
                                  onSearch: (place) {
                                    print("ON TAP SEARCH ${place.description}");
                                  },
                                  onSelected: (Place place) async {
                                    final geolocation = await place.geolocation;


                                    print("ON TAP ${geolocation.coordinates}");

                                    // print(
                                    //     'place=>>> ${(await place.geolocation).coordinates}');
                                    preferences.setString(
                                        'address_edit', place.description);

                                    LatLng latLng=geolocation.coordinates;
                                    preferences.setString(
                                        'address_latitude', latLng.latitude.toString());
                                    preferences.setString(
                                        'address_longitude', latLng.longitude.toString());


                                    setState(() {
                                      // searchAdr = place.description;
                                      // searchAndNavigate();
                                    });
                                  },
                                ),
                          /*          StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('MagasinAddress')
                                  .doc(preferences.get(Shish.clientUID))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print('dtaa${snapshot.data.id}');
                                  return ListTile(
                                    title: snapshot.data.exists
                                        ? Text(
                                            '${snapshot.data.get('address')}',
                                            style: TextStyle(
                                                color:
                                                    Colors.black.withAlpha(100),
                                                fontSize: 15),
                                          )
                                        : TextFormField(
                                            controller: addrController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder()),
                                          ),
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Colors.blueAccent.shade100,
                                    ),
                                    trailing: snapshot.data.exists
                                        ? SizedBox()
                                        : InkResponse(
                                            onTap: () {
                                              if (addrController
                                                  .text.isNotEmpty) {
                                                print(
                                                    'daaaaaaa${preferences.get(Shish.clientUID)}');
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'MagasinAddress')
                                                    .doc(preferences
                                                        .get(Shish.clientUID))
                                                    .set({
                                                  'address': addrController.text
                                                }).catchError((e) => print(e));
                                              }
                                            },
                                            child: CircleAvatar(
                                                child: Icon(Icons.add))),
                                  );
                                } else {
                                  return ListTile(
                                    title: Text(
                                      '.....',
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(100),
                                          fontSize: 15),
                                    ),
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Colors.blueAccent.shade100,
                                    ),
                                  );
                                }
                              }),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAddress() async {
    current = Position(
        longitude:
            double.parse(Shish.sharedPreferences.getString(Shish.barLongitude)),
        latitude:
            double.parse(Shish.sharedPreferences.getString(Shish.barLatitude)));
    final coordinates = new Coordinates(current.latitude, current.longitude);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      setState(() {
        adr = value.first.addressLine;
      });
    });
  }
}
