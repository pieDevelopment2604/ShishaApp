import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shish/background.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/bar/stripe/paymentService.dart';
import 'package:shish/config.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../bars.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Commandes extends StatefulWidget with NavStates{
  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
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
              SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,),
              Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.9,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/commandes").snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData?
                        Center(child: Text("Chargement ..."),)
                        :ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context,index){
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
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
                                            child: Image.network(snapshot.data.docs[index].data()["img"],fit: BoxFit.contain,)
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.02,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data.docs[index].data()["chicha"],style: GoogleFonts.abel(
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
                                                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>CommandeDetails(cmd: snapshot.data.docs[index],)));
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
                                                            FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/commandes").doc(snapshot.data.docs[index].id).delete();
                                                          });
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
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool clicked=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  getClientInfosAndPay(){
    final Map<String,String> clientsInfos={'cardNumber':null,'cardCVV':null,'cardExpiry':null};
    FirebaseFirestore.instance.collection("clients").doc(widget.cmd.data()["clientUID"]).get().then((value) {
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
    print((double.parse(widget.cmd.data()['total'])*100+(widget.cmd.data()["chicha"]=='Basique'?3000:widget.cmd.data()["chicha"]=='Kaloud'?4000:5000)+(widget.cmd.data()['livraison'])*100).toString().split('.').first);
    ProgressDialog pg=new ProgressDialog(context);
    pg.style(
      message: 'Validation en cours ...',
    );
    pg.show();
    var response =await StripeService.payWithExistingCard(
      amount: (double.parse(widget.cmd.data()['total'])*100+(widget.cmd.data()["chicha"]=='Basique'?3000:widget.cmd.data()["chicha"]=='Kaloud'?4000:5000)+(widget.cmd.data()['livraison'])*100).toString().split('.').first,
      currency: 'EUR',
      card: stripeCard,
    );
    await pg.hide();
    print('***************************'+response.message.toString());
    if(response.success){
      var currentbalance;
      FirebaseFirestore.instance.collection("bars").doc(Shish.sharedPreferences.getString(Shish.barUID)).get().then((value) {
        currentbalance=value.data()[Shish.barBalance];
      }).whenComplete(() => null).then((value) {
        FirebaseFirestore.instance.collection("bars").doc(Shish.sharedPreferences.getString(Shish.barUID)).update({
          Shish.barBalance:(double.parse(currentbalance)+double.parse(widget.cmd.data()['total'])).toStringAsFixed(2),
        });
      });
      FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+"/commandes").doc(widget.cmd.id).delete();
      FirebaseFirestore.instance.collection("clients").doc(widget.cmd.data()["clientUID"]).collection('commandes').doc().set({
        Shish.barUID:Shish.sharedPreferences.getString(Shish.barUID),
        "chicha":widget.cmd.data()["chicha"],
        "gout":widget.cmd.data()["gout"],
        "boisson":widget.cmd.data()["boisson"],
        "acco":widget.cmd.data()["acco"],
        "supp":widget.cmd.data()["supp"]
      });
      final coordinates = new Coordinates(double.parse(Shish.sharedPreferences.getString(Shish.barLatitude)), double.parse(Shish.sharedPreferences.getString(Shish.barLongitude)));
      await Geocoder.local.findAddressesFromCoordinates(coordinates).whenComplete(() => null).then((value) {
        FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.barName)).set({
          "srcName":Shish.sharedPreferences.getString(Shish.barName),
          "srcLat":Shish.sharedPreferences.getString(Shish.barLatitude),
          "srcLong":Shish.sharedPreferences.getString(Shish.barLongitude),
          "srcAdresse":value.first.addressLine,
          "srcPhone":Shish.sharedPreferences.getString(Shish.barPhone)
        });
      });
      FirebaseFirestore.instance.collection('clients').doc(widget.cmd.data()[Shish.clientUID]).get().then((value) async {
        final coordinates = new Coordinates(value.data()[Shish.clientLatitude], value.data()[Shish.clientLongitude]);
        await Geocoder.local.findAddressesFromCoordinates(coordinates).whenComplete(() => null).then((value) {
          FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.barName)).collection("courses").doc(widget.cmd.data()[Shish.clientUID]).set({
            Shish.clientUID:widget.cmd.data()[Shish.clientUID],
            'clientAdr':value.first.addressLine
          });
        });
      });

      FirebaseFirestore.instance.collection("courses").doc(Shish.sharedPreferences.getString(Shish.barName)).collection("courses").doc(widget.cmd.data()[Shish.clientUID]).collection("courses").doc().set({
        'produit':widget.cmd.data()['chicha']+','+widget.cmd.data()['gout']+','+widget.cmd.data()['boisson']+','+widget.cmd.data()['acco']+','+widget.cmd.data()['supp'],
      });
      _scaffoldkey.currentState.showSnackBar(new SnackBar(content: Text('Commande validée avec succés'),)).closed.then((value) {
        SweetAlert.show(context,title: "Merci à vous !",confirmButtonColor:Colors.green.shade400,subtitle: "Notre livreur arrive",style: SweetAlertStyle.success,
            onPress: (bool isConfirm){
              if(isConfirm) {
                BlocProvider.of<BarNavBloc>(context)
                    .add(BarNavEvents
                    .CommandesClickedEvent);
                Navigator.of(context).pop();
              }
              return true;
            });
      });
    }
    else{
      clicked=false;
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Un problème est survenu lors du paiement '),));
    }

  }
  bool iDeliver=false;
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
                          Navigator.of(context).pop();
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
                                  Center(child: Text("Type",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["chicha"],style: GoogleFonts.abel(fontSize:14,),)),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Center(child: Text('Gout',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["gout"]==null?'-':widget.cmd.data()["gout"],style: GoogleFonts.abel(fontSize:14),)),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Center(child: Text('Boissons',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["boisson"]==null?'-':widget.cmd.data()["boisson"],style: GoogleFonts.abel(fontSize:14),)),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Center(child: Text('Accompagnements',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["acco"]==null?'-':widget.cmd.data()["acco"],style: GoogleFonts.abel(fontSize:14),)),

                                ]
                            ),
                            TableRow(
                                children: [
                                  Center(child: Text('Supplements',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["supp"]==null?'-':widget.cmd.data()["supp"],style: GoogleFonts.abel(fontSize:14),)),
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
                  padding: const EdgeInsets.fromLTRB(18.0,6,18,6),
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
                                  mesCmd.remove(widget.cmd);
                                  setState(() {
                                    if(!iDeliver)
                                      {
                                        if(!clicked)
                                        {
                                          getClientInfosAndPay();
                                          clicked=true;
                                        }
                                        else{
                                          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Cette commande est déja validé")));
                                        }
                                      }else{
                                      Scaffold
                                          .of(context)
                                          .showSnackBar(SnackBar(content: Text('Veuillez livrer la commande dans les brefs délais'),backgroundColor: Colors.green.shade400,),).closed.then((value) {
                                      });
                                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>CmdDetails(clientUID: widget.cmd.data()[Shish.clientUID],cmdUID: widget.cmd.id,total:widget.cmd.data()['total'])));
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0,6,18,6),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: CheckboxListTile(
                      title: Text("Mes livreurs vont s'occuper de la livraison de cette commande",style: GoogleFonts.abel(color: Colors.red,
                          fontSize: 18,fontWeight: FontWeight.w600
                      ),),
                      value: iDeliver,
                      checkColor: Colors.white,
                      activeColor: Colors.green.shade400,
                      onChanged: (bool newValue){
                        setState(() {
                          iDeliver=newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    )
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

class CmdDetails extends StatefulWidget {
  final String clientUID;
  final String cmdUID;
  final String total;

  const CmdDetails({Key key, this.clientUID, this.cmdUID, this.total}) : super(key: key);
  @override
  _CmdDetailsState createState() => _CmdDetailsState();
}

class _CmdDetailsState extends State<CmdDetails> {
  bool clicked=false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Position position;
  String adr;
  getClientInfosAndPay(){
    final Map<String,String> clientsInfos={'cardNumber':null,'cardCVV':null,'cardExpiry':null};
    FirebaseFirestore.instance.collection("clients").doc(widget.clientUID).get().then((value) {
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
    FirebaseFirestore.instance.collection("bars/"+Shish.sharedPreferences.getString(Shish.barUID)+'/commandes').doc(widget.cmdUID).get().then((value) async {
      print('ffffffffffffffffffffffffff '+(double.parse(widget.total)*100+(value.data()["chicha"]=='Basique'?3000:value.data()["chicha"]=='Kaloud'?4000:5000)+(value.data()['livraison'])*100).toString().split('.').first);
      ProgressDialog pg=new ProgressDialog(context);
      pg.style(
        message: 'Validation en cours ...',
      );

      pg.show();
      var response =await StripeService.payWithExistingCard(
        amount: (double.parse(widget.total)*100+(value.data()["chicha"]=='Basique'?3000:value.data()["chicha"]=='Kaloud'?4000:5000)+((value.data()['livraison'])*100)).toString().split('.').first,
        currency: 'EUR',
        card: stripeCard,
      );
      await pg.hide();
      print('***************************'+response.message.toString());
      if(response.success){
        FirebaseFirestore.instance.collection("bars").doc(Shish.sharedPreferences.getString(Shish.barUID)).collection("commandes").doc(widget.cmdUID).delete();
        var currentbalance;
        FirebaseFirestore.instance.collection("bars").doc(Shish.sharedPreferences.getString(Shish.barUID)).get().then((value) {
          currentbalance=value.data()[Shish.barBalance];
        }).whenComplete(() => null).then((v) {
          FirebaseFirestore.instance.collection("bars").doc(Shish.sharedPreferences.getString(Shish.barUID)).update({
            Shish.barBalance:(double.parse(currentbalance)+double.parse(widget.total)+(value.data()['livraison'])).toStringAsFixed(2),
          });
        });
        FirebaseFirestore.instance.collection("clients").doc(widget.clientUID).collection('commandes').doc().set({
            Shish.barUID:Shish.sharedPreferences.getString(Shish.barUID),
            "chicha":value.data()["chicha"],
            "gout":value.data()["gout"],
            "boisson":value.data()["boisson"],
            "acco":value.data()["acco"],
            "supp":value.data()["supp"]
          });
        SweetAlert.show(context,title: "Commande validé avec succés",confirmButtonColor:Colors.green.shade400,subtitle: "Validez autres commandes ",style: SweetAlertStyle.success,
            onPress: (bool isConfirm){
              if(isConfirm) {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
              return true;
            });

      }
      else{
        clicked=false;
        SweetAlert.show(context,title: "Erreur lors du paiement",confirmButtonColor:Colors.green.shade400,subtitle: 'Un problème est survenu lors du paiement, revenez plutard',style: SweetAlertStyle.error,
            onPress: (bool isConfirm){
              if(isConfirm) {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
              return true;
            });

      }

    });
    
    
    
  }
  Future<void> getAddress() async {
    FirebaseFirestore.instance.collection("clients").doc(widget.clientUID).get().then((snapshot) async {
      position=Position(longitude:snapshot.data()[Shish.clientLongitude],latitude: snapshot.data()[Shish.clientLatitude]);
      final coordinates = new Coordinates(position.latitude, position.longitude);
      await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value)
      {
        setState(() {
          adr=value.first.addressLine;
        });
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: Stack(
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
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Informations sur votre client',
                    style: GoogleFonts.abel(color: Colors.black,
                        fontSize: 22,fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Veuillez communiquez ces informations à votre livreur :',
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
                            'Voici les informations de votre client :',
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 16,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.02,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection("clients").doc(widget.clientUID).snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData?Center(child: Text(""),):Table(
                              children: [
                                TableRow(
                                    children: [
                                      Center(child: Icon(Icons.person,color: Colors.blue,size: 15,),),
                                      Center(child: Text("Nom",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                      Center(child: Text(snapshot.data.data()[Shish.clientName],style: GoogleFonts.abel(fontSize:14,),)),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      Center(child: Icon(Icons.phone,color: Colors.blue,size: 15,),),
                                      Center(child: Text('Téléphone',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                      Center(child: Text(snapshot.data.data()[Shish.clientPhone],style: GoogleFonts.abel(fontSize:14),)),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      Center(child: Icon(Icons.location_on,color: Colors.blue,size: 15,),),
                                      Center(child: Text('Adresse',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                      Center(child: Text(adr==null?'':adr,style: GoogleFonts.abel(fontSize:14,),textAlign: TextAlign.center,)),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      Center(child: Icon(Icons.home,color: Colors.blue,size: 15,),),
                                      Center(child: Text('Appartement',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                      Center(child: Text(snapshot.data.data()[Shish.clientAppart]==""?'':snapshot.data.data()[Shish.clientAppart],style: GoogleFonts.abel(fontSize:14),)),
                                    ]
                                ),

                              ],
                            );
                          }
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(18),
                  child: FlatButton(
                      color: Colors.green.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      onPressed: (){
                        if(!clicked)
                        {
                          getClientInfosAndPay();
                          clicked=true;
                        }
                        else{
                          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Cette commande est déja validé")));
                        }
                        },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.motorcycle),
                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                          Text('Livreur en route',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                        ],
                      )
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}

