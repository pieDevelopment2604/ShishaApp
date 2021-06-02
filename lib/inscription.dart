import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/main.dart';
import 'bar/barLayout.dart';
import 'client/clientLayout.dart';
import 'config.dart';
import 'coursier/coursierLayout.dart';
import 'login.dart';
import 'magasin/magasinLayout.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Inscription extends StatefulWidget {
  final int option;

  const Inscription({Key key, this.option}) : super(key: key);

  @override
  _InscriptionState createState() => _InscriptionState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText = true;

class _InscriptionState extends State<Inscription> {
  final Map<String, dynamic> signUpData = {
    'email': null,
    'username': null,
    'phone': null,
    'password': null
  };

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final focusUsername = new FocusNode();

  final focusPhone = new FocusNode();

  final focusPassword = new FocusNode();

  void validate() async {
    final FormState _form = _formKey.currentState;
    ProgressDialog pg = new ProgressDialog(context);
    pg.style(
      message: 'Inscription en cours ...',
    );
    if (!_form.validate()) {
      _form.save();
      try {
        pg.show();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: signUpData['email'], password: signUpData['password'])
            .then((value) {
          Shish.user = value.user;
        });
        print(Shish.user.uid +
            'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiidddddddddddddddddddddd');
        if (Shish.user != null) {
          print(Shish.user.uid +
              'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiidddddddddddddddddddddd');
          saveUserToFirestore(Shish.user).then((value) async {
            await pg.hide();
            switch (widget.option) {
              case 0:
                preferences.setBool('loginStatus', true);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.option == 0
                            ? ClientLayout()
                            : widget.option == 1
                                ? BarLayout()
                                : widget.option == 2
                                    ? CoursierLayout()
                                    : MagasinLayout()),
                    (route) => false);
                break;
              case 1:
                FirebaseFirestore.instance
                    .collection("bars")
                    .doc(Shish.sharedPreferences.getString(Shish.barUID))
                    .get()
                    .then((bar) async {
                  if (bar.data()[Shish.barAutorise] == '0') {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                            content: Text(
                                "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")))
                        .closed
                        .then((value) => Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Login(
                                      option: widget.option,
                                    ))));
                  } else {
                    preferences.setBool('loginStatus', true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => widget.option == 0
                                ? ClientLayout()
                                : widget.option == 1
                                    ? BarLayout()
                                    : widget.option == 2
                                        ? CoursierLayout()
                                        : MagasinLayout()),
                        (route) => false);
                  }
                });
                break;
              case 2:
                FirebaseFirestore.instance
                    .collection("livreurs")
                    .doc(Shish.sharedPreferences.getString(Shish.livreurUID))
                    .get()
                    .then((livreur) async {
                  if (livreur.data()[Shish.livreurAutorise] == '0') {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                            content: Text(
                                "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")))
                        .closed
                        .then((value) => Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Login(
                                      option: widget.option,
                                    ))));
                  } else {
                    preferences.setBool('loginStatus', true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => widget.option == 0
                                ? ClientLayout()
                                : widget.option == 1
                                    ? BarLayout()
                                    : widget.option == 2
                                        ? CoursierLayout()
                                        : MagasinLayout()),
                        (route) => false);
                  }
                });
                break;
              case 3:
                FirebaseFirestore.instance
                    .collection("magasins")
                    .doc(Shish.sharedPreferences.getString(Shish.magasinUID))
                    .get()
                    .then((magasin) async {
                  if (magasin.data()[Shish.magasinAutorise] == '0') {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                            content: Text(
                                "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")))
                        .closed
                        .then((value) => Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Login(
                                      option: widget.option,
                                    ))));
                  } else {
                    preferences.setBool('loginStatus', true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => widget.option == 0
                                ? ClientLayout()
                                : widget.option == 1
                                    ? BarLayout()
                                    : widget.option == 2
                                        ? CoursierLayout()
                                        : MagasinLayout()),
                        (route) => false);
                  }
                });
                break;
            }
          });
        }
      } on PlatformException catch (e) {
        await pg.hide();
        print(" error =>>>${e.message.toString()}");
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      } catch (e) {
        print(" error msg =>>>${e.message.toString()}");

        await pg.hide();
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    } else {
      print("Echec");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Inscription",
                    style: GoogleFonts.changa(
                        fontSize: 55, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.changa(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focusUsername);
                                    },
                                    onSaved: (String value) {
                                      signUpData['email'] = value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black.withAlpha(150)),
                                      hintText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Champs Obligatoire";
                                      } else if (!regExp.hasMatch(value)) {
                                        return "Adresse mail invalide";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    focusNode: focusUsername,
                                    style: GoogleFonts.changa(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focusPhone);
                                    },
                                    onSaved: (String value) {
                                      signUpData['username'] = value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black.withAlpha(150)),
                                      hintText: "Nom d'utilisateur",
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return 'Champs obligatoire';
                                      } else if (value.length < 6) {
                                        return "Doit etre de longueur superieure à 6";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      focusNode: focusPhone,
                                      style: GoogleFonts.changa(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focusPassword);
                                      },
                                      onSaved: (String value) {
                                        signUpData['phone'] = value;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        hintStyle: GoogleFonts.changa(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black.withAlpha(150)),
                                        hintText: 'Téléphone',
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.black,
                                        ),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Champs Obligatoire";
                                        } else if (value.length != 10) {
                                          return "Numéro de téléphone doit etre de longueur 10";
                                        }
                                        return "";
                                      }),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new TextFormField(
                                    obscureText: obscureText,
                                    focusNode: focusPassword,
                                    style: GoogleFonts.changa(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    onFieldSubmitted: (v) {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                      }
                                    },
                                    onSaved: (String value) {
                                      signUpData['password'] = value;
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1))),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1))),
                                        hintText: 'Mot de Passe',
                                        hintStyle: GoogleFonts.changa(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black.withAlpha(150)),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                            FocusScope.of(context).unfocus();
                                          },
                                        )),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return 'Champs obligatoire';
                                      } else if (value.length < 6) {
                                        return "Mot de passe doit etre de longueur superieure à 6";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ClipOval(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          /*Alert(
                              context: context,
                              title: 'Code de verification',
                              content: Column(
                                children: <Widget>[
                                  Text('Un code de verification a été envoyé à votre numéro de téléphone',
                                    style: GoogleFonts.changa(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: new TextFormField(keyboardType: TextInputType.number,
                                            style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),
                                            textInputAction: TextInputAction.done,
                                            onFieldSubmitted: (v){
                                            },
                                            onSaved: (String value){
                                            },
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              hintStyle: GoogleFonts.changa(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                              hintText: 'Code',
                                              prefixIcon: Icon(Icons.lock_outline,color: Colors.black,),
                                            ),
                                            validator: (String value){
                                              if(value.trim().isEmpty)
                                              {
                                                return'Code is required';
                                              }else{
                                                return"";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>widget.option==0?ClientLayout():widget.option==1?BarLayout():widget.option==2?CoursierLayout():MagasinLayout()));
                                  },
                                  child: Text("Valider",
                                    style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                  color: Colors.black,
                                )
                              ]
                          ).show();*/
                          validate();
                        },
                        child: new Icon(
                          Icons.arrow_forward,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: InkWell(
                      child: Text(
                        "Retour en arrière",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future saveUserToFirestore(User user) async {
    print("I am in save to user" + widget.option.toString());
    switch (widget.option) {
      case 0:
        {
          print("I am in case 0");
          FirebaseFirestore.instance.collection("clients").doc(user.uid).set({
            Shish.clientUID: user.uid,
            Shish.clientEmail: user.email,
            Shish.clientName: signUpData['username'],
            Shish.clientCardList: "",
            Shish.clientPhone: signUpData['phone'],
            Shish.clientDate: 'jj-mm-aaaa',
            Shish.clientLatitude: '0',
            Shish.clientLongitude: '0',
            Shish.clientAppart: '',
          });

          await Shish.sharedPreferences.setString(Shish.clientUID, user.uid);
          await Shish.sharedPreferences
              .setString(Shish.clientEmail, user.email);
          await Shish.sharedPreferences
              .setString(Shish.clientPhone, signUpData['phone']);
          await Shish.sharedPreferences.setString(Shish.shishCurrentUser, "0");
          await Shish.sharedPreferences
              .setString(Shish.clientName, signUpData['username']);
          await Shish.sharedPreferences.setString(Shish.clientCardList, "");
          await Shish.sharedPreferences
              .setString(Shish.clientDate, 'jj-mm-aaaa');
          await Shish.sharedPreferences.setString(Shish.clientAppart, '');
          await Shish.sharedPreferences.setString(Shish.clientLatitude, '0');
          await Shish.sharedPreferences.setString(Shish.clientLongitude, '0');
          break;
        }
      case 1:
        {
          print("I am in case 1");
          FirebaseFirestore.instance.collection("bars").doc(user.uid).set({
            Shish.barUID: user.uid,
            Shish.barEmail: user.email,
            Shish.barName: signUpData['username'],
            Shish.barPhone: signUpData['phone'],
            Shish.barLatitude: 0,
            Shish.barLongitude: 0,
            Shish.barRating: 0,
            Shish.barRatingCount: 0,
            Shish.barBalance: '0',
            Shish.barAutorise: '0',
            Shish.barOuvert: '1'
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barChichas')
              .doc("1")
              .set({
            "type": "Basique",
            "prix": "10",
            "etat": "1",
            "img":
                "https://firebasestorage.googleapis.com/v0/b/shish-95412.appspot.com/o/basic.png?alt=media&token=cc77e768-5993-4ca5-8e63-0d418ef3ee9f"
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barChichas')
              .doc("2")
              .set({
            "type": "Kaloud",
            "prix": "15",
            "etat": "1",
            "img":
                "https://firebasestorage.googleapis.com/v0/b/shish-95412.appspot.com/o/kaloud.png?alt=media&token=8d8b1235-9f5d-4a7e-bbe5-36dc7b601aa5"
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barChichas')
              .doc("3")
              .set({
            "type": "Brohood",
            "prix": "20",
            "etat": "1",
            "img":
                "https://firebasestorage.googleapis.com/v0/b/shish-95412.appspot.com/o/brohood.png?alt=media&token=5ffefc98-27f9-4c67-8073-3edf680fc6d5"
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barGouts')
              .doc("1")
              .set({
            "type": "Menthe",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barGouts')
              .doc("2")
              .set({
            "type": "Hawai",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barGouts')
              .doc("3")
              .set({
            "type": "Love 66",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barGouts')
              .doc("4")
              .set({
            "type": "Mi amor",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barBoissons')
              .doc("1")
              .set({
            "type": "Coca Cola",
            "prix": "8",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barBoissons')
              .doc("2")
              .set({
            "type": "Fanta",
            "prix": "8",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barBoissons')
              .doc("3")
              .set({
            "type": "Oasis",
            "prix": "8",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barSupps')
              .doc("1")
              .set({
            "type": "Charbon",
            "prix": "2",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barSupps')
              .doc("2")
              .set({
            "type": "Tete de chicha",
            "prix": "2",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barAccos')
              .doc("1")
              .set({
            "type": "Glaces",
            "prix": "0.5",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barAccos')
              .doc("2")
              .set({
            "type": "Bonbons",
            "prix": "3.5",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barAccos')
              .doc("3")
              .set({
            "type": "Chips",
            "prix": "6",
            "etat": "1",
          });
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .collection('barAccos')
              .doc("4")
              .set({
            "type": "Fruits secs",
            "prix": "4",
            "etat": "1",
          });

          await Shish.sharedPreferences.setString(Shish.barUID, user.uid);
          await Shish.sharedPreferences.setString(Shish.barEmail, user.email);
          await Shish.sharedPreferences
              .setString(Shish.barName, signUpData['username']);
          await Shish.sharedPreferences
              .setString(Shish.barPhone, signUpData['phone']);
          await Shish.sharedPreferences.setString(Shish.shishCurrentUser, "1");
          await Shish.sharedPreferences.setString(Shish.barLatitude, '0');
          await Shish.sharedPreferences.setString(Shish.barLongitude, '0');
          await Shish.sharedPreferences.setString(Shish.barRating, "0");
          await Shish.sharedPreferences.setString(Shish.barRatingCount, "0");
          await Shish.sharedPreferences.setString(Shish.barBalance, "0");
          await Shish.sharedPreferences.setString(Shish.barOuvert, "1");

          break;
        }
      case 2:
        {
          FirebaseFirestore.instance.collection("livreurs").doc(user.uid).set({
            Shish.livreurUID: user.uid,
            Shish.livreurEmail: user.email,
            Shish.livreurName: signUpData['username'],
            Shish.livreurPhone: signUpData['phone'],
            Shish.livreurAutorise: '0',
            Shish.livreurLongitude: 0,
            Shish.livreurLatitude: 0,
            Shish.livreurRating: 0,
            Shish.livreurRatingCount: 0,
            Shish.livreurBalance: '0',
            Shish.livreurCouleur: '',
            Shish.livreurType: '',
            Shish.livreurImageUrl: '',
          });

          await Shish.sharedPreferences.setString(Shish.livreurUID, user.uid);
          await Shish.sharedPreferences
              .setString(Shish.livreurEmail, user.email);
          await Shish.sharedPreferences.setString(Shish.shishCurrentUser, "2");
          await Shish.sharedPreferences
              .setString(Shish.livreurName, signUpData['username']);
          await Shish.sharedPreferences
              .setString(Shish.livreurPhone, signUpData['phone']);
          await Shish.sharedPreferences.setString(Shish.livreurLatitude, '0');
          await Shish.sharedPreferences.setString(Shish.livreurLongitude, '0');
          await Shish.sharedPreferences.setString(Shish.livreurRating, "0");
          await Shish.sharedPreferences
              .setString(Shish.livreurRatingCount, "0");
          await Shish.sharedPreferences.setString(Shish.livreurBalance, "0");
          await Shish.sharedPreferences.setString(Shish.livreurCouleur, "");
          await Shish.sharedPreferences.setString(Shish.livreurType, "");
          await Shish.sharedPreferences.setString(Shish.livreurImageUrl, "");
          break;
        }
      case 3:
        {
          FirebaseFirestore.instance.collection("magasins").doc(user.uid).set({
            Shish.magasinUID: user.uid,
            Shish.magasinEmail: user.email,
            Shish.magasinName: signUpData['username'],
            Shish.magasinPhone: signUpData['phone'],
            Shish.magasinLatitude: 0,
            Shish.magasinLongitude: 0,
            Shish.magasinRating: 0,
            Shish.magasinRatingCount: 0,
            Shish.magasinBalance: '0',
            Shish.magasinAutorise: '0',
            Shish.magasinOuvert: '1',
          });

          await Shish.sharedPreferences.setString(Shish.magasinUID, user.uid);
          await Shish.sharedPreferences
              .setString(Shish.magasinEmail, user.email);
          await Shish.sharedPreferences.setString(Shish.shishCurrentUser, "3");
          await Shish.sharedPreferences
              .setString(Shish.magasinName, signUpData['username']);
          await Shish.sharedPreferences
              .setString(Shish.magasinPhone, signUpData['phone']);
          await Shish.sharedPreferences.setString(Shish.magasinLatitude, '0');
          await Shish.sharedPreferences.setString(Shish.magasinLongitude, '0');
          await Shish.sharedPreferences.setString(Shish.magasinRating, "0");
          await Shish.sharedPreferences
              .setString(Shish.magasinRatingCount, "0");
          await Shish.sharedPreferences.setString(Shish.magasinBalance, "0");
          await Shish.sharedPreferences.setString(Shish.magasinAutorise, "0");
          await Shish.sharedPreferences.setString(Shish.magasinOuvert, "1");
          break;
        }
    }
  }
}

class WavyImageRestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('assets/coverr.jpg'),
      clipper: BottomWaveClipperRestaurantPage(),
    );
  }
}

class BottomWaveClipperRestaurantPage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.4);
    path.cubicTo(size.width / 3, size.height * 0.5, 2 * size.width / 3,
        size.height * 0.5, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
