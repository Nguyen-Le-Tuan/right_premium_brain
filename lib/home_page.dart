import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:right_premium_brain/addDeck/add_deck_page.dart';
import 'package:right_premium_brain/overview/edit_deck_page.dart';
import 'package:right_premium_brain/overview/overview_page.dart';
import 'package:right_premium_brain/stats/stats_page.dart';
import 'package:right_premium_brain/settings/edit_user.dart';
import 'package:right_premium_brain/settings/settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:right_premium_brain/gamePage/game.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _selectedIndex = 0;
  late List<Widget> _children;

  late Settings settings;
  late EditUser editUser;
  late AddCard addCard;
  late Overview overview;
  late EditDeck editDeck;
  late GamePage gamePage;
  late StatsPage profile;

  List<int> pages = [];

  @override
  void initState() {
    super.initState();
    settings = Settings(setIndex);
    editUser = EditUser(setIndex);
    addCard = AddCard(setIndex);
    overview = Overview(setIndex);
    editDeck = EditDeck(setIndex);
    gamePage = GamePage(setIndex);
    profile = const StatsPage();

    _children = [
      overview,
      addCard,
      settings,
      profile,
      gamePage,
      editUser,
      editDeck,
    ];
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;

      // _selectedIndex changes which navbar option is bubbled/selected
      // highlight HOME ICON for overview, gamepage, editDeck
      if (index == 0 || index == 6 || index == 4) {
        _selectedIndex = 0;
      } else if (index == 2 || index == 5)
        _selectedIndex = 2;
      // else highlight the icon corresponding to the index
      else
        _selectedIndex = index;

      pages.add(index);
    });
  }

  void backPressed() {
    if (pages.isEmpty) {
      SystemNavigator.pop();
    } else {
      int index = pages.removeLast();
      index = pages.removeLast();
      setIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (shouldPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: _children[_currentIndex],
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          backgroundColor: Colors.transparent,
          height: 50,
          animationDuration: const Duration(milliseconds: 300),
          items: <Widget>[
            Icon(EvaIcons.homeOutline,
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.plusCircleOutline, // I REPLACE plusOutline with plusCircleOutline
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.options2Outline,
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.barChart2Outline,
                color: Theme.of(context).colorScheme.surface, size: 30),
          ],
          onTap: (int index) {
            debugPrint(index.toString());
            setIndex(index);
          },
          index: _selectedIndex,
        ),
      ),
    );
  }
}
