import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Shish {
  static const String appName = 'Shish';
  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";

  static String subCollectionAddress = 'userAddress';
  static String shishCurrentUser = "currentUser";

  //clients
  static final String clientName = 'clientName';
  static final String clientEmail = 'clientEmail';
  static final String clientPhotoUrl = 'clientPhotoUrl';
  static final String clientUID = 'clientUID';
  static final String clientPhone = 'clientPhone';
  static final String clientDate = 'clientDate';
  static final String clientAppart = 'clientAppart';
  static final String clientLatitude = 'clientLatitude';
  static final String clientLongitude = 'clientLongitude';
  static final String clientCardExpiry = 'clientCardExpiry';
  static final String clientCardCVV = 'clientCardCVV';
  static String clientCardList = 'clientCard';

  //bars
  static final String barName = 'barName';
  static final String barEmail = 'barEmail';
  static final String barPhotoUrl = 'barPhotoUrl';
  static final String barUID = 'barUID';
  static final String barLongitude = 'barLong';
  static final String barLatitude = 'barLat';
  static final String barPhone = 'barPhone';
  static final String barRating = 'barRating';
  static final String barRatingCount = 'barRatingCount';
  static final String barBalance = 'barBalance';
  static String barCardList = 'barCard';
  static final String barAutorise = 'barAutorise';
  static final String barOuvert = "barOuvert";

  static String barChichas = 'barChichas';
  static String barGouts = 'barGouts';
  static String barSupps = 'barSupp';
  static String barBoissons = 'barBoissons';
  static String barAccos = 'barAccos';

  //magasins
  static final String magasinName = 'magasinName';
  static final String magasinEmail = 'magasinEmail';
  static final String magasinPhotoUrl = 'magasinPhotoUrl';
  static final String magasinUID = 'magasinUID';
  static final String magasinPhone = 'magasinPhone';
  static final String magasinLongitude = 'magasinLongitude';
  static final String magasinLatitude = 'magasinLatitude';
  static final String magasinRating = 'magasinRating';
  static final String magasinRatingCount = 'magasinRatingCount';
  static final String magasinBalance = 'magasinBalance';
  static final String magasinAutorise = 'magasinAutorise';
  static String magasinCardList = 'magasinCard';
  static final String magasinOuvert = "magasinOuvert";

  //livreurs
  static final String livreurName = 'livreurName';
  static final String livreurEmail = 'livreurEmail';
  static final String livreurPhotoUrl = 'livreurPhotoUrl';
  static final String livreurUID = 'livreurUID';
  static final String livreurPhone = 'livreurPhone';
  static final String livreurLatitude = 'livreurLatitude';
  static final String livreurLongitude = 'livreurLongitude';
  static final String livreurRating = 'livreurRating';
  static final String livreurRatingCount = 'livreurRatingCount';
  static final String livreurBalance = 'livreurBalance';
  static final String livreurAutorise = 'livreurAutorise';
  static final String livreurCouleur = 'livreurCouleur';
  static final String livreurType = 'livreurType';
  static final String livreurImageUrl = 'livreurImageUrl';
  static String livreurCard = 'livreurCard';
}
