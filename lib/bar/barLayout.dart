
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/client/bloc/accueil_nav.dart';

import 'sidebar.dart';

class BarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<BarNavBloc>(
          create: (context)=>BarNavBloc(),
          child: Stack(
            children: <Widget>[
              BlocBuilder<BarNavBloc,NavStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                },
              ),
              SideBarB(),
            ],
          ),
        )
    );
  }
}
