import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/bars.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/config.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:swipe_up/swipe_up.dart';

class Cart extends StatefulWidget with NavigationStates {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int i, j;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double countTotal() {
    double sum = 0;
    if (panier.isNotEmpty) {
      for (int i = 0; i < panier.length; i++) {
        sum = sum + (panier[i].distance <= 1 ? 2 : panier[i].distance + 1);
        sum = sum +
            double.parse(panier[i].chicha.data()["prix"]) +
            double.parse(panier[i].supp == null ? '0' : panier[i].supp.data()["prix"]) +
            double.parse(panier[i].acco == null ? '0' : panier[i].acco.data()["prix"]) +
            double.parse(panier[i].boisson == null ? '0' : panier[i].boisson.data()["prix"]) +
            (panier[i].chicha.data()["type"] == 'Basique'
                ? 30
                : panier[i].chicha.data()["type"] == 'Kaloud'
                    ? 40
                    : 50);
      }
    } else {
      sum = 0;
    }
    if (magPanier.isNotEmpty) {
      for (int j = 0; j < magPanier.length; j++) {
        if (j == 0) {
          sum = sum + (magPanier[j].distance <= 1 ? 2 : magPanier[j].distance + 1);
        }
        sum = sum + double.parse(magPanier[j].produit.data()["prix"]);
      }
    }
    return sum;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SwipeUp(
          sensitivity: 0.7,
          onSwipe: () {
            setState(() {
              if ((Shish.sharedPreferences.getString(Shish.clientCardList) != "") &&
                  (Shish.sharedPreferences.getString(Shish.clientCardList) != null) &&
                  (Shish.sharedPreferences.getString(Shish.clientDate) != 'jj-mm-aaaa') &&
                  (Shish.sharedPreferences.getString(Shish.clientDate) != '') &&
                  (Age.dateDifference(
                              fromDate: DateTime(
                                  int.parse(Shish.sharedPreferences.getString(Shish.clientDate) == null
                                      ? '1900'
                                      : Shish.sharedPreferences.getString(Shish.clientDate).split('-').first),
                                  1,
                                  1),
                              toDate: DateTime.now())
                          .years) >=
                      18) {
                for (i = 0; i < panier.length; i++) {
                  FirebaseFirestore.instance
                      .collection("bars")
                      .doc(panier[i].bar.id)
                      .collection('commandes')
                      .doc()
                      .set({
                    Shish.clientUID: Shish.sharedPreferences.getString(Shish.clientUID),
                    "chicha": panier[i].chicha.data()["type"],
                    "img": panier[i].chicha.data()["img"],
                    "gout": panier[i].gout == null ? '' : panier[i].gout.data()["type"],
                    "boisson": panier[i].boisson == null ? '' : panier[i].boisson.data()["type"],
                    "acco": panier[i].acco == null ? '' : panier[i].acco.data()["type"],
                    "supp": panier[i].supp == null ? '' : panier[i].supp.data()["type"],
                    "livraison": panier[i].distance <= 1 ? 2 : panier[i].distance + 1,
                    "total": (double.parse(panier[i].chicha.data()["prix"]) +
                            double.parse(panier[i].supp == null ? '0' : panier[i].supp.data()["prix"]) +
                            double.parse(panier[i].acco == null ? '0' : panier[i].acco.data()["prix"]) +
                            double.parse(panier[i].boisson == null ? '0' : panier[i].boisson.data()["prix"]))
                        .toString()
                  });
                  FirebaseFirestore.instance
                      .collection("clients")
                      .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                      .collection('historique')
                      .doc()
                      .set({
                    Shish.barName: panier[i].bar.data()[Shish.barName],
                    "chicha": panier[i].chicha.data()["type"],
                    "img": panier[i].chicha.data()["img"],
                    "gout": panier[i].gout == null ? '' : panier[i].gout.data()["type"],
                    "boisson": panier[i].boisson == null ? '' : panier[i].boisson.data()["type"],
                    "acco": panier[i].acco == null ? '' : panier[i].acco.data()["type"],
                    "supp": panier[i].supp == null ? '' : panier[i].supp.data()["type"],
                    "total": (double.parse(panier[i].chicha.data()["prix"]) +
                            double.parse(panier[i].supp == null ? '0' : panier[i].supp.data()["prix"]) +
                            double.parse(panier[i].acco == null ? '0' : panier[i].acco.data()["prix"]) +
                            double.parse(panier[i].boisson == null ? '0' : panier[i].boisson.data()["prix"]))
                        .toString()
                  });
                }
                for (j = 0; j < magPanier.length; j++) {
                  FirebaseFirestore.instance
                      .collection("magasins")
                      .doc(magPanier[j].magasin.id)
                      .collection('commandes')
                      .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                      .set({
                    Shish.clientUID: Shish.sharedPreferences.getString(Shish.clientUID),
                  });
                  FirebaseFirestore.instance
                      .collection("magasins")
                      .doc(magPanier[j].magasin.id)
                      .collection('commandes')
                      .doc(Shish.sharedPreferences.getString(Shish.clientUID))
                      .collection("commandes")
                      .doc()
                      .set({
                    Shish.clientUID: Shish.sharedPreferences.getString(Shish.clientUID),
                    "produit": magPanier[j].produit.data()["nom"],
                    "type": magPanier[j].produit.reference.parent.parent.id,
                    "total": magPanier[j].produit.data()["prix"],
                    "img": magPanier[j].produit.data()["img"],
                    "livraison": j == 0 ? (magPanier[j].distance <= 1 ? 2 : magPanier[j].distance + 1) : 0
                  });
                }
                if ((panier.length == 0) && (magPanier.length == 0)) {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Votre panier est vide !")));
                  });
                } else {
                  setState(() {
                    SweetAlert.show(context,
                        title: "Merci à vous !",
                        confirmButtonColor: Colors.green.shade400,
                        subtitle: "   Commande passée avec succés",
                        style: SweetAlertStyle.success, onPress: (bool isConfirm) {
                      if (isConfirm) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "Votre commande est en cours de traitement, votre compte sera débité si votre commade est validé")));
                      }
                      return true;
                    });
                  });
                }
                if (i >= panier.length) {
                  setState(() {
                    panier.clear();
                  });
                }
                if (j >= magPanier.length) {
                  setState(() {
                    magPanier.clear();
                  });
                }
              } else {
                if (Shish.sharedPreferences.getString(Shish.clientDate) == 'jj-mm-aaaa') {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text("Paiement impossible, vous n'avez pas encore indiquer votre age")));
                  });
                } else {
                  if (Shish.sharedPreferences.getString(Shish.clientDate) == '') {
                    setState(() {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Paiement impossible, vous n'avez pas encore indiquer votre age")));
                    });
                  } else {
                    if ((Age.dateDifference(
                                fromDate: DateTime(
                                    int.parse(Shish.sharedPreferences.getString(Shish.clientDate) == null
                                        ? '1900'
                                        : Shish.sharedPreferences.getString(Shish.clientDate).split('-').first),
                                    1,
                                    1),
                                toDate: DateTime.now())
                            .years) <
                        18) {
                      setState(() {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "Paiement impossible, vous n'avez pas l'age suffisant pour effectuer une commande sur cette l'application")));
                      });
                    } else {
                      setState(() {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "Paiement impossible, Veuillez ajouter une carte de paiment valide dans votre profil")));
                      });
                    }
                  }
                }
              }
            });
          },
          body: Stack(
            children: [
              Background(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                color: Colors.blue.shade200,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.shopping_cart),
                        ),
                        Text(
                          'Mon Panier',
                          style: GoogleFonts.abel(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 20),
                    child: Text(
                      'Chichas',
                      style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      height: MediaQuery.of(context).size.height * 0.29,
                      child: ListView.builder(
                          itemCount: panier.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.28,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Image.network(
                                            panier[index].chicha.data()["img"],
                                            fit: BoxFit.contain,
                                          )),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              panier[index].chicha.data()["type"],
                                              style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Gout : " + panier[index].gout.data()["type"],
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Boissons : " +
                                                  (panier[index].boisson == null
                                                      ? '-'
                                                      : panier[index].boisson.data()["type"]),
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Accompagnements : " +
                                                  (panier[index].acco == null
                                                      ? '-'
                                                      : panier[index].acco.data()["type"]),
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Supplements : " +
                                                  (panier[index].supp == null
                                                      ? '-'
                                                      : panier[index].supp.data()["type"]),
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Caution : " +
                                                  (panier[index].chicha.data()["type"] == 'Basique'
                                                          ? 30
                                                          : panier[index].chicha.data()["type"] == 'Kaloud'
                                                              ? 40
                                                              : 50)
                                                      .toString() +
                                                  " €",
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Livraison à : " +
                                                  (panier[index].distance <= 1 ? 2 : panier[index].distance + 1)
                                                      .toString() +
                                                  " €",
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Total : " +
                                                  (double.parse(panier[index].chicha.data()["prix"]) +
                                                          double.parse(panier[index].supp == null
                                                              ? '0'
                                                              : panier[index].supp.data()["prix"]) +
                                                          double.parse(panier[index].acco == null
                                                              ? '0'
                                                              : panier[index].acco.data()["prix"]) +
                                                          double.parse(panier[index].boisson == null
                                                              ? '0'
                                                              : panier[index].boisson.data()["prix"]))
                                                      .toString() +
                                                  " €",
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.02,
                                            ),
                                            FlatButton(
                                                color: Colors.red,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                onPressed: () {
                                                  setState(() {
                                                    panier.remove(panier[index]);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.02,
                                                    ),
                                                    Text(
                                                      'Retirer',
                                                      style:
                                                          GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 15),
                    child: Text(
                      'Articles Magasins',
                      style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: ListView.builder(
                          itemCount: magPanier.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.24,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Image.network(
                                            magPanier[index].produit.data()["img"],
                                            fit: BoxFit.contain,
                                          )),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              magPanier[index].produit.data()["nom"],
                                              style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Type : " + magPanier[index].produit.reference.parent.parent.id,
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "De chez : " + magPanier[index].magasin.data()[Shish.magasinName],
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Prix : " + magPanier[index].produit.data()["prix"] + " €",
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            Text(
                                              "Livraison à : " +
                                                  (magPanier[index].distance <= 1 ? 2 : magPanier[index].distance + 1)
                                                      .toString() +
                                                  " €",
                                              style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w100),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.02,
                                            ),
                                            FlatButton(
                                                color: Colors.red,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                onPressed: () {
                                                  setState(() {
                                                    magPanier.remove(magPanier[index]);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.02,
                                                    ),
                                                    Text(
                                                      'Retirer',
                                                      style:
                                                          GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                  /*preferences.get(Shish.clientUID) == null
                      ? SizedBox()
                      : StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('AddToCart')
                              .where('mainId',
                                  isEqualTo: preferences.get(Shish.clientUID))
                              .snapshots(),
                          builder: (context, asyncShoot) {
                            if (asyncShoot.hasError) {
                              return Center(
                                child: Text('data not found'),
                              );
                            } else if (asyncShoot.hasData) {
                              return Container(
                                height: 280,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(right: 15),
                                    itemCount: asyncShoot.data.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection(asyncShoot
                                                  .data.docs[index]
                                                  .get('collectionPath'))
                                              .doc(asyncShoot.data.docs[index]
                                                  .get('docId'))
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return snapshot.data.exists
                                                  ? Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                      ),
                                                      width: 200,
                                                      child: Stack(
                                                        overflow:
                                                            Overflow.visible,
                                                        children: [
                                                          Hero(
                                                            tag:
                                                                "background-${0.toString()}",
                                                            child: Material(
                                                              elevation: 10,
                                                              shape: PlatCardShape(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.55,
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.32),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 10,
                                                            right: -30,
                                                            child:
                                                                Image.network(
                                                              snapshot.data
                                                                      .data()[
                                                                  'img'],
                                                              height: 100,
                                                              width: 100,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 80,
                                                            left: 15,
                                                            right: 32,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data
                                                                          .data()["nom"],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.02,
                                                                ),
                                                                Text(
                                                                  "Prix : " +
                                                                      (double.parse(snapshot.data.data()["prix"]) *
                                                                              0.83333)
                                                                          .toStringAsFixed(
                                                                              2) +
                                                                      " €",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                FlatButton(
                                                                  color: Colors
                                                                      .redAccent
                                                                      .withOpacity(
                                                                          0.8),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(Icons
                                                                          .delete),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        'Delete',
                                                                        style: GoogleFonts.abel(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  onPressed:
                                                                      () async {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'AddToCart')
                                                                        .doc(asyncShoot
                                                                            .data
                                                                            .docs[
                                                                                index]
                                                                            .id)
                                                                        .delete()
                                                                        .catchError((e) =>
                                                                            print(e));
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox();
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text('data not found'),
                                              );
                                            } else {
                                              return Text('');
                                            }
                                          });
                                    }),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),*/
                ],
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
            height: MediaQuery.of(context).size.height * 0.17,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'Swipe up pour passer votre commande',
                    style: GoogleFonts.abel(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                ),
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Notez qu'une caution sera appliquée sur vos chichas selon leurs type, vous pouvez la récupérer si vous rendez la chicha dans un délai de 24 heures maximum",
                      style: GoogleFonts.abel(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        'Totale à payer : ' + countTotal().toStringAsFixed(2) + " €",
                        style: GoogleFonts.abel(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          showArrow: false,
        ),
      ),
    );
  }
}
