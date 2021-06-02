import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/magasin/accueilMagasin.dart';
import 'package:shish/magasin/commandes.dart';
import 'package:shish/magasin/produits.dart';
import 'package:shish/magasin/profil.dart';

enum MagasinNavEvents{
  AccueilClickedEvent,
  CommandesClickedEvent,
  ProduitsClickedEvent,
  ProfileClickedEvent,
}

abstract class NaviStates{}

class MagasinNavBloc extends Bloc<MagasinNavEvents,NaviStates>{
  @override
  NaviStates get initialState => AccueilMagasin();

  @override
  Stream<NaviStates> mapEventToState(MagasinNavEvents event) async*{
    switch(event){
      case MagasinNavEvents.AccueilClickedEvent:yield AccueilMagasin();
      break;

      case MagasinNavEvents.CommandesClickedEvent:
        yield CommandesProd();
        break;
      case MagasinNavEvents.ProduitsClickedEvent:
        yield ProduitsMaga();
        break;
      case MagasinNavEvents.ProfileClickedEvent:
        yield Profile();
        break;
    }
  }

}