import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/bar/barLayout.dart';
import 'package:shish/client/clientLayout.dart';
import 'package:shish/config.dart';
import 'package:shish/coursier/coursierLayout.dart';
import 'package:shish/magasin/magasinLayout.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shish/main.dart';
import 'inscription.dart';

class Login extends StatefulWidget {
  final int option;

  const Login({Key key, this.option}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText = true;

class _LoginState extends State<Login> {
  final _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  bool proceed;
  final Map<String, dynamic> signInData = {'email': null, 'password': null};

  final _formKey = new GlobalKey<FormState>();
  ProgressDialog pg;
  final focusPassword = new FocusNode();

  Future<void> validate() async {
    pg = new ProgressDialog(context);
    pg.style(
      message: 'Connexion en cours ...',
    );
    final FormState _form = _formKey.currentState;
    if (!_form.validate()) {
      _form.save();
      try {
        pg.show();
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: signInData['email'], password: signInData['password']);
        print(result.user.uid);
        Shish.user = result.user;
      } on PlatformException catch (e) {
        print(e.message.toString());
        await pg.hide();
        _scaffoldKey2.currentState
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
        return '';
      } on FirebaseAuthException catch (e) {
        await pg.hide();
        switch (e.code) {
          case 'wrong-password':
            _scaffoldKey2.currentState.showSnackBar(SnackBar(
                content:
                    Text('Le mot de passe que vous avez fourni est invalide')));
            break;
          case 'wrong-email':
            _scaffoldKey2.currentState.showSnackBar(SnackBar(
                content: Text("L'email que vous avez fourni est invalide")));
            break;
          case 'too-many-requests':
            _scaffoldKey2.currentState.showSnackBar(SnackBar(
                content: Text("Probleme de connexion, revenz plutard")));
            break;
          case 'user-not-found':
            _scaffoldKey2.currentState.showSnackBar(SnackBar(
                content: Text(
                    "Vous ne disposez pas de compte Shish, inscrivez-vous d'abord")));
            break;
          default:
            _scaffoldKey2.currentState.showSnackBar(SnackBar(
                content: Text(
                    'Erreur de connexion, vérifiez vos coordonnées et réessayer S.V.P')));
            break;
        }
        return '';
      }
    } else {
      print("Echec");
    }
    if (Shish.user != null) {
      readData(Shish.user);
    }
  }

  Future readData(User user) async {
    switch (widget.option) {
      case 0:
        {
          FirebaseFirestore.instance
              .collection("clients")
              .doc(user.uid)
              .get()
              .whenComplete(() {})
              .then((dataSnap) async {
            if (dataSnap.data() != null) {
              proceed = true;
              preferences.setBool('loginStatus', true);

              await Shish.sharedPreferences
                  .setString(Shish.clientUID, dataSnap.data()[Shish.clientUID]);
              await Shish.sharedPreferences.setString(
                  Shish.clientEmail, dataSnap.data()[Shish.clientEmail]);
              await Shish.sharedPreferences.setString(
                  Shish.clientName, dataSnap.data()[Shish.clientName]);
              await Shish.sharedPreferences.setString(
                  Shish.clientPhone, dataSnap.data()[Shish.clientPhone]);
              await Shish.sharedPreferences.setString(
                  Shish.clientDate, dataSnap.data()[Shish.clientDate]);
              await Shish.sharedPreferences.setString(Shish.clientLatitude,
                  dataSnap.data()[Shish.clientLatitude].toString());
              await Shish.sharedPreferences.setString(Shish.clientLongitude,
                  dataSnap.data()[Shish.clientLongitude].toString());
              await Shish.sharedPreferences.setString(
                  Shish.clientAppart, dataSnap.data()[Shish.clientAppart]);
              await Shish.sharedPreferences
                  .setString(Shish.shishCurrentUser, "0");
            } else {
              setState(() {
                proceed = false;
              });
            }
          }).whenComplete(() {
            pg.hide();
          }).then((value) {
            if (proceed) {
              print("not proceed.....");
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
            } else {
              print("not proceed");
            }
          });
          break;
        }
      case 1:
        {
          FirebaseFirestore.instance
              .collection("bars")
              .doc(user.uid)
              .get()
              .whenComplete(() {})
              .then((dataSnap) async {
                if (dataSnap.data() != null) {
                  proceed = true;
                  preferences.setBool('loginStatus', true);
                  await Shish.sharedPreferences.setString(
                      Shish.clientUID, dataSnap.data()[Shish.barUID]);
                  await Shish.sharedPreferences
                      .setString(Shish.barUID, dataSnap.data()[Shish.barUID]);
                  await Shish.sharedPreferences.setString(
                      Shish.barEmail, dataSnap.data()[Shish.barEmail]);
                  await Shish.sharedPreferences
                      .setString(Shish.barName, dataSnap.data()[Shish.barName]);
                  await Shish.sharedPreferences.setString(
                      Shish.barPhone, dataSnap.data()[Shish.barPhone]);
                  await Shish.sharedPreferences
                      .setString(Shish.shishCurrentUser, "1");
                  await Shish.sharedPreferences.setString(Shish.barLongitude,
                      dataSnap.data()[Shish.barLongitude].toString());
                  await Shish.sharedPreferences.setString(Shish.barLatitude,
                      dataSnap.data()[Shish.barLatitude].toString());
                  await Shish.sharedPreferences.setString(Shish.barRating,
                      dataSnap.data()[Shish.barRating].toString());
                  await Shish.sharedPreferences.setString(Shish.barBalance,
                      dataSnap.data()[Shish.barBalance].toString());
                  await Shish.sharedPreferences.setString(Shish.barOuvert,
                      dataSnap.data()[Shish.barOuvert].toString());
                  if (dataSnap.data()[Shish.barAutorise] == '0') {
                    // setState(() async {
                    //  proceed = false;
                    pg.hide().then((value) {
                      _scaffoldKey2.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")));
                    });
                    //});
                  }
                } else {
                  setState(() {
                    proceed = false;
                  });
                }
              })
              .whenComplete(() {})
              .then((value) {
                if (proceed) {
                  // Navigator.pop(context);
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
                } else {
                  print("not procedd");
                }
              });
          break;
        }
      case 2:
        {
          FirebaseFirestore.instance
              .collection("livreurs")
              .doc(user.uid)
              .get()
              .whenComplete(() {})
              .then((dataSnap) async {
                if (dataSnap.data() != null) {
                  proceed = true;
                  preferences.setBool('loginStatus', true);
                  await Shish.sharedPreferences.setString(
                      Shish.clientUID, dataSnap.data()[Shish.livreurUID]);
                  await Shish.sharedPreferences.setString(
                      Shish.livreurUID, dataSnap.data()[Shish.livreurUID]);
                  await Shish.sharedPreferences.setString(
                      Shish.livreurEmail, dataSnap.data()[Shish.livreurEmail]);
                  await Shish.sharedPreferences.setString(
                      Shish.livreurName, dataSnap.data()[Shish.livreurName]);
                  await Shish.sharedPreferences
                      .setString(Shish.shishCurrentUser, "2");
                  await Shish.sharedPreferences.setString(
                      Shish.livreurPhone, dataSnap.data()[Shish.livreurPhone]);
                  await Shish.sharedPreferences.setString(
                      Shish.livreurLongitude,
                      dataSnap.data()[Shish.livreurLongitude].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurLatitude,
                      dataSnap.data()[Shish.livreurLatitude].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurRating,
                      dataSnap.data()[Shish.livreurRating].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurBalance,
                      dataSnap.data()[Shish.livreurBalance].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurType,
                      dataSnap.data()[Shish.livreurType].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurCouleur,
                      dataSnap.data()[Shish.livreurCouleur].toString());
                  await Shish.sharedPreferences.setString(Shish.livreurImageUrl,
                      dataSnap.data()[Shish.livreurImageUrl].toString());
                  if (dataSnap.data()[Shish.livreurAutorise] == '0') {
                    //setState(() async {
                    // proceed = false;
                    pg.hide().then((value) {
                      _scaffoldKey2.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")));
                    });
                    //});
                  }
                } else {
                  setState(() {
                    proceed = false;
                  });
                }
              })
              .whenComplete(() {})
              .then((value) {
                if (proceed) {
                  // Navigator.pop(context);
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
                } else {
                  print("not procedd");
                }
              });
          break;
        }
      case 3:
        {
          FirebaseFirestore.instance
              .collection("magasins")
              .doc(user.uid)
              .get()
              .whenComplete(() {})
              .then((dataSnap) async {
                if (dataSnap.data() != null) {
                  proceed = true;
                  preferences.setBool('loginStatus', true);
                  await Shish.sharedPreferences.setString(
                      Shish.clientUID, dataSnap.data()[Shish.magasinUID]);
                  await Shish.sharedPreferences.setString(
                      Shish.magasinUID, dataSnap.data()[Shish.magasinUID]);
                  await Shish.sharedPreferences.setString(
                      Shish.magasinEmail, dataSnap.data()[Shish.magasinEmail]);
                  await Shish.sharedPreferences.setString(
                      Shish.magasinName, dataSnap.data()[Shish.magasinName]);
                  await Shish.sharedPreferences
                      .setString(Shish.shishCurrentUser, "3");
                  await Shish.sharedPreferences.setString(
                      Shish.magasinPhone, dataSnap.data()[Shish.magasinPhone]);
                  await Shish.sharedPreferences.setString(
                      Shish.magasinLongitude,
                      dataSnap.data()[Shish.magasinLongitude].toString());
                  await Shish.sharedPreferences.setString(Shish.magasinLatitude,
                      dataSnap.data()[Shish.magasinLatitude].toString());
                  await Shish.sharedPreferences.setString(Shish.magasinRating,
                      dataSnap.data()[Shish.magasinRating].toString());
                  await Shish.sharedPreferences.setString(Shish.magasinBalance,
                      dataSnap.data()[Shish.magasinBalance].toString());
                  await Shish.sharedPreferences.setString(Shish.magasinOuvert,
                      dataSnap.data()[Shish.magasinOuvert].toString());
                  if (dataSnap.data()[Shish.magasinAutorise] == '0') {
                    print("------------");
                    // setState(() {
                    //   proceed = false;
                    // });
                    pg.hide().then((value) {
                      _scaffoldKey2.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")));
                    });
                  }
                } else {
                  setState(() {
                    proceed = false;
                  });
                }
              })
              .whenComplete(() {})
              .then((value) {
                if (proceed) {
                  // Navigator.pop(context);
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
                } else {
                  print("not procedd");
                }
              });
          break;
        }
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
      key: _scaffoldKey2,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top: 230),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Connexion",
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
                                  child: new TextFormField(
                                    keyboardType: TextInputType.emailAddress,
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
                                      signInData['email'] = value;
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
                                        return "Adresse email invalide";
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
                                      signInData['password'] = value;
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Inscription(
                                        option: widget.option,
                                      )));
                        },
                        child: Text(
                          "Nouveau compte",
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
                    padding: const EdgeInsets.all(28.0),
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
