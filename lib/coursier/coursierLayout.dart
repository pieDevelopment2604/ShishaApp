import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shish/coursier/bloc/coursierNav.dart';
import 'package:shish/coursier/sidebar.dart';

class CoursierLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CoursierNavBloc>(
        create: (context)=>CoursierNavBloc(),
        child: Stack(
          children: [
            BlocBuilder<CoursierNavBloc,NavStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                }
            ),
            SideBarCoursier(),
          ],
        ),
      ),
    );
  }
}
