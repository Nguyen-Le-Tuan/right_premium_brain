import 'package:flutter/material.dart';
import 'package:right_premium_brain/overview/deck_list.dart';

class Overview extends StatefulWidget {
  final Function setIndex;
  const Overview(this.setIndex, {super.key});
  @override
  _OverviewState createState() => _OverviewState(setIndex);
}

class _OverviewState extends State<Overview> {
  Function setIndex;
  _OverviewState(this.setIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Your Decks",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: DeckList(setIndex),
    );
  }
}
