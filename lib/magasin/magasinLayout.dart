import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/magasin/sidebar.dart';
import 'bloc/magasin_bloc_nav.dart';

class MagasinLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MagasinNavBloc>(
        create: (context)=>MagasinNavBloc(),
        child: Stack(
          children: [
            BlocBuilder<MagasinNavBloc,NaviStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                }
            ),
            SideBarM(),
          ],
        ),
      ),
    );
  }
}

