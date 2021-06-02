import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/bar/stripe/paymentService.dart';
import 'package:shish/magasin/magasinLayout.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../bars.dart';
import '../config.dart';
import 'bloc/magasin_bloc_nav.dart';
import 'package:progress_dialog/progress_dialog.dart';


class CommandesProd extends StatefulWidget with NaviStates{
  @override
  _CommandesProdState createState() => _CommandesProdState();
}

class _CommandesProdState extends State<CommandesProd> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(width: MediaQuery.of(context).size.width*0.8,height: MediaQuery.of(context).size.height*0.6,color: Colors.blueAccent.shade100,),
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
                      child: Icon(Icons.shopping_cart),
                    ),
                    Text('Commandes',style: GoogleFonts.abel(fontSize: 26),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:60.0),
                child: SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,
                  child: Text('Balayer vers la gauche',style: GoogleFonts.abel(fontSize: 14),),
                    ),
              ),
              Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes").snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData?
                          Center(child: Text("Chargement ..."),)
                              :ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context,index){
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes/"+snapshot.data.docs[index].id+"/commandes").snapshots(),
                                  builder: (context, datasnapshot) {
                                    return !datasnapshot.hasData?Center(child: Text(""),)
                                        :Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1
                                          )
                                        )
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height*0.35,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,

                                          itemCount: datasnapshot.data.docs.length,
                                          itemBuilder: (context,i){
                                            return Padding(
                                              padding: const EdgeInsets.all(18.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width*0.9,
                                                height: MediaQuery.of(context).size.height*0.35,
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
                                                            child: Image.network(datasnapshot.data.docs[i].data()["img"],fit: BoxFit.contain,)
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.02,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(datasnapshot.data.docs[i].data()["produit"],style: GoogleFonts.abel(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold
                                                            ),),
                                                            Text("Type : "+datasnapshot.data.docs[i].data()["type"],style: GoogleFonts.abel(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w100
                                                            ),),
                                                            Text("Total : "+(double.parse(datasnapshot.data.docs[i].data()["total"])/1.2).toStringAsFixed(2)+" €",style: GoogleFonts.abel(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w100
                                                            ),),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.02,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width*0.3,
                                                              child: FlatButton(
                                                                  color: Colors.green.shade400,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5)
                                                                  ),
                                                                  onPressed: (){
                                                                    setState(() {
                                                                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>CommandeDetails(cmd: datasnapshot.data.docs[i],)));
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons.check),
                                                                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                                      Text('Valider',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                                    ],
                                                                  )
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width*0.3,
                                                              child: FlatButton(
                                                                  color: Colors.red,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5)
                                                                  ),
                                                                  onPressed: (){
                                                                    setState(() {
                                                                      SweetAlert.show(context,title: "Attention",subtitle: "Êtes vous sûrs de l'annulation ?",style: SweetAlertStyle.confirm,showCancelButton: true,
                                                                          // ignore: missing_return
                                                                          onPress: (bool isConfirm){
                                                                            if(isConfirm){
                                                                              SweetAlert.show(context,subtitle: "Suppression...", style: SweetAlertStyle.loading);
                                                                              setState(() {
                                                                                FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes/"+snapshot.data.docs[index].id+"/commandes").doc(datasnapshot.data.docs[i].id).delete().whenComplete(() => null).then((value) {
                                                                                  FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes/"+snapshot.data.docs[index].id+"/commandes").get().then((value) {
                                                                                    if(value.docs.length==0)
                                                                                    {
                                                                                      FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes").doc(snapshot.data.docs[index].id).delete();
                                                                                    }
                                                                                  });
                                                                                });                                                                         });
                                                                              new Future.delayed(new Duration(seconds:1),(){
                                                                                SweetAlert.show(context,subtitle: "Annulation avec succés", style: SweetAlertStyle.success);
                                                                              });
                                                                            }
                                                                          }
                                                                      );
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons.delete),
                                                                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                                      Text('Rejetter',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                                    ],
                                                                  )
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                    );
                                  }
                                );
                              });
                        }
                    )
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 7,
            right: 5,
            child:FlatButton(
                color: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                onPressed: (){
                  setState(() {
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history,color: Colors.white,),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    Center(child: Text('Rafraichir',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),
                  ],
                )
            ) ,
          )
        ],
      ),
    );
  }
}
class CommandeDetails extends StatefulWidget {
  final QueryDocumentSnapshot cmd;

