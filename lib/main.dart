import 'dart:io';
import 'dart:math';

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/bar/commandes.dart';
import 'package:shish/bars.dart';
import 'package:shish/carousel.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/config.dart';
import 'package:shish/users_accueil.dart';
import 'package:shish/utils.dart';
import 'package:uuid/uuid.dart';
import 'bar/barLayout.dart';
import 'client/clientLayout.dart';
import 'coursier/coursierLayout.dart';
import 'magasin/magasinLayout.dart';
import 'package:http/http.dart' as http;

SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));

  preferences = await SharedPreferences.getInstance();
  Shish.auth = FirebaseAuth.instance;
  Shish.sharedPreferences = await SharedPreferences.getInstance();
  Shish.firestore = FirebaseFirestore.instance;
  print('id =>>>${preferences.get(Shish.clientUID)}');


//  await storeAddress();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<BarNavBloc>(create: (context) => BarNavBloc()),
    BlocProvider<ClientNavBloc>(create: (context) => ClientNavBloc()),
    BlocProvider<OptionsNavBloc>(
      create: (context) => OptionsNavBloc(),
    )
  ], child: MyApp()));
}

// Future<void> storeAddress() async {
//   DocumentSnapshot docs = await FirebaseFirestore.instance
//       .collection('Address')
//       .doc(preferences.get(Shish.clientUID))
//       .get();
//   if (!docs.exists) {
//     String address = await getCurrentLocation();
//     if (address != null) {
//       await FirebaseFirestore.instance
//           .collection('Address')
//           .doc(preferences.get(Shish.clientUID))
//           .set({'address': address})
//           .then((value) => print('success=>>>>'))
//           .catchError((e) => print('store address error $e'));
//     }
//   }
// }

// Future<String> getCurrentLocation() async {
//   return Geolocator.getCurrentPosition().then((Position position) async {
//     var current = position;
//     final coordinates = new Coordinates(current.latitude, current.longitude);
//     List<Address> addressList =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     return addressList.first.addressLine;
//   }).catchError((e) {
//     print(e);
//     return null;
//   });
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // home: DemoPlaceSearch(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: displayCarousel());
  }

  displayCarousel() {
    print("loginStatus: ${preferences.getBool('loginStatus')}");
    print("isFirstTime: ${preferences.getBool('isFirstTime')}");
    if (preferences.getBool('loginStatus') != null) {
      switch (preferences.getString(Shish.shishCurrentUser)) {
        case '0':
          return ClientLayout();
          break;
        case '1':
          return BarLayout();
          break;
        case '2':
          return CoursierLayout();
          break;
        case '3':
          return MagasinLayout();
          break;
      }
    } else if(preferences.getBool('isFirstTime') != null) {
      return AccueilC();
    } else {
      return Carousel();
    }
  }
}

//'AIzaSyCewf_h0c-4NVEQU0HGKYiSxlBKtiiCgi4'
