import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';

import 'package:shish/config.dart';

import 'bloc/coursierNav.dart';

class HistoriqueL extends StatefulWidget with NavStates{
  @override
  _HistoriqueLState createState() => _HistoriqueLState();
}

class _HistoriqueLState extends State<HistoriqueL> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.6,color: Colors.blue.shade200,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,),
              Padding(
                padding: const EdgeInsets.only(left:48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Icon(Icons.timer),
                    ),
                    Text('Historique de livraisons',style: GoogleFonts.abel(fontSize: 26),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,),
              Expanded(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.9,
                      child:StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("livreurs/"+Shish.sharedPreferences.getString(Shish.livreurUID)+"/historique").snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData?
                            Center(child: Text("Chargement ..."),)
                                :ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context,index){
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height*0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 12),
                                      child: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Date : "+snapshot.data.docs[index].data()['date'],style: GoogleFonts.abel(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                                  Text("De chez : "+snapshot.data.docs[index].data()["srcName"],style: GoogleFonts.abel(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                                  Text("Situé à : "+snapshot.data.docs[index].data()["srcAdresse"],style: GoogleFonts.abel(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w100
                                                  ),),
                                                  Text("Adresse client : "+snapshot.data.docs[index].data()["clientAdr"],style: GoogleFonts.abel(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w100
                                                  ),),
                                                  Text("Distance : "+snapshot.data.docs[index].data()["distance"]+" km",style: GoogleFonts.abel(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w100
                                                  ),),
                                                  Text("Total : "+snapshot.data.docs[index].data()["total"].toString()+" €",style: GoogleFonts.abel(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w100
                                                  ),),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                      )

                  )
              ),

            ],
          ),
        ],
      ),
    );
  }


}
