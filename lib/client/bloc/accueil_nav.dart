import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/client/accueilClient.dart';
import 'package:shish/client/panier.dart';

import '../historique.dart';
import '../profile.dart';



enum ClientNavEvents{
  AccueilClickedEvent,
  CartClickedEvent,
  ProfileClickedEvent,
  HistoriqueClickedEvent
}

abstract class NavigationStates{}

class ClientNavBloc extends Bloc<ClientNavEvents,NavigationStates>{
  NavigationStates get initialState=> Accueil();

  @override
  Stream<NavigationStates> mapEventToState(ClientNavEvents event) async*{
    switch(event){
      case ClientNavEvents.AccueilClickedEvent: yield Accueil();
      break;
      case ClientNavEvents.CartClickedEvent: yield Cart();
      break;
      case ClientNavEvents.ProfileClickedEvent: yield Profile();
      break;
      case ClientNavEvents.HistoriqueClickedEvent:yield Historique();
      break;

    }
  }
}

