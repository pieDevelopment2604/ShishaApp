import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shish/background.dart';
import 'package:sweetalert/sweetalert.dart';

import '../bars.dart';
import '../config.dart';
import 'accueilMagasin.dart';
import 'bloc/magasin_bloc_nav.dart';

class ProduitsMaga extends StatefulWidget with NaviStates {
  @override
  _ProduitsMagaState createState() => _ProduitsMagaState();
}

class _ProduitsMagaState extends State<ProduitsMaga> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String url;
  File _imgFile;
  List<Produit> charbons, tetes;
  TextEditingController tedc2 = TextEditingController();
  TextEditingController tedc = TextEditingController();
  TextEditingController tedc3 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    charbons = produits.where((element) => element.type == TypeProduit.Charbon).toList();
    tetes = produits.where((element) => element.type == TypeProduit.TeteDeChicha).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.7,
              color: Colors.blue.shade200,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Text(
                        'Vos produits',
                        style: GoogleFonts.abel(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 1, top: 5),
                  child: Text(
                    "Veuillez suspendre les produits dont vous ne disposez pas actuellement",
                    style: GoogleFonts.abel(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(
                                    "magasins/" + Shish.sharedPreferences.getString(Shish.magasinUID) + "/produits")
                                .snapshots(),
                            builder: (context, datasnapshot) {
                              return !datasnapshot.hasData
                                  ? Center(
                                      child: Text("Veuillez ajouter des produits"),
                                    )
                                  : SizedBox(
                                      height: MediaQuery.of(context).size.height,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: datasnapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    datasnapshot.data.docs[index].data()["id"],
                                                    style: GoogleFonts.abel(
                                                        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  InkWell(
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.add),
                                                        Text(
                                                          "Ajouter un produit",
                                                          style: GoogleFonts.abel(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Alert(
                                                          context: context,
                                                          title: 'Ajouter un nouveau type de produit',
                                                          content: Form(
                                                            key: _formKey2,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                  child: Text(
                                                                    'Nom du produit',
                                                                    style: GoogleFonts.abel(
                                                                        color: Colors.black, fontSize: 12),
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
                                                                    keyboardType: TextInputType.text,
                                                                    validator: (value) {
                                                                      if (value.isEmpty)
                                                                        return 'Veuillez Entrer le nom de votre produit';
                                                                      setState(() {});
                                                                      return null;
                                                                    }),
                                                                SizedBox(
                                                                  height: MediaQuery.of(context).size.height * 0.02,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                  child: Text(
                                                                    'Prix',
                                                                    style: GoogleFonts.abel(
                                                                        color: Colors.black, fontSize: 12),
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                    controller: tedc3,
                                                                    decoration: InputDecoration(
                                                                      border: new OutlineInputBorder(
                                                                        borderSide: BorderSide(),
                                                                      ),
                                                                      fillColor: Colors.blue.shade100,
                                                                    ),
                                                                    keyboardType: TextInputType.number,
                                                                    validator: (value) {
                                                                      if (value.isEmpty)
                                                                        return 'Veuillez Entrer le prix de votre produit';
                                                                      setState(() {});
                                                                      return null;
                                                                    }),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                  child: Text(
                                                                    'Photo du produit',
                                                                    style: GoogleFonts.abel(
                                                                        color: Colors.black, fontSize: 12),
                                                                  ),
                                                                ),
                                                                FlatButton(
                                                                    color: Colors.green.shade400,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    onPressed: chooseImage,
                                                                    child: Text("Importer une image"))
                                                              ],
                                                            ),
                                                          ),
                                                          buttons: [
                                                            DialogButton(
                                                              color: Colors.blueAccent.shade100,
                                                              onPressed: () {
                                                                _formKey2.currentState.validate();
                                                                uploadImagetoFirestore(context).whenComplete(() {
                                                                  if (url != "") {
                                                                    FirebaseFirestore.instance
                                                                        .collection("magasins/" +
                                                                            Shish.sharedPreferences
                                                                                .getString(Shish.magasinUID) +
                                                                            "/produits/" +
                                                                            datasnapshot.data.docs[index].data()["id"] +
                                                                            "/articles")
                                                                        .doc()
                                                                        .set({
                                                                      "nom": tedc.text,
                                                                      "prix": (int.parse(tedc3.text) * 1.2)
                                                                          .toStringAsFixed(2),
                                                                      "etat": '1',
                                                                      "img": url
                                                                    }).then((value) async {
                                                                      await Shish.sharedPreferences.setString(
                                                                          Shish.magasinCardList,
                                                                          tedc.text == null ? '' : tedc.text);
                                                                    }).whenComplete(() {
                                                                      setState(() {
                                                                        url = "";
                                                                        Navigator.of(context).pop();
                                                                        Scaffold.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Produit ajouté avec succés")));
                                                                      });
                                                                    });
                                                                  } else {
                                                                    Scaffold.of(context).showSnackBar(SnackBar(
                                                                        content: Text(
                                                                            "Veuillez importer une image sans arriere plan pour votre produit")));
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                'Ajouter',
                                                                style: GoogleFonts.abel(color: Colors.black),
                                                              ),
                                                            )
                                                          ]).show();
                                                    },
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.38,
                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance
                                                        .collection("magasins/" +
                                                            Shish.sharedPreferences.getString(Shish.magasinUID) +
                                                            "/produits/" +
                                                            datasnapshot.data.docs[index].data()["id"] +
                                                            "/articles")
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      return !snapshot.hasData
                                                          ? Center(
                                                              child: Text("..."),
                                                            )
                                                          : PageView.builder(
                                                              itemCount: snapshot.data.docs.length,
                                                              controller: PageController(viewportFraction: 0.8),
                                                              itemBuilder: (context, i) {
                                                                return Opacity(
                                                                  opacity: snapshot.data.docs[i].data()['etat'] == '1'
                                                                      ? 1.0
                                                                      : 0.5,
                                                                  child: Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                      horizontal: 10,
                                                                    ),
                                                                    child: Stack(
                                                                      children: [
                                                                        Hero(
                                                                          tag: "background-${i.toString()}",
                                                                          child: Material(
                                                                            elevation: 10,
                                                                            shape: PlatCardShape(
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.55,
                                                                                MediaQuery.of(context).size.height *
                                                                                    0.32),
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.fromLTRB(70, 12, 0, 0),
                                                                          child: Align(
                                                                            child: snapshot.data.docs[i]
                                                                                        .data()['img'] !=
                                                                                    null
                                                                                ? Image.network(
                                                                                    snapshot.data.docs[i].data()['img'],
                                                                                    height: 100,
                                                                                    width: 100,
                                                                                  )
                                                                                : SizedBox(height: 100, width: 100,),
                                                                            alignment: Alignment(0, 1),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top: 80,
                                                                          left: 15,
                                                                          right: 32,
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    snapshot.data.docs[i].data()["nom"],
                                                                                    style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w800),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height:
                                                                                    MediaQuery.of(context).size.height *
                                                                                        0.02,
                                                                              ),
                                                                              Text(
                                                                                "Prix : " +
                                                                                    (double.parse(snapshot.data.docs[i]
                                                                                                .data()["prix"]) *
                                                                                            0.83333)
                                                                                        .toStringAsFixed(2) +
                                                                                    " €",
                                                                                style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w300),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                    right: MediaQuery.of(context)
                                                                                            .size
                                                                                            .width *
                                                                                        0.13),
                                                                                child: FlatButton(
                                                                                  color: snapshot.data.docs[i]
                                                                                              .data()['etat'] ==
                                                                                          '1'
                                                                                      ? Colors.redAccent
                                                                                          .withOpacity(0.8)
                                                                                      : Colors.green.shade400,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Icon(snapshot.data.docs[i]
                                                                                                  .data()['etat'] ==
                                                                                              '1'
                                                                                          ? Icons.pause
                                                                                          : Icons.play_arrow),
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context)
                                                                                                .size
                                                                                                .width *
                                                                                            0.01,
                                                                                      ),
                                                                                      Text(
                                                                                        snapshot.data.docs[i]
                                                                                                    .data()['etat'] ==
                                                                                                '1'
                                                                                            ? 'Suspendre'
                                                                                            : 'Activer',
                                                                                        style: GoogleFonts.abel(
                                                                                            fontSize: 14,
                                                                                            fontWeight:
                                                                                                FontWeight.w500),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(5)),
                                                                                  onPressed: () async {
                                                                                    snapshot.data.docs[i].data()['etat'] ==
                                                                                            '1'
                                                                                        ? await FirebaseFirestore.instance
                                                                                            .collection("magasins/" +
                                                                                                Shish.sharedPreferences.getString(
                                                                                                    Shish.magasinUID) +
                                                                                                "/produits/" +
                                                                                                datasnapshot
                                                                                                    .data.docs[index]
                                                                                                    .data()["id"] +
                                                                                                "/articles")
                                                                                            .doc(snapshot
                                                                                                .data.docs[i].id)
                                                                                            .update({'etat': '0'}).whenComplete(
                                                                                                () {
                                                                                            setState(() {});
                                                                                          })
                                                                                        : await FirebaseFirestore.instance
                                                                                            .collection("magasins/" +
                                                                                                Shish.sharedPreferences.getString(Shish.magasinUID) +
                                                                                                "/produits/" +
                                                                                                datasnapshot.data.docs[index].data()["id"] +
                                                                                                "/articles")
                                                                                            .doc(snapshot.data.docs[i].id)
                                                                                            .update({'etat': '1'}).whenComplete(() {
                                                                                            setState(() {});
                                                                                          });
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
                                              SizedBox(
                                                height: 150,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: FlatButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        Alert(
                            context: context,
                            title: 'Ajouter un nouveau type de produit',
                            content: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Type de produit',
                                      style: GoogleFonts.abel(color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                  TextFormField(
                                      controller: tedc2,
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                        fillColor: Colors.blue.shade100,
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value.isEmpty) return 'Veuillez entrer le type de produits';
                                        setState(() {});
                                        return null;
                                      }),
                                ],
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                color: Colors.blueAccent.shade100,
                                onPressed: () {
                                  _formKey.currentState.validate();
                                  FirebaseFirestore.instance
                                      .collection("magasins/" +
                                          Shish.sharedPreferences.getString(Shish.magasinUID) +
                                          "/produits")
                                      .doc(tedc2.text)
                                      .set({
                                    "id": tedc2.text,
                                  }).then((value) async {
                                    await Shish.sharedPreferences
                                        .setString(Shish.magasinCardList, tedc2.text == null ? '' : tedc2.text);
                                  }).whenComplete(() {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(content: Text("Type de produit ajouté avec succés")));
                                    });
                                  });
                                },
                                child: Text(
                                  'Ajouter',
                                  style: GoogleFonts.abel(color: Colors.black),
                                ),
                              )
                            ]).show();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          Text(
                            "Ajouter un nouveau type de produits",
                            style: GoogleFonts.abel(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ))
          ],
        ),
      ),
    );
  }

  Future chooseImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgFile = File(pickedFile.path);
    });
  }

  Future uploadImagetoFirestore(BuildContext context) async {
    String fileName = _imgFile.path;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(_imgFile).whenComplete(() => null);
    do {
      print(taskSnapshot.bytesTransferred);
    } while (taskSnapshot.bytesTransferred < taskSnapshot.totalBytes);
    var img = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      url = img;
    });
  }
}

