import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shish/client/magasin.dart';

class Bar {
  String id;
  final String name;
  final double lat;
  final double long;
  final String imgPath;
  double rating;
  int avis;
  List<Chicha> types;

  Bar(this.id,this.name, this.lat, this.long,this.imgPath, this.rating, this.avis, this.types,);
}
class Maga{
  String id;
  final String name;
  final double lat;
  final double long;
  final String imgPath;
  double rating;
  int avis;
  List<Produit> produits;

  Maga(this.id,this.name, this.lat, this.long, this.imgPath,this.rating, this.avis, this.produits,);
}
enum TypesChicha{
  Basic,
  Kaloud,
  Brohood
}
enum TypeGout{
  Menthe,
  Hawai,
  Love66,
  MiAmor,
}
class Gout{
  final TypeGout gout;

  Gout(this.gout,);
}
class Boiss{
  final TypeBoisson boisson;
  final double prix;
  Boiss(this.boisson, this.prix);
}
enum TypeAcco{
  Glaces,
  Bonbons,
  Chips,
  FruitsSecs,
}
class Acco{
  final TypeAcco acco;
  final double prix;

  Acco(this.acco, this.prix);
}
enum TypeSupplement{
  tetedechicha,
  charbon,
}
class Supp{
  final TypeSupplement supplement;
  final double prix;

  Supp(this.supplement, this.prix);
}


final bars=[
  Bar(null,"Chicha one",35.422519,7.148255,'assets/1.jpg',3.0,120,chichas1),
  Bar(null,"Chicha Gougou", 35.427590, 7.145989,'assets/2.jpg',4.5,353,chichas1)
];


class Chicha{
  final TypesChicha type;
  final String imgPath;
  final int prix;

  Chicha(this.type, this.imgPath, this.prix);
}
final chichas1=[
  Chicha(TypesChicha.Basic, 'assets/basic.png',10),
  Chicha(TypesChicha.Kaloud, 'assets/kaloud.png',15),
  Chicha(TypesChicha.Brohood,'assets/brohood.png',20)
];
class Commande{
  String id;
  String bar;
  Chicha chicha;
  Gout gout;
  Boiss boiss;
  Acco accompagnement;
  Supp supplement;

  Commande(this.id,this.chicha,this.gout,this.boiss,this.accompagnement,this.supplement,this.bar);
}

class ProdCmd{
  String id;
  final Maga magasin;
  final Produit produit;
  final int quantite;
  ProdCmd(this.id,this.magasin, this.produit, this.quantite);
}

List<ProdCmd> prodcmd=[
];
List<ProdCmd> mesprodcmd=[
];

final gouts=[
  Gout(TypeGout.Menthe,),
  Gout(TypeGout.Hawai,),
  Gout(TypeGout.Love66,),
  Gout(TypeGout.MiAmor,),
];

enum TypeBoisson{
  CocaCola,
  Oasis,
  Fanta
}
final List<Commande> cart=[
];
final List<ProdCmd> cartProd=[];

List<Commande> historique=[

];
List<Commande> commandes=[

];
List<Commande> mesCmd=[];

class Option{
  final int id;
  final String option;

  Option(this.id, this.option);
}
List<Option> options=[Option(0, "Gouts"),Option(1, "Boissons"),Option(2, "Supplements"),Option(3, "Accompagnements")];

final boissons=[
  Boiss(TypeBoisson.CocaCola, 8),
  Boiss(TypeBoisson.Oasis, 8),
  Boiss(TypeBoisson.Fanta, 8),
];
final supps=[
  Supp(TypeSupplement.charbon, 2),
  Supp(TypeSupplement.tetedechicha, 3)
];
final accos=[
  Acco(TypeAcco.Glaces, 0.5),
  Acco(TypeAcco.Bonbons, 3.5),
  Acco(TypeAcco.Chips, 6),
  Acco(TypeAcco.FruitsSecs, 4),
];

class Course{
  String id;
  final Position posClient;
  final Bar bar;

  Course(this.id,this.posClient, this.bar,);
}
var courses=[
  Course(null,Position(latitude: 35.43819137224004,longitude: 7.129227241260489), bars[0]),
  Course(null,Position(latitude: 35.439523805781704,longitude: 7.137342894554347), bars[0]),
  Course(null,Position(latitude: 35.43930279898714,longitude: 7.144538804349775), bars[0]),
  Course(null,Position(latitude: 35.44365320644515 ,longitude:7.139225338926122), bars[0]),
];
enum TypeProduit{
  Charbon,
  TeteDeChicha
}
class Produit{
  final id;
  final TypeProduit type;
  final String name;
  final double prix;
  final String imagePath ;

  Produit(this.id,this.type, this.name, this.prix, this.imagePath);
}

List<Produit> produits=[
  Produit(null,TypeProduit.Charbon, "Tom Cococha 3 Blocks", 7.00,"assets/tom-cococha.png"),
  Produit(null,TypeProduit.Charbon, "Tom Coco Premium Gold", 7.00,"assets/gold.png"),
  Produit(null,TypeProduit.Charbon, "Three kings 33mm ", 9.00,"assets/three.png"),
  Produit(null,TypeProduit.Charbon, "Al Fakher 33mm", 7.00,"assets/fakher.png"),
  Produit(null,TypeProduit.TeteDeChicha, "Silicone 3 Séparation", 16.00,"assets/silicone.png"),
  Produit(null,TypeProduit.TeteDeChicha, "Tobacco Bowl", 10.79,"assets/bowl.png"),
  Produit(null,TypeProduit.TeteDeChicha, "Silicone Mélasse Coloré", 22.49,"assets/melasse.png"),
  Produit(null,TypeProduit.Charbon, "Fast coco", 9.90,"assets/fast.png"),

];

List<Maga> magasins=[
  Maga(null,"Magasin Youssouf",48.86307769849079, 2.3476023807284347,"assets/badia.jpg",4,0,produits),
  Maga(null,"TS - store",48.6198671455057, 2.4706838424505437,"assets/ts.png",4,0,produits)
];

class Comm{
  final DocumentSnapshot bar;
  QueryDocumentSnapshot gout;
  QueryDocumentSnapshot boisson;
  QueryDocumentSnapshot supp;
  QueryDocumentSnapshot acco;
  final QueryDocumentSnapshot chicha;
  final double distance;

  Comm(this.bar, this.gout, this.boisson, this.supp, this.acco, this.chicha, this.distance);
}
List<Comm> panier=[];

List<Comm> history=[];

class MagComm{
  final DocumentSnapshot magasin;
  QueryDocumentSnapshot produit;
  final double distance;
  MagComm(this.magasin,this.produit, this.distance);
}
List<MagComm> magPanier=[];