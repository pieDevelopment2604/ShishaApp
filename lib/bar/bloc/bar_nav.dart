import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/bar/accos.dart';
import 'package:shish/bar/accueilBar.dart';
import 'package:shish/bar/boissons.dart';
import 'package:shish/bar/commandes.dart';
import 'package:shish/bar/gouts.dart';
import 'package:shish/bar/produits.dart';
import 'package:shish/bar/profile.dart';
import 'package:shish/bars.dart';
import 'package:shish/client/accueilClient.dart';
import 'package:shish/client/panier.dart';

import '../supplemnts.dart';

enum BarNavEvents{
  AccueilClickedEvent,
  CommandesClickedEvent,
  ProduitsClickedEvent,
  ProfileClickedEvent,
}
enum OptionsNavEvents{
  GoutClickedEvent,
  BoissonsClickedEvent,
  SupplementClickedEvent,
  AccoClickedEvent
}

abstract class NavStates{}

class BarNavBloc extends Bloc<BarNavEvents,NavStates>{
  NavStates get initialState=> AccueilB();

  @override
  Stream<NavStates> mapEventToState(BarNavEvents event) async*{
    switch(event){
      case BarNavEvents.AccueilClickedEvent: yield AccueilB();
      break;
      case BarNavEvents.CommandesClickedEvent: yield Commandes();
      break;
      case BarNavEvents.ProduitsClickedEvent: yield Produits();
      break;
      case BarNavEvents.ProfileClickedEvent: yield Profile();
      break;
    }
  }
}

class OptionsNavBloc extends Bloc<OptionsNavEvents,NavStates>{
  NavStates get initialState=>GoutsList(gouts: gouts,);

  @override
  Stream<NavStates> mapEventToState(OptionsNavEvents event) async*{
    switch(event){

      case OptionsNavEvents.GoutClickedEvent:
        yield GoutsList(gouts: gouts,);
        break;
      case OptionsNavEvents.BoissonsClickedEvent:
        yield BoissonsList(boissons: boissons,);
        break;
      case OptionsNavEvents.SupplementClickedEvent:
        yield SuppsList(supps: supps,);
        break;
      case OptionsNavEvents.AccoClickedEvent:
        yield AccosList(accos: accos,);
        break;
    }
  }

}