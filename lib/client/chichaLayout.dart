import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/client/panier.dart';
import 'package:shish/config.dart';

import '../bars.dart';

class ChichaLayout extends StatefulWidget {
  final DocumentSnapshot bar;
  final QueryDocumentSnapshot chicha;
  final double distanceLivraison;

  const ChichaLayout({Key key, this.bar, this.chicha, this.distanceLivraison}) : super(key: key);

  @override
  _ChichaLayoutState createState() => _ChichaLayoutState();
}

class _ChichaLayoutState extends State<ChichaLayout> {
  Comm commande;
  QueryDocumentSnapshot gout;
  QueryDocumentSnapshot boisson;
  QueryDocumentSnapshot supp;
  QueryDocumentSnapshot acco;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    commande = Comm(widget.bar, null, null, null, null, widget.chicha, widget.distanceLivraison);
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28.0, left: 28.0),
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
                          'Bienvenue chez ' + widget.bar.data()[Shish.barName],
                          style: GoogleFonts.abel(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text('Completez votre commande',
                        style: GoogleFonts.abel(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text('Vous avez choisi notre chicha ' + widget.chicha.data()["type"],
                        style: GoogleFonts.abel(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        )),
                    Center(
                        child: Image.network(
                      widget.chicha.data()["img"],
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.4,
                    )),
                    Padding(
                      padding: EdgeInsets.only(right: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personnaliser votre commande',
                              style: GoogleFonts.abel(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              )),
                          Divider(
                            height: 5,
                            thickness: 2,
                            color: Colors.blue.withOpacity(0.5),
                            indent: 0,
                            endIndent: 0,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ListView(
                              children: [
                                ExpansionTile(
                                  title: Text(
                                    'Gout',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  subtitle: Text(
                                    'Obligatoire',
                                    style: TextStyle(fontSize: 10, color: Colors.red),
                                  ),
                                  initiallyExpanded: true,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: double.infinity,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("bars/" + widget.bar.data()[Shish.barUID] + "/barGouts")
                                              .snapshots(),
                                          builder: (context, datasnapshot) {
                                            return !datasnapshot.hasData
                                                ? Center(
                                                    child: Text("Chargement ..."),
                                                  )
                                                : ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (datasnapshot.data.docs[index].data()["etat"] == "1") {
                                                            setState(() {
                                                              if (gout != null &&
                                                                  gout.data()["type"] ==
                                                                      datasnapshot.data.docs[index].data()["type"]) {
                                                                gout = null;
                                                              } else {
                                                                gout = datasnapshot.data.docs[index];
                                                                print(gout.data()["type"]);
                                                              }
                                                            });
                                                          } else {
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Gout non disponible actuellement, essayez avec d'autres s'il vous plait")));
                                                          }
                                                        },
                                                        child: _OptionWidget(
                                                            option: datasnapshot.data.docs[index].data()["type"],
                                                            isSelected: gout == null
                                                                ? false
                                                                : gout.data()["type"] ==
                                                                    datasnapshot.data.docs[index].data()["type"],
                                                            isUp: datasnapshot.data.docs[index].data()["etat"] == "1"),
                                                      );
                                                    },
                                                    itemCount: datasnapshot.data.docs.length,
                                                  );
                                          }),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Boissons',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  initiallyExpanded: false,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: double.infinity,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("bars/" + widget.bar.data()[Shish.barUID] + "/barBoissons")
                                              .snapshots(),
                                          builder: (context, datasnapshot) {
                                            return !datasnapshot.hasData
                                                ? Center(
                                                    child: Text("Chargement ..."),
                                                  )
                                                : ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (datasnapshot.data.docs[index].data()["etat"] == "1") {
                                                            setState(() {
                                                              if (boisson != null &&
                                                                  boisson.data()["type"] ==
                                                                      datasnapshot.data.docs[index].data()["type"]) {
                                                                boisson = null;
                                                              } else {
                                                                boisson = datasnapshot.data.docs[index];
                                                                print(boisson.data()["type"]);
                                                              }
                                                            });
                                                          } else {
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Boisson non disponible actuellement, essayez avec d'autres s'il vous plait")));
                                                          }
                                                        },
                                                        child: _OptionWidget(
                                                            option: datasnapshot.data.docs[index].data()["type"],
                                                            isSelected: boisson == null
                                                                ? false
                                                                : boisson.data()["type"] ==
                                                                    datasnapshot.data.docs[index].data()["type"],
                                                            isUp: datasnapshot.data.docs[index].data()["etat"] == "1"),
                                                      );
                                                    },
                                                    itemCount: datasnapshot.data.docs.length,
                                                  );
                                          }),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Suppléments',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  initiallyExpanded: false,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: double.infinity,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("bars/" + widget.bar.data()[Shish.barUID] + "/barSupps")
                                              .snapshots(),
                                          builder: (context, datasnapshot) {
                                            return !datasnapshot.hasData
                                                ? Center(
                                                    child: Text("Chargement ..."),
                                                  )
                                                : ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (datasnapshot.data.docs[index].data()["etat"] == "1") {
                                                            setState(() {
                                                              if (supp != null &&
                                                                  supp.data()["type"] ==
                                                                      datasnapshot.data.docs[index].data()["type"]) {
                                                                supp = null;
                                                              } else {
                                                                supp = datasnapshot.data.docs[index];
                                                                print(supp.data()["type"]);
                                                              }
                                                            });
                                                          } else {
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Supplément non disponible actuellement, essayez avec d'autres s'il vous plait")));
                                                          }
                                                        },
                                                        child: _OptionWidget(
                                                            option: datasnapshot.data.docs[index].data()["type"],
                                                            isSelected: supp == null
                                                                ? false
                                                                : supp.data()["type"] ==
                                                                    datasnapshot.data.docs[index].data()["type"],
                                                            isUp: datasnapshot.data.docs[index].data()["etat"] == "1"),
                                                      );
                                                    },
                                                    itemCount: datasnapshot.data.docs.length,
                                                  );
                                          }),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Accompagnements',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  initiallyExpanded: false,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: double.infinity,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("bars/" + widget.bar.data()[Shish.barUID] + "/barAccos")
                                              .snapshots(),
                                          builder: (context, datasnapshot) {
                                            return !datasnapshot.hasData
                                                ? Center(
                                                    child: Text("Chargement ..."),
                                                  )
                                                : ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (datasnapshot.data.docs[index].data()["etat"] == "1") {
                                                            setState(() {
                                                              if (acco != null &&
                                                                  acco.data()["type"] ==
                                                                      datasnapshot.data.docs[index].data()["type"]) {
                                                                acco = null;
                                                              } else {
                                                                acco = datasnapshot.data.docs[index];
                                                                print(acco.data()["type"]);
                                                              }
                                                            });
                                                          } else {
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Accompagnement non disponible actuellement, essayez avec d'autres s'il vous plait")));
                                                          }
                                                        },
                                                        child: _OptionWidget(
                                                            option: datasnapshot.data.docs[index].data()["type"],
                                                            isSelected: acco == null
                                                                ? false
                                                                : acco.data()["type"] ==
                                                                    datasnapshot.data.docs[index].data()["type"],
                                                            isUp: datasnapshot.data.docs[index].data()["etat"] == "1"),
                                                      );
                                                    },
                                                    itemCount: datasnapshot.data.docs.length,
                                                  );
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.blue.withOpacity(0.5),
                            indent: 0,
                            endIndent: 0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Details de votre commande',
                        style: GoogleFonts.abel(fontSize: 16),
                      ),
                    ),
                  ),
                  Table(
                    children: [
                      TableRow(children: [
                        Center(
                            child: Text(
                          "Type",
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        Center(
                            child: Text(
                          widget.chicha.data()["type"],
                          style: GoogleFonts.abel(
                            fontSize: 14,
                          ),
                        )),
                        Center(
                            child: Text(
                          widget.chicha.data()["prix"] + "€",
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                      ]),
                      TableRow(children: [
                        Center(
                            child: Text(
                          'Gout',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        Center(
                            child: Text(
                          gout == null ? '-' : gout.data()["type"],
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                        Center(
                            child: Text(
                          '-',
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                      ]),
                      TableRow(children: [
                        Center(
                            child: Text(
                          'Boisson',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        Center(
                            child: Text(
                          boisson == null ? '-' : boisson.data()["type"],
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                        Center(
                            child: Text(
                          boisson == null ? '-' : boisson.data()["prix"] + "€",
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                      ]),
                      TableRow(children: [
                        Center(
                            child: Text(
                          'Supplément',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        Center(
                            child: Text(
                          supp == null ? '-' : supp.data()["type"],
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                        Center(
                            child: Text(
                          supp == null ? '-' : supp.data()["prix"] + "€",
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                      ]),
                      TableRow(children: [
                        Center(
                            child: Text(
                          'Accompagnement',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        Center(
                            child: Text(
                          acco == null ? '-' : acco.data()["type"],
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                        Center(
                            child: Text(
                          acco == null ? '-' : acco.data()["prix"] + "€",
                          style: GoogleFonts.abel(fontSize: 14),
                        )),
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Builder(
                        builder: (context) {
                          return FlatButton(
                            color: Colors.green.withOpacity(0.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.shopping_basket),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                Text(
                                  'Ajouter au panier',
                                  style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              if (gout != null) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Commande ajoutée, Consultez votre panier pour la valider")));
                                commande.gout = gout;
                                commande.supp = supp;
                                commande.boisson = boisson;
                                commande.acco = acco;
                                panier.add(commande);
                                setState(() {
                                  commande =
                                      Comm(widget.bar, null, null, null, null, widget.chicha, widget.distanceLivraison);
                                  gout = null;
                                  supp = null;
                                  boisson = null;
                                  acco = null;
                                });
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content:
                                        Text("Impossible de passer cette commande, le choix du gout est obligatoire")));
                              }
                            },
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.07,
            top: MediaQuery.of(context).size.width * 0.25,
            child: Stack(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue.withOpacity(0.2)),
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
    );
  }
}

class _OptionWidget extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isUp;

  const _OptionWidget({Key key, @required this.option, this.isSelected = false, this.isUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUp ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(18),
          child: Container(
              padding: const EdgeInsets.all(8),
              width: isSelected ? MediaQuery.of(context).size.width * 0.33 : MediaQuery.of(context).size.width * 0.33,
              height:
                  isSelected ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected ? Colors.green.shade400 : Colors.white,
              ),
              child: Center(
                  child: Text(
                option,
                style: GoogleFonts.abel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.green.shade400),
              ))),
        ),
      ),
    );
  }
}