  const CommandeDetails({Key key, this.cmd}) : super(key: key);

  @override
  _CommandeDetailsState createState() => _CommandeDetailsState();
}

class _CommandeDetailsState extends State<CommandeDetails> {
  bool clicked=false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  getClientInfosAndPay(){

    final Map<String,String> clientsInfos={'cardNumber':null,'cardCVV':null,'cardExpiry':null};
    FirebaseFirestore.instance.collection("clients").doc(widget.cmd.data()[Shish.clientUID]).get().then((value) {
      clientsInfos['cardNumber']=value.data()[Shish.clientCardList];
      clientsInfos['cardCVV']=value.data()[Shish.clientCardCVV];
      clientsInfos['cardExpiry']=value.data()[Shish.clientCardExpiry];
      print(clientsInfos['cardNumber']+'||||||||||||||'+clientsInfos['cardExpiry']);
      payWithStripe(clientsInfos['cardNumber'],clientsInfos['cardExpiry']);
    });
  }
  void payWithStripe(String cardnumber,String cardExpiry) async {
    CreditCard stripeCard= CreditCard(
        number: cardnumber,
        expMonth: int.parse(cardExpiry.split("/").first),
        expYear: int.parse(cardExpiry.split("/").last)
    );
    print(((double.parse(widget.cmd.data()['total'])*100)+((widget.cmd.data()['livraison'])*100)).toString().split('.').first);
    ProgressDialog pg=new ProgressDialog(context);
    pg.style(
      message: 'Validation en cours ...',
    );
    pg.show();
    var response =await StripeService.payWithExistingCard(
      amount: ((double.parse(widget.cmd.data()['total'])*100)+((widget.cmd.data()['livraison'])*100)).toString().split('.').first,
      currency: 'EUR',
      card: stripeCard,
    );
    await pg.hide();
    print('***************************'+response.success.toString());
    if(response.success){
      var currentbalance;
      FirebaseFirestore.instance.collection("magasins").doc(Shish.sharedPreferences.getString(Shish.magasinUID)).get().then((value) {
        currentbalance=value.data()[Shish.magasinBalance];
      }).whenComplete(() => null).then((value) {
        FirebaseFirestore.instance.collection("magasins").doc(Shish.sharedPreferences.getString(Shish.magasinUID)).update({
          Shish.magasinBalance:(double.parse(currentbalance)+double.parse(widget.cmd.data()['total'])/1.2).toStringAsFixed(2),
        });
      });
      FirebaseFirestore.instance.collection("clients").doc(widget.cmd.data()[Shish.clientUID]).collection('commandes').doc().set({
        Shish.barUID:Shish.sharedPreferences.getString(Shish.barUID),
        "produit":widget.cmd.data()['produit'],
        "type":widget.cmd.data()['type'],
        "total":widget.cmd.data()['total'],
      });
      final coordinates = new Coordinates(double.parse(Shish.sharedPreferences.getString(Shish.magasinLatitude)), double.parse(Shish.sharedPreferences.getString(Shish.magasinLongitude)));
      await Geocoder.local.findAddressesFromCoordinates(coordinates).whenComplete(() => null).then((value) {
        FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.magasinName)).set({
          "srcName":Shish.sharedPreferences.getString(Shish.magasinName),
          "srcLat":Shish.sharedPreferences.getString(Shish.magasinLatitude),
          "srcLong":Shish.sharedPreferences.getString(Shish.magasinLongitude),
          "srcAdresse":value.first.addressLine,
          "srcPhone":Shish.sharedPreferences.getString(Shish.magasinPhone)
        });
      });
      FirebaseFirestore.instance.collection('clients').doc(widget.cmd.data()[Shish.clientUID]).get().then((value) async {
        final coordinates = new Coordinates(value.data()[Shish.clientLatitude], value.data()[Shish.clientLongitude]);
        await Geocoder.local.findAddressesFromCoordinates(coordinates).whenComplete(() => null).then((value) {
          FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.magasinName)).collection("courses").doc(widget.cmd.data()[Shish.clientUID]).set({
            Shish.clientUID:widget.cmd.data()[Shish.clientUID],
            'clientAdr':value.first.addressLine
          });
        });
      });

      FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.magasinName)).collection("courses").doc(widget.cmd.data()[Shish.clientUID]).collection("courses").doc().set({
        'produit':widget.cmd.data()['produit'],
      }).whenComplete(() => null).then((value) {
        FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes/"+widget.cmd.reference.parent.parent.id+"/commandes").doc(widget.cmd.id).delete().whenComplete(() => null).then((value) {
          FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes/"+widget.cmd.reference.parent.parent.id+"/commandes").get().then((value) {
            if(value.docs.length==0)
            {
              FirebaseFirestore.instance.collection("magasins/"+Shish.sharedPreferences.getString(Shish.magasinUID)+"/commandes").doc(widget.cmd.reference.parent.parent.id).delete();
            }
          });
        });
      });
      _scaffoldkey.currentState.showSnackBar(new SnackBar(content: Text('Commande validée avec succés'),)).closed.then((value) {
        SweetAlert.show(context,title: "Merci à vous !",confirmButtonColor:Colors.green.shade400,subtitle: "Notre livreur arrive",style: SweetAlertStyle.success,
            onPress: (bool isConfirm){
              if(isConfirm) {
                Navigator.pop(context);
              }
              return true;
            });
      });
    }
    else{
      clicked=false;
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Un problème est survenu lors du paiement ')));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Builder(
        builder:(context)=> Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Background(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.9,
              color: Colors.blue.shade100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 18.0,top: 6),
                  child: Align(
                    child: IconButton(
                      icon:Icon(Icons.close),
                      iconSize: 36,
                      color: Colors.black,
                      onPressed: (){
                        setState(() {
                          Navigator.pop(context);
                          //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>MagasinLayout()));
                        });
                      },
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Details de la commande',
                    style: GoogleFonts.abel(color: Colors.black,
                        fontSize: 22,fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Veuillez préparer la commande suivante :',
                    style: GoogleFonts.abel(color: Colors.black,
                        fontSize: 18,fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.03),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18,top: 10),
                          child: Text(
                            'Voici les détails de la commande à préparer :',
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 16,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.02,
                        ),
                        Table(
                          children: [
                            TableRow(
                                children: [
                                  Center(child: Text("Produit",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["produit"],style: GoogleFonts.abel(fontSize:14,),)),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Center(child: Text('Type',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["type"],style: GoogleFonts.abel(fontSize:14),)),
                                ]
                            ),
                          ],
                        ),
                        Center(child: Image.network(widget.cmd.data()["img"],height: MediaQuery.of(context).size.height*0.25,width: MediaQuery.of(context).size.width*0.4,)),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18,top: 10),
                          child: Text(
                            'Commande préparée ?',
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 16,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:18,top: 6),
                          child: Text(
                            'Cliquez sur Valider dés que vous finissez de préparer la commande, notre livreur viendra la chercher',
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 12,fontWeight: FontWeight.normal
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.02,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.3,vertical: 20),
                          child: Center(
                            child: FlatButton(
                                color: Colors.green.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                onPressed: (){
                                  mesprodcmd.remove(widget.cmd);
                                  setState(() {
                                    if(!clicked)
                                      {
                                        getClientInfosAndPay();
                                        clicked=true;
                                      }
                                    else{
                                      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Cette commande est déja validé")));
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                    Text('Valider',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
