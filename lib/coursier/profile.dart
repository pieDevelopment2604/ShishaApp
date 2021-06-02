import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shish/config.dart';
import 'package:shish/coursier/bloc/coursierNav.dart';
import 'package:shish/main.dart';
import '../background.dart';

class Profile extends StatefulWidget with NavStates {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String code;
  TextEditingController tedc = TextEditingController();
  TextEditingController tedc2 = TextEditingController();
  TextEditingController tedc3 = TextEditingController();
  TextEditingController tedc4 = TextEditingController();
  DateTime dateTime;
  String adr;
  Position current;
  bool showAdr = false;
  bool showCode = false;
  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position) async {
      current = position;
      final coordinates = new Coordinates(current.latitude, current.longitude);
      await Geocoder.local
          .findAddressesFromCoordinates(coordinates)
          .then((value) {
        setState(() {
          adr = value.first.addressLine;
        });
      });
    }).catchError((e) {
      print(e);
    }).then((value) {
      setState(() {
        showAdr = true;
      });
    });
  }

  TextEditingController addrController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.blueAccent.shade100,
            ),
            Form(
              key: _formKey2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
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
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 2),
                                child: Text(
                                  Shish.sharedPreferences
                                      .getString(Shish.livreurName),
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
                              //               initialRating: double.parse(Shish
                              //                   .sharedPreferences
                              //                   .getString(
                              //                       Shish.livreurRating)),
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
                              //             height: MediaQuery.of(context)
                              //                     .size
                              //                     .height *
                              //                 0.05,
                              //             width: MediaQuery.of(context)
                              //                     .size
                              //                     .width *
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
                                      .getString(Shish.livreurPhone),
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
                                      .getString(Shish.livreurEmail),
                                  style: TextStyle(
                                      color: Colors.black.withAlpha(100),
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Icons.mail_outline,
                                  color: Colors.blueAccent.shade100,
                                ),
                              ),
                              Shish.sharedPreferences
                                          .getString(Shish.livreurType) ==
                                      ''
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              'Type',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withAlpha(100),
                                                  fontSize: 14),
                                            ),
                                            leading: Icon(
                                              Icons.motorcycle,
                                              color: Colors.blueAccent.shade100,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 6.0, bottom: 6.0),
                                            child: TextFormField(
                                                controller: tedc3,
                                                decoration: InputDecoration(
                                                  hintText: 'ex. Velo',
                                                  hintStyle: TextStyle(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      fontSize: 10),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide: BorderSide(),
                                                  ),
                                                  fillColor:
                                                      Colors.blue.shade100,
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "obligatoire";
                                                  return null;
                                                }),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListTile(
                                      title: Text(
                                        Shish.sharedPreferences
                                            .getString(Shish.livreurType),
                                        style: TextStyle(
                                            color: Colors.black.withAlpha(100),
                                            fontSize: 15),
                                      ),
                                      leading: Icon(
                                        Icons.mail_outline,
                                        color: Colors.blueAccent.shade100,
                                      ),
                                    ),
                              Shish.sharedPreferences
                                          .getString(Shish.livreurCouleur) ==
                                      ''
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              'Couleur',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withAlpha(100),
                                                  fontSize: 14),
                                            ),
                                            leading: Icon(
                                              Icons.color_lens,
                                              color: Colors.blueAccent.shade100,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 6.0, bottom: 6.0),
                                            child: TextFormField(
                                                controller: tedc2,
                                                decoration: InputDecoration(
                                                  hintText: 'ex. Blanc',
                                                  hintStyle: TextStyle(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      fontSize: 10),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide: BorderSide(),
                                                  ),
                                                  fillColor:
                                                      Colors.blue.shade100,
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "obligatoire";
                                                  return null;
                                                }),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListTile(
                                      title: Text(
                                        Shish.sharedPreferences
                                            .getString(Shish.livreurCouleur),
                                        style: TextStyle(
                                            color: Colors.black.withAlpha(100),
                                            fontSize: 15),
                                      ),
                                      leading: Icon(
                                        Icons.mail_outline,
                                        color: Colors.blueAccent.shade100,
                                      ),
                                    ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('CoursierAddress')
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
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    fontSize: 15),
                                              )
                                            : TextFormField(
                                                controller: addrController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder()),
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
                                                            'CoursierAddress')
                                                        .doc(preferences.get(
                                                            Shish.clientUID))
                                                        .set({
                                                      'address':
                                                          addrController.text
                                                    }).catchError(
                                                            (e) => print(e));
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
                                              color:
                                                  Colors.black.withAlpha(100),
                                              fontSize: 15),
                                        ),
                                        leading: Icon(
                                          Icons.location_on,
                                          color: Colors.blueAccent.shade100,
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.14),
                        child: FlatButton(
                          color: Colors.blueAccent.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            _formKey2.currentState.save();
                            FirebaseFirestore.instance
                                .collection("livreurs")
                                .doc(Shish.sharedPreferences
                                    .getString(Shish.livreurUID))
                                .update({
                              Shish.livreurType: tedc3.text,
                              Shish.livreurCouleur: tedc2.text,
                            }).then((value) async {
                              await Shish.sharedPreferences
                                  .setString(Shish.livreurType, tedc3.text);
                              await Shish.sharedPreferences
                                  .setString(Shish.livreurCouleur, tedc2.text);
                            }).whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.save_alt),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Text(
                                'Sauvegarder',
                                style: GoogleFonts.abel(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
