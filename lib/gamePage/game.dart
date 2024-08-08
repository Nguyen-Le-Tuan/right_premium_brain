import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:right_premium_brain/database.dart';
import 'package:right_premium_brain/overview/deck_list.dart';
import 'package:confetti/confetti.dart';

class GamePage extends StatefulWidget {
  final Function setIndex;
  const GamePage(this.setIndex, {super.key});
  @override
  _GamePageState createState() => _GamePageState(setIndex);
}

class _GamePageState extends State<GamePage> {
  List<Widget> cardos = [];
  int index = 0;
  late String deckid;
  bool ansVisible = false;

  List<dynamic> flashcards = [];
  int totCards = 0;

  late final ConfettiController _confettiController;

  Function setIndex;
  _GamePageState(this.setIndex) : _confettiController = ConfettiController(duration: const Duration(seconds: 10));

  int loop = 0; // loop type
  int nextType = 1; // normal: 0 insane: 1 hard: 2 moderate: 3
  int normal = 0;

  bool gameOver = false;

  List answeredCards = [];

  // check if already answered
  bool answered(String id) {
    if (!answeredCards.contains(id)) return false;
    return true;
  }

  void switchCard() {
    if (index < totCards - 1) {
      toggleAnswer(hideAnswer: 0);
    }
  }

  int? next(int level) {
    for (int i = index + 1; i < (flashcards.length + index); i++) {
      if (flashcards[i % flashcards.length]['score'] == level) {
        return (i % flashcards.length);
      }
    }
    return null;
  }

  void nextIndex() {
    if (kDebugMode) {
      print(answeredCards);
    }
    int? tempIndex;
    while (tempIndex == null) {
      if (nextType == 0 &&
          (flashcards[(normal + 1) % flashcards.length]['score'] == 4 &&
              answered(flashcards[(normal + 1) % flashcards.length]['cardId']))) {
        normal = (normal + 1) % flashcards.length;
        continue;
      }
      if (loop == 0) {
        print("Currently in loop 0");
        if (nextType == 1) {
          tempIndex = next(1);
          print("Next insane at");
          print(tempIndex);
          nextType = 0;
        } else {
          tempIndex = (normal + 1) % flashcards.length;
          normal = tempIndex;
          loop = 1;
          print("Next normal at");
          print(tempIndex);
        }
      } else if (loop == 1) {
        print("Currently in loop 1");
        if (nextType == 0) {
          tempIndex = (normal + 1) % flashcards.length;
          normal = tempIndex;
          print("Next normal at");
          print(tempIndex);
          nextType = 1;
        } else if (nextType == 1) {
          tempIndex = next(1);
          nextType = 2;
          print("Next insane at");
          print(tempIndex);
        } else {
          tempIndex = next(2);
          nextType = 0;
          loop = 2;
          print("Next hard at");
          print(tempIndex);
        }
      } else if (loop == 2) {
        print("Currently in loop 2");
        if (nextType == 0) {
          tempIndex = (normal + 1) % flashcards.length;
          normal = tempIndex;
          nextType = 1;
          print("Next normal at");
          print(tempIndex);
        } else if (nextType == 1) {
          tempIndex = next(1);
          print("Next insane at");
          print(tempIndex);
          nextType = 2;
        } else if (nextType == 2) {
          tempIndex = next(2);
          nextType = 3;
          print("Next hard at");
          print(tempIndex);
        } else {
          tempIndex = next(3);
          nextType = 0;
          print("Next moderate at");
          print(tempIndex);
        }
        loop = 0;
      }
    }

    print("Score");
    print(flashcards[tempIndex]['score']);

    setState(() {
      if (!mounted) return;
      index = tempIndex!;
    });
  }

  bool gameOverCheck() {
    for (int i = 0; i < flashcards.length; i++) {
      if (flashcards[i]['score'] != 4) {
        return false;
      }
    }
    return true;
  }

  void updateScore(int i, int diff) async {
    if (!answered(flashcards[i]['cardId'])) {
      answeredCards.add(flashcards[i]['cardId']);
    }

    flashcards[i]["score"] = diff;

    await DatabaseService().updateScore(flashcards[i]["cardId"], diff);

    if (gameOverCheck() && (answeredCards.length == flashcards.length)) {
      setState(() {
        gameOver = true;
        _confettiController.play();
      });
      print("over");
    } else {
      nextIndex();
    }
  }

  void toggleAnswer({required int hideAnswer}) {
    setState(() {
      if (hideAnswer == 1) {
        ansVisible = true;
      } else {
        ansVisible = false;
      }
        });
  }

  void resetDeck() async {
    DatabaseService().resetDeck(deckid);
    flashcards = await DatabaseService().getCardDetails(deckid);
    setState(() {
      gameOver = false;
    });
    print("reset deck");
  }

  @override
  void initState() {
    super.initState();
    deckid = DeckListState.deckid!;
    print('deckid: $deckid');
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "Game",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        body: gameOver
            ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: const Text(
                  "🎉 Yay! You have completed this deck!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.pink, backgroundColor: Colors.pink.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: resetDeck,
                    child: const Text("Reset Deck"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primaryContainer, backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text("Go Back"),
                    onPressed: () {
                      setIndex(0);
                    },
                  ),
                ],
              ),
            ],
          ),
        )
            : Container(
          child: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: FutureBuilder(
                      future: DatabaseService().getCardDetails(deckid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          flashcards = snapshot.data!;
                          totCards = flashcards.length;
                          print(flashcards);
                          print('Total Cards: $totCards');
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                            child: InkWell(
                              onTap: () {
                                toggleAnswer(hideAnswer: 0);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                color:
                                Theme.of(context).colorScheme.surface,
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Q. " +
                                            flashcards[index]["front"],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text(
                                        ansVisible
                                            ? "A. " +
                                            flashcards[index]["back"]
                                            : "Tap to view the answer",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(children: [
                              Icon(
                                EvaIcons.alertTriangleOutline,
                                color:
                                Theme.of(context).colorScheme.onError,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text('Error: ${snapshot.error}'),
                              )
                            ]),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Rate difficulty:",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red, backgroundColor: Colors.red.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text("Insane"),
                          onPressed: () {
                            debugPrint("Insane");
                            updateScore(index, 1);
                            switchCard();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange, backgroundColor: Colors.orange.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text("Hard"),
                          onPressed: () {
                            debugPrint("Hard");
                            updateScore(index, 2);
                            switchCard();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.yellow[700], backgroundColor: Colors.yellow.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text("Moderate"),
                          onPressed: () {
                            debugPrint("Moderate");
                            updateScore(index, 3);
                            switchCard();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green, backgroundColor: Colors.green.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text("Easy"),
                          onPressed: () {
                            debugPrint("Easy");
                            updateScore(index, 4);
                            switchCard();
                          },
                        ),
                      ],
                    )

                  ],
                ),
              )
            ],
          ),
        ));
  }
}
