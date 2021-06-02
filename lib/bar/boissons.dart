import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/bars.dart';

import '../config.dart';
import 'bloc/bar_nav.dart';

class BoissonsList extends StatefulWidget with NavStates{
  final List<Boiss> boissons;

  const BoissonsList({Key key, this.boissons}) : super(key: key);
  @override
  _BoissonsListState createState() => _BoissonsListState();
}

class _BoissonsListState extends State<BoissonsList> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height*0.3,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barBoissons").snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData?Center(child: Text("Chargement ..."),):
            ListView.builder(
              itemBuilder: (context,index){
                return Item(snapshot: snapshot,index:index);
              },
              itemCount: snapshot.data.docs.length,
            );
          }
      ),
    );
  }
}

class Item extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;

  const Item({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool added=true;
  @override
  void initState() {
    // TODO: implement initState
    added=true;
  }
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?1.0:0.5,
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("Boisson : ", style: GoogleFonts.abel(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:98.0),
                  child: Text(widget.snapshot.data.docs[widget.index].data()["type"], style: GoogleFonts.abel(
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: FlatButton(
                    color: widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?Colors.redAccent.shade400:Colors.green.shade400,
                    child: Row(
                      children: <Widget>[
                        Icon(widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?Icons.pause:Icons.play_arrow),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text(widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?'Suspendre':'Activer',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    onPressed: (){
                      setState(() {
                        widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?
                        FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barBoissons").doc((widget.index+1).toString()).update({
                          "etat":"0"
                        }).whenComplete(() {}).then((value) {
                          setState(() {
                          });
                        }):FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barBoissons").doc((widget.index+1).toString()).update({
                          "etat":"1"
                        }).whenComplete(() {}).then((value) {
                          setState(() {
                          });
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
