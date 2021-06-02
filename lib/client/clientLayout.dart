import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/client/bloc/accueil_nav.dart';

import 'sidebar.dart';

class ClientLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<ClientNavBloc>(
      create: (context) => ClientNavBloc(),
      child: Stack(
        children: <Widget>[
          BlocBuilder<ClientNavBloc, NavigationStates>(
            builder: (context, navigationState) {
              return navigationState as Widget;
            },
          ),
          SideBarC(),
          // Text('kkkkk')
        ],
      ),
    ));
  }
}
