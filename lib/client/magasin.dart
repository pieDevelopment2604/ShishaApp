import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/client/panier.dart';
import 'package:shish/main.dart';
import 'package:toast/toast.dart';

import '../bars.dart';
import '../config.dart';
import 'accueilClient.dart';

class Magasin extends StatefulWidget {
  final DocumentSnapshot magasin;
  final double distance;

  const Magasin({Key key, this.magasin, this.distance}) : super(key: key);

  @override
  _MagasinState createState() => _MagasinState();
}

var defaultvalue = 1;

class _MagasinState extends State<Magasin> {
  MagComm magComm;
  QueryDocumentSnapshot magasin;
  QueryDocumentSnapshot produit;
  ProdCmd cmd;
  int dfv;
  List<Produit> charbons, tetes;
  int x1, x2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    magComm = MagComm(widget.magasin, null, widget.distance);
    dfv = defaultvalue;
    x1 = 1;
    x2 = 1;
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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.blue.shade200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 28, left: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 26,
                      ),
                      Text(
                        'Bienvenue chez ' + widget.magasin.data()[Shish.magasinName],
                        style: GoogleFonts.abel(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text('Voici nos produits :',
                      style: GoogleFonts.abel(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("magasins/" + widget.magasin.id + "/produits")
                                  .snapshots(),
                              builder: (context, datasnapshot) {
                                return !datasnapshot.hasData
                                    ? Center(
                                        child: Text(""),
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
                                                Text(
                                                  datasnapshot.data.docs[index].data()["id"],
                                                  style: GoogleFonts.abel(
                                                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.6,
                                                  child: StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore.instance
                                                          .collection("magasins/" +
                                                              widget.magasin.id +
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
                                                                              child: Image.network(
                                                                                snapshot.data.docs[i].data()["img"],
                                                                                height: 100,
                                                                                width: 100,
                                                                              ),
                                                                              alignment: Alignment(0, 0),
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top: 50,
                                                                            right: 60,
                                                                            child:
                                                                                snapshot.data.docs[i].data()['etat'] ==
                                                                                        '1'
                                                                                    ? Text("")
                                                                                    : Row(
                                                                                        mainAxisAlignment:
                                                                                            MainAxisAlignment.end,
                                                                                        children: [
                                                                                          Text(
                                                                                            "Non disponible",
                                                                                            style: TextStyle(
                                                                                                color: Colors.red,
                                                                                                fontSize: 10,
                                                                                                fontWeight:
                                                                                                    FontWeight.w800),
                                                                                          ),
                                                                                        ],
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
                                                                                      snapshot.data.docs[i]
                                                                                          .data()["nom"],
                                                                                      style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w800),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: MediaQuery.of(context)
                                                                                          .size
                                                                                          .height *
                                                                                      0.02,
                                                                                ),
                                                                                Text(
                                                                                  "Prix : " +
                                                                                      snapshot.data.docs[i]
                                                                                          .data()["prix"] +
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
                                                                                    color: Colors.green.shade400,
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Icon(Icons.add_shopping_cart),
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context)
                                                                                                  .size
                                                                                                  .width *
                                                                                              0.01,
                                                                                        ),
                                                                                        Text(
                                                                                          'Acheter',
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
                                                                                    onPressed: () {
                                                                                      if (snapshot.data.docs[i]
                                                                                              .data()['etat'] ==
                                                                                          '1') {
                                                                                        Toast.show(
                                                                                          "Commande ajoutée,Veuillez consultez votre panier pour la valider",
                                                                                          context,
                                                                                          duration: Toast.LENGTH_LONG,
                                                                                          gravity: Toast.BOTTOM,
                                                                                        );
                                                                                        setState(() {
                                                                                          magComm.produit =
                                                                                              snapshot.data.docs[i];
                                                                                          magPanier.add(magComm);
                                                                                          magComm = MagComm(
                                                                                              widget.magasin,
                                                                                              null,
                                                                                              widget.distance);

                                                                                          FirebaseFirestore.instance
                                                                                              .collection('AddToCart')
                                                                                              .doc(preferences
                                                                                                  .get(Shish.clientUID))
                                                                                              .set({
                                                                                            'collectionPath':
                                                                                                "magasins/" +
                                                                                                    widget.magasin.id +
                                                                                                    "/produits/" +
                                                                                                    datasnapshot.data
                                                                                                        .docs[index]
                                                                                                        .data()["id"] +
                                                                                                    "/articles",
                                                                                            'docId': snapshot
                                                                                                .data.docs[i].id,
                                                                                            'mainId': preferences
                                                                                                .get(Shish.clientUID)
                                                                                          });
                                                                                        });
                                                                                      } else {
                                                                                        Toast.show(
                                                                                          "Ce produit n'est pas disponible à l'heure actuelle. Veuillez revenir plutard ",
                                                                                          context,
                                                                                          duration: Toast.LENGTH_LONG,
                                                                                          gravity: Toast.BOTTOM,
                                                                                        );
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
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.07,
              top: MediaQuery.of(context).size.width * 0.15,
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.lightBlueAccent.withOpacity(0.5)),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          print("cart clicked");
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
                        },
                        child: Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  ),
                  (panier.length + magPanier.length) > 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                            child: Center(
                              child: Text((panier.length + magPanier.length).toString()),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