class Chich extends StatefulWidget {
  final int index;
  final List<Produit> produits;

  const Chich({
    Key key,
    this.index,
    this.produits,
  }) : super(key: key);

  @override
  _ChichState createState() => _ChichState();
}

class _ChichState extends State<Chich> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Stack(
        children: [
          Hero(
            tag: "background-${widget.produits[widget.index].name}",
            child: Material(
              elevation: 10,
              shape: PlatCardShape(MediaQuery.of(context).size.width * 0.55, MediaQuery.of(context).size.height * 0.32),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Align(
              child: Image.asset(
                widget.produits[widget.index].imagePath,
                height: 100,
                width: 100,
              ),
              alignment: Alignment(0, 0.8),
            ),
          ),
          Positioned(
            top: 80,
            left: 15,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            widget.produits[widget.index].name,
                            style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.28),
                  child: FlatButton(
                    color: Colors.green.withOpacity(0.8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete_forever),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          'Supprimer',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      SweetAlert.show(context,
                          title: "Attention",
                          subtitle: "Êtes vous sûrs de la suppression ?",
                          style: SweetAlertStyle.confirm,
                          showCancelButton: true,
                          // ignore: missing_return
                          onPress: (bool isConfirm) {
                        if (isConfirm) {
                          SweetAlert.show(context, subtitle: "Suppression...", style: SweetAlertStyle.loading);
                          setState(() {
                            mesprodcmd.remove(mesprodcmd[widget.index]);
                          });
                          new Future.delayed(new Duration(seconds: 1), () {
                            SweetAlert.show(context,
                                subtitle: "Annulation avec succés", style: SweetAlertStyle.success);
                          });
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
