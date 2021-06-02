import 'dart:async';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shish/bar/bloc/bar_nav.dart';
import 'package:shish/bars.dart';
import 'package:shish/client/bloc/accueil_nav.dart';
import 'package:shish/config.dart';
import 'package:shish/login.dart';
import 'package:shish/main.dart';
import 'package:shish/menuItem.dart';
import 'package:shish/users_accueil.dart';

import '../utils.dart';
import 'bloc/magasin_bloc_nav.dart';

class SideBarM extends StatefulWidget {
  @override
  _SideBarMState createState() => _SideBarMState();
}

class _SideBarMState extends State<SideBarM>
    with SingleTickerProviderStateMixin<SideBarM> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSidebarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpenedAsync.data ? 0 : -screenWidth,
          right: isSidebarOpenedAsync.data ? 0 : screenWidth - 40,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("magasins/" +
                      Shish.sharedPreferences.getString(Shish.magasinUID) +
                      "/commandes")
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: Text("..."),
                      )
                    : Row(
                        children: <Widget>[
                          Expanded(
                            child: BackdropFilter(
                              filter: isSidebarOpenedAsync.data
                                  ? ImageFilter.blur(sigmaY: 10, sigmaX: 10)
                                  : ImageFilter.blur(sigmaY: 0, sigmaX: 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.blue,
                                height: MediaQuery.of(context).size.height,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                      ),
                                      ListTile(
                                        title: Text(
                                          Shish.sharedPreferences
                                                      .get(Shish.magasinName) ==
                                                  null
                                              ? ''
                                              : Shish.sharedPreferences
                                                  .get(Shish.magasinName),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        subtitle: Text(
                                          Shish.sharedPreferences.get(
                                                      Shish.magasinEmail) ==
                                                  null
                                              ? ''
                                              : Shish.sharedPreferences
                                                  .get(Shish.magasinEmail),
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withAlpha(100),
                                              fontSize: 15),
                                        ),
                                        leading: CircleAvatar(
                                          child: Icon(
                                            Icons.perm_identity,
                                            color: Colors.white,
                                          ),
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("magasins")
                                              .doc(Shish.sharedPreferences
                                                  .getString(Shish.magasinUID))
                                              .snapshots(),
                                          builder: (context, datasnapshot) {
                                            return !datasnapshot.hasData
                                                ? Center(
                                                    child: Text('-'),
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        "Balance",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        datasnapshot.data
                                                                .data()[Shish
                                                                    .magasinBalance]
                                                                .toString() +
                                                            " €",
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withAlpha(150),
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                  );
                                          }),
                                      Divider(
                                        height: 64,
                                        thickness: 0.5,
                                        color: Colors.black.withOpacity(0.5),
                                        indent: 32,
                                        endIndent: 32,
                                      ),
                                      MenuItem(
                                        icon: Icons.home,
                                        title: "Accueil",
                                        onTap: () {
                                          onIconPressed();
                                          BlocProvider.of<MagasinNavBloc>(
                                                  context)
                                              .add(MagasinNavEvents
                                                  .AccueilClickedEvent);
                                        },
                                      ),
                                      snapshot.data.docs.length == 0
                                          ? MenuItem(
                                              icon: Icons.notifications_active,
                                              title: "Commandes",
                                              onTap: () {
                                                onIconPressed();
                                                BlocProvider.of<MagasinNavBloc>(
                                                        context)
                                                    .add(MagasinNavEvents
                                                        .CommandesClickedEvent);
                                              },
                                            )
                                          : Badge(
                                              badgeContent: Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              position: BadgePosition.topEnd(
                                                  top: 20, end: 0),
                                              child: MenuItem(
                                                icon:
                                                    Icons.notifications_active,
                                                title: "Commandes",
                                                onTap: () {
                                                  onIconPressed();
                                                  BlocProvider.of<
                                                              MagasinNavBloc>(
                                                          context)
                                                      .add(MagasinNavEvents
                                                          .CommandesClickedEvent);
                                                },
                                              ),
                                            ),
                                      MenuItem(
                                        icon: Icons.apps,
                                        title: "Produits",
                                        onTap: () {
                                          onIconPressed();
                                          BlocProvider.of<MagasinNavBloc>(
                                                  context)
                                              .add(MagasinNavEvents
                                                  .ProduitsClickedEvent);
                                        },
                                      ),
                                      Divider(
                                        height: 64,
                                        thickness: 0.5,
                                        color: Colors.black.withOpacity(0.5),
                                        indent: 32,
                                        endIndent: 32,
                                      ),
                                      MenuItem(
                                        icon: Icons.settings,
                                        title: "Profil",
                                        onTap: () {
                                          onIconPressed();
                                          BlocProvider.of<MagasinNavBloc>(
                                                  context)
                                              .add(MagasinNavEvents
                                                  .ProfileClickedEvent);
                                        },
                                      ),
                                      MenuItem(
                                        icon: FontAwesomeIcons.userShield,
                                        title: "Confidentialité",
                                        onTap: () {
                                          onIconPressed();

                                          Utils.showLicenseDialog(context);

                                        },
                                      ),
                                      MenuItem(
                                        icon: Icons.support,
                                        title: "Support",
                                        onTap: () {
                                          onIconPressed();

                                          Utils.openEmail(
                                              toEmail: 'Sasshish2020@gmail.com',
                                              subject: 'Votre sujet',
                                              body:
                                              'Plus de détails ici + photo S.V.P');
                                        },
                                      ),
                                      MenuItem(
                                          icon: Icons.exit_to_app,
                                          title: "Se déconnecter",
                                          onTap: () async {
                                            await Shish.auth
                                                .signOut()
                                                .then((value) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccueilC()));
                                              preferences.setBool(
                                                  'loginStatus', false);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, -0.9),
                            child: GestureDetector(
                              onTap: () {
                                onIconPressed();
                              },
                              child: ClipPath(
                                clipper: CustomMenuClipper(),
                                child: Container(
                                    width: 35,
                                    height: 120,
                                    color: Colors.blue,
                                    alignment: Alignment.centerLeft,
                                    child: snapshot.data.docs.length == 0
                                        ? AnimatedIcon(
                                            progress: _animationController.view,
                                            icon: AnimatedIcons.menu_close,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        : Badge(
                                            position: BadgePosition.topEnd(
                                                top: 0, end: 0),
                                            elevation: 8,
                                            badgeContent: null,
                                            child: AnimatedIcon(
                                              progress:
                                                  _animationController.view,
                                              icon: AnimatedIcons.menu_close,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          )),
                              ),
                            ),
                          )
                        ],
                      );
              }),
        );
      },
    );
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationComplete = animationStatus == AnimationStatus.completed;
    if (isAnimationComplete) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
