import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/client/accueilClient.dart';
import 'package:shish/coursier/accueilCoursier.dart';
import 'package:shish/coursier/courses.dart';
import 'package:shish/coursier/historique.dart';
import 'package:shish/coursier/profile.dart';

enum CoursierNavEvents{
  AccueilClickedEvent,
  CommandesClickedEvent,
  ProfileClickedEvent,
  HistoryClickedEvent
}

abstract class NavStates{}

class CoursierNavBloc extends Bloc<CoursierNavEvents,NavStates>{
  @override
  NavStates get initialState => AccueilCoursier();

  @override
  Stream<NavStates> mapEventToState(CoursierNavEvents event) async*{
    switch(event){
      case CoursierNavEvents.AccueilClickedEvent:yield AccueilCoursier();
      break;
      case CoursierNavEvents.ProfileClickedEvent: yield Profile();
      break;
      case CoursierNavEvents.CommandesClickedEvent:yield Courses();
      break;
      case CoursierNavEvents.HistoryClickedEvent:yield HistoriqueL();
        break;
    }
  }

}