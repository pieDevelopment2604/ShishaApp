import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/bars.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/config.dart';

class Historique extends StatefulWidget with NavigationStates{
  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
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
                    Text('Mon Historique',style: GoogleFonts.abel(fontSize: 26),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,),
              Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.9,
                    child:StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("clients/"+Shish.sharedPreferences.getString(Shish.clientUID)+"/historique").snapshots(),
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
                                            Container(
                                                height: MediaQuery.of(context).size.height*0.15,
                                                width: MediaQuery.of(context).size.width*0.4,
                                                child: Image.network(snapshot.data.docs[index].data()["img"],fit: BoxFit.contain,)
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.02,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Chicha : "+snapshot.data.docs[index].data()["chicha"],style: GoogleFonts.abel(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                                Text("Gout : "+snapshot.data.docs[index].data()["gout"],style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("Boissons : "+(snapshot.data.docs[index].data()["boisson"]==null?'-':snapshot.data.docs[index].data()["boisson"]),style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("Accompagnements : " + (snapshot.data.docs[index].data()["acco"]==null?'-':snapshot.data.docs[index].data()["acco"]),style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("Supplements : "+((snapshot.data.docs[index].data()["supp"]==null?'-':snapshot.data.docs[index].data()["supp"])),style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("Total : "+snapshot.data.docs[index].data()["total"]+" €",style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("De chez : "+snapshot.data.docs[index].data()["barName"],style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              ],
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
          Positioned(
            bottom: 0,
              left: 10,
              right: 10,
              child:FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  onPressed: (){
                    setState(() {
                      FirebaseFirestore.instance.collection("clients/"+Shish.sharedPreferences.getString(Shish.clientUID)+"/historique").get().then((snapshot) {
                        for (DocumentSnapshot ds in snapshot.docs){
                          ds.reference.delete();
                        }
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                      Text('Vider votre historique',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                    ],
                  )
              )
          )
        ],
      ),
    );
  }


}
