import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/config.dart';

import '../bars.dart';
import 'accueilBar.dart';

class Produits extends StatefulWidget with NavStates{
  @override
  _ProduitsState createState() => _ProduitsState();
}
int selectedOption=0;
class _ProduitsState extends State<Produits> {
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
          Background(width: MediaQuery.of(context).size.width*0.6,height: MediaQuery.of(context).size.height*0.7,color: Colors.blue.shade200,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.06
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'Vos produits',
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 22,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.03
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'Chichas',
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 18,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40,right: 1,top: 5),
                child: Text(
                  "Veuillez suspendre les chichas dont vous ne disposez pas à l'heure actuel",
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 12,fontWeight: FontWeight.normal
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.4,
                child:
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barChichas").snapshots(),
                  builder: (context,  dataSnapShot) {
                    return !dataSnapShot.hasData
                        ? Center(child: Text("Chargement ..."),)
                        : PageView.builder(
                          itemCount: dataSnapShot.data.docs.length,
                          controller: PageController(viewportFraction: 0.8),
                          itemBuilder: (context,index){
                            return Chich(index: index,snapshot: dataSnapShot,);
                      },
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int index=0;index<options.length;index++)
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: _OptionWidget(option:options[index].option,isSelected: options[index].id==selectedOption,),
                            ),
                            onTap: (){
                              setState(() {
                                selectedOption=options[index].id;
                              });
                              switch(index){
                                case 0:BlocProvider.of<OptionsNavBloc>(context).add(OptionsNavEvents.GoutClickedEvent);break;
                                case 1:BlocProvider.of<OptionsNavBloc>(context).add(OptionsNavEvents.BoissonsClickedEvent);break;
                                case 2:BlocProvider.of<OptionsNavBloc>(context).add(OptionsNavEvents.SupplementClickedEvent);break;
                                case 3:BlocProvider.of<OptionsNavBloc>(context).add(OptionsNavEvents.AccoClickedEvent);break;
                              }

                            },
                          )
                      ],
                    ),
                  )
              ),
              Expanded(
                child: BlocBuilder<OptionsNavBloc,NavStates>(
                  builder: (context,navigationState){
                    return navigationState as Widget;
                  },
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.02,),

            ],
          )
        ],
      ),
    );
  }
}


class Chich extends StatefulWidget {
  final int index;
  final AsyncSnapshot snapshot;
  const Chich({Key key, this.index, this.snapshot}) : super(key: key);
  @override
  _ChichState createState() => _ChichState();
}

class _ChichState extends State<Chich> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?1.0:0.5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,),
        child: Stack(
          children: [
            Hero(
              tag: "background-${widget.snapshot.data.docs[widget.index]}",
              child: Material(
                elevation: 10,
                shape:  PlatCardShape(MediaQuery.of(context).size.width*0.55,MediaQuery.of(context).size.height*0.32),
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,0,0,0),
              child: Align(
                child: Image.network(widget.snapshot.data.docs[widget.index].data()["img"],height: 140,width: 140,),
                alignment: Alignment(0, 0.6),),
            ),
            Positioned(
              top:80,
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
                            padding: const EdgeInsets.only(top:16.0),
                            child:
                            Text("Chicha "+widget.snapshot.data.docs[widget.index].data()["type"],style: GoogleFonts.abel(fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                          widget.snapshot.data.docs[widget.index].data()["etat"]=="1"?
                          Text("",style: GoogleFonts.abel(fontWeight: FontWeight.normal,fontSize: 12),):
                          Text("Suspendue ",style: GoogleFonts.abel(fontWeight: FontWeight.normal,fontSize: 12),)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.001,),

                  Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.28),
                    child:widget.snapshot.data.docs[widget.index].data()["etat"]=="1"? FlatButton(
                      color: Colors.redAccent.withOpacity(0.8),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.pause),
                          SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                          Text('Suspendre',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      onPressed: (){
                        FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barChichas").doc((widget.index+1).toString()).update({
                          "etat":"0"
                        }).whenComplete(() {}).then((value) {
                          setState(() {
                          });
                        });
                      },
                    ):FlatButton(
                      color: Colors.green.withOpacity(0.8),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.play_arrow),
                          SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                          Text('Activer',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      onPressed: (){
                        FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/barChichas").doc((widget.index+1).toString()).update({
                          "etat":"1"
                        }).whenComplete(() {}).then((value) {
                          setState(() {
                          });
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
  }
}
class _OptionWidget extends StatelessWidget{

  final String option;
  final bool isSelected;
  const _OptionWidget({Key key,@required this.option,this.isSelected=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(18),
        child: Container(
            padding: const EdgeInsets.all(8),
            width: isSelected?MediaQuery.of(context).size.width*0.33:MediaQuery.of(context).size.width*0.33,
            height: isSelected?MediaQuery.of(context).size.height*0.06:MediaQuery.of(context).size.height*0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected ?Colors.green.shade400:Colors.white,
            ),
            child: Center(child: Text(option,style: GoogleFonts.abel(fontSize: 14,fontWeight:FontWeight.bold,color: isSelected?Colors.white:Colors.green.shade400),))
        ),
      ),
    );
  }
}


