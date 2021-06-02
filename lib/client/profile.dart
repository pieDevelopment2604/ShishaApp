import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/config.dart';

import '../background.dart';

class Profile extends StatefulWidget with NavigationStates {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String code;
  TextEditingController tedc2 = TextEditingController();
  TextEditingController tedc = TextEditingController();
  TextEditingController tedc3 = TextEditingController();
  TextEditingController tedc4 = TextEditingController();
  TextEditingController tedc5 = TextEditingController();
  DateTime dateTime;
  String adr;
  Position current;
  bool showAdr = false;
  bool showCode = false;

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position) async {
      current = position;
      final coordinates = new Coordinates(current.latitude, current.longitude);
      await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
        setState(() {
          adr = value.first.addressLine;
        });
      });
    }).catchError((e) {
      print(e);
    }).then((value) {
      setState(() {
        if (adr.isNotEmpty) {
          showAdr = true;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

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
          Form(
            key: _formKey2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: InkWell(
                                  child: Text('Modifier',
                                      style: GoogleFonts.abel(
                                          color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w400)),
                                  onTap: () {
                                    Shish.sharedPreferences.setString(Shish.clientDate, '');
                                    Shish.sharedPreferences.setString(Shish.clientAppart, '');
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
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
                                Shish.sharedPreferences.getString(Shish.clientName),
                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                Shish.sharedPreferences.getString(Shish.clientPhone),
                                style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 15),
                              ),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.blueAccent.shade100,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                Shish.sharedPreferences.getString(Shish.clientEmail),
                                style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 15),
                              ),
                              leading: Icon(
                                Icons.mail_outline,
                                color: Colors.blueAccent.shade100,
                              ),
                            ),
                            (Shish.sharedPreferences.getString(Shish.clientDate) == "jj-mm-aaaa") ||
                                    (Shish.sharedPreferences.getString(Shish.clientDate)) == ""
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            'Date de naissance ',
                                            style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 14),
                                          ),
                                          leading: Icon(
                                            Icons.home,
                                            color: Colors.blueAccent.shade100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: TextFormField(
                                              controller: tedc2,
                                              decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                ),
                                                fillColor: Colors.blue.shade100,
                                              ),
                                              onTap: () {
                                                DatePicker.showDatePicker(
                                                  context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(1940),
                                                  maxTime: DateTime(2050, 12),
                                                  locale: LocaleType.fr,
                                                  onConfirm: (pickedDate) {
                                                    setState(() {
                                                      if (pickedDate != null)
                                                        tedc2.text = pickedDate.toString().split(' ').first;
                                                    });
                                                  },
                                                );
                                                // showDatePicker(
                                                //   context: context,
                                                //   initialDate: DateTime.now(),
                                                //   firstDate: DateTime(1920),
                                                //   lastDate: DateTime.now(),
                                                // ).then((pickedDate) {
                                                //   setState(() {
                                                //     if (pickedDate != null)
                                                //       tedc2.text = pickedDate
                                                //           .toString()
                                                //           .split(' ')
                                                //           .first;
                                                //   });
                                                // });
                                              },
                                              keyboardType: TextInputType.datetime,
                                              validator: (value) {
                                                if (value.isEmpty) return "obligatoire";
                                                return null;
                                              }),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListTile(
                                    title: Text(
                                      Shish.sharedPreferences.getString(Shish.clientDate),
                                      style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 15),
                                    ),
                                    leading: Icon(
                                      Icons.calendar_today,
                                      color: Colors.blueAccent.shade100,
                                    ),
                                  ),
                            ListTile(
                              title: Text(
                                showAdr == false ? 'On calcule votre addresse' : adr,
                                style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 15),
                              ),
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.blueAccent.shade100,
                              ),
                            ),
                            (Shish.sharedPreferences.getString(Shish.clientAppart) == null) ||
                                    (Shish.sharedPreferences.getString(Shish.clientAppart) == "")
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            'Appartement ',
                                            style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 14),
                                          ),
                                          leading: Icon(
                                            Icons.home,
                                            color: Colors.blueAccent.shade100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: TextFormField(
                                              controller: tedc3,
                                              decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                ),
                                                fillColor: Colors.blue.shade100,
                                              ),
                                              keyboardType: TextInputType.number,
                                              onSaved: (value) {
                                                tedc3.text = value;
                                              },
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return 'Veuillez Entrer le numéro de votre appartment';
                                                else {
                                                  return null;
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListTile(
                                    title: Text(
                                      Shish.sharedPreferences.getString(Shish.clientAppart),
                                      style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 15),
                                    ),
                                    leading: Icon(
                                      Icons.home,
                                      color: Colors.blueAccent.shade100,
                                    ),
                                  ),
                            (Shish.sharedPreferences.getString(Shish.clientCardList) == null) ||
                                    (Shish.sharedPreferences.getString(Shish.clientCardList) == "")
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            '-',
                                            style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 14),
                                          ),
                                          leading: Icon(
                                            Icons.credit_card,
                                            color: Colors.blueAccent.shade100,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : CreditCardWidget(
                                    cardNumber: Shish.sharedPreferences.getString(Shish.clientCardList),
                                    expiryDate: Shish.sharedPreferences.getString(Shish.clientCardExpiry),
                                    cardHolderName: Shish.sharedPreferences.getString(Shish.clientName),
                                    cvvCode: Shish.sharedPreferences.getString(Shish.clientCardCVV),
                                    showBackView: false,
                                    cardType: CardType.visa,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.14),
                      child: FlatButton(
                        color: Colors.blueAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          Alert(
                              context: context,
                              title: 'Ajouter une carte de paiement',
                              content: Form(
                                key: _formKey1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  'Numéro de carte',
                                                  style: GoogleFonts.abel(color: Colors.black, fontSize: 12),
                                                ),
                                              ),
                                              TextFormField(
                                                  controller: tedc4,
                                                  decoration: InputDecoration(
                                                    border: new OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                    fillColor: Colors.blue.shade100,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  onSaved: (value) {
                                                    print(value);
                                                    tedc4.text = value;
                                                  },
                                                  validator: (value) {
                                                    if (value.isEmpty || value.replaceAll(' ', '').length != 16)
                                                      return 'Veuillez entrer le numéro de votre carte';
                                                    setState(() {
                                                      code = value.replaceAll(' ', '');
                                                    });
                                                    return null;
                                                  }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  "Date d'expiration",
                                                  style: GoogleFonts.abel(color: Colors.black, fontSize: 12),
                                                ),
                                              ),
                                              TextFormField(
                                                  controller: tedc,
                                                  decoration: InputDecoration(
                                                    border: new OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                    fillColor: Colors.blue.shade100,
                                                  ),
                                                  onTap: () {
                                                    // showDatePicker(
                                                    //   context: context,
                                                    //   initialDate: DateTime.now(),
                                                    //   firstDate: DateTime(2020),
                                                    //   lastDate: DateTime(2050, 12),
                                                    // ).then((pickedDate) {
                                                    //   setState(() {
                                                    //     if (pickedDate != null)
                                                    //       tedc.text = pickedDate.toString().split(' ').first;
                                                    //   });
                                                    // });

                                                    DatePicker.showDatePicker(
                                                      context,
                                                      minTime: DateTime(2020),
                                                      maxTime: DateTime(2050, 12),
                                                      showTitleActions: true,
                                                      locale: LocaleType.fr,
                                                      onConfirm: (pickedDate) {
                                                        setState(() {
                                                          if (pickedDate != null)
                                                            tedc2.text = pickedDate.toString().split(' ').first;
                                                        });
                                                      },
                                                    );
                                                  },
                                                  keyboardType: TextInputType.datetime,
                                                  validator: (value) {
                                                    if (value.isEmpty) return "obligatoire";
                                                    return null;
                                                  }),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  'CVV',
                                                  style: GoogleFonts.abel(color: Colors.black, fontSize: 12),
                                                ),
                                              ),
                                              TextFormField(
                                                  controller: tedc5,
                                                  decoration: InputDecoration(
                                                    border: new OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                    fillColor: Colors.blue.shade100,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  validator: (value) {
                                                    if (value.isEmpty ||
                                                        value.trim().length < 3 ||
                                                        value.trim().length > 4) return 'obligatoire';
                                                    return null;
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                  color: Colors.blueAccent.shade100,
                                  onPressed: () {
                                    if (_formKey1.currentState.validate()) {
                                      _formKey1.currentState.save();
                                      Scaffold.of(context)
                                          .showSnackBar(
                                            SnackBar(
                                              content: Text('Validation en cours'),
                                              backgroundColor: Colors.blueAccent.shade100,
                                            ),
                                          )
                                          .closed
                                          .then((value) {
                                        var re = RegExp(r'(?<=-)(.*)(?=-)');
                                        FirebaseFirestore.instance
                                            .collection("clients")
                                            .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                                            .update({
                                          Shish.clientCardList: tedc4.text.replaceAll(' ', ''),
                                          Shish.clientCardExpiry: re.firstMatch(tedc.text).group(0) +
                                              "/" +
                                              tedc.text.split("-").first.substring(2),
                                          Shish.clientCardCVV: tedc5.text.split(" ").first,
                                        }).then((value) async {
                                          print(tedc4.text.replaceAll(' ', ''));
                                          await Shish.sharedPreferences
                                              .setString(Shish.clientCardList, tedc4.text.replaceAll(' ', ''));
                                          await Shish.sharedPreferences.setString(
                                              Shish.clientCardExpiry,
                                              re.firstMatch(tedc.text).group(0) +
                                                  "/" +
                                                  tedc.text.split("-").first.substring(2));
                                          await Shish.sharedPreferences
                                              .setString(Shish.clientCardCVV, tedc5.text.split(" ").first);
                                        }).whenComplete(() {
                                          setState(() {});
                                        });
                                      });

                                      setState(() {
                                        showCode = true;
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    'Valider',
                                    style: GoogleFonts.abel(color: Colors.black),
                                  ),
                                )
                              ]).show();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.shopping_basket),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              'Ajouter une carte de paiement',
                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.14),
                      child: FlatButton(
                        color: Colors.blueAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          _formKey2.currentState.save();
                          FirebaseFirestore.instance
                              .collection("clients")
                              .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                              .update({
                            Shish.clientDate: tedc2.text.split(" ").first,
                            Shish.clientAppart: tedc3.text.trim(),
                          }).then((value) async {
                            await Shish.sharedPreferences.setString(Shish.clientDate, tedc2.text.split(" ").first);
                            await Shish.sharedPreferences.setString(Shish.clientAppart, tedc3.text.trim());
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
                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
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
    );
  }
}
