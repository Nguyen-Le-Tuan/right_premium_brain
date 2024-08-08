import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../database.dart';

class EditCard extends StatefulWidget {
  String front;
  String back;
  String cardId;
  String deckid;
  Function updateCardList;

  EditCard(
      this.front, this.back, this.cardId, this.deckid, this.updateCardList, {super.key});

  @override
  _EditCardState createState() => _EditCardState(
      front, back, cardId, deckid, updateCardList);
}

class _EditCardState extends State<EditCard> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();

  bool _frontValidate = true;
  bool _backValidate = true;

  String front;
  String back;
  String cardId;
  String deckid;
  Function updateCardList;

  _EditCardState(
      this.front, this.back, this.cardId, this.deckid, this.updateCardList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frontController.text = front;
    backController.text = back;
  }

  void editCard() async {
    _frontValidate = frontController.text.isEmpty ? false : true;
    _backValidate = backController.text.isEmpty ? false : true;

    if (_frontValidate && _backValidate) {
      await DatabaseService()
          .editCard(frontController.text, backController.text, cardId, deckid)
          .then((value) {
        print(value);
        updateCardList();
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Card',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: SizedBox(
        height: 170.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 230.0,
                  height: 60.0,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value != "") {
                        setState(() {
                          _frontValidate = true;
                        });
                      }
                    },
                    maxLines: 2,
                    controller: frontController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primaryContainer,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _frontValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: _frontValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      labelText: "Front",
                      labelStyle: TextStyle(
                        color: _frontValidate
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 230.0,
                  height: 60.0,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value != "") {
                        setState(() {
                          _backValidate = true;
                        });
                      }
                    },
                    maxLines: 2,
                    controller: backController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primaryContainer,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _backValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: _backValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      labelText: "Back",
                      labelStyle: TextStyle(
                        color: _backValidate
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
          TextButton.icon(
          icon: const Icon(
            EvaIcons.clockOutline,
            color: Color(0xff950F0F),
          ),
        onPressed: () => Navigator.of(context).pop(),
          label: const Text(
            "No",
            style: TextStyle(
              color: Color(0xff950F0F),
            ),
          ),
          style: TextButton.styleFrom(
              padding: const EdgeInsets.all(8.0),
              backgroundColor: const Color(0xffEDA9A9),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            EvaIcons.checkmark,
            color: Color(0xff08913F),
          ),
          onPressed: () {
            setState(() {
              _frontValidate = frontController.text.isEmpty ? false : true;
              _backValidate = backController.text.isEmpty ? false : true;

              // updateCardList();
            });
            if (_frontValidate && _backValidate) {
              editCard();
              Navigator.of(context).pop();
            }
          },
          label: const Text(
            "Edit",
            style: TextStyle(
              color: Color(0xff08913F),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffA9EDC4),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        )
      ],
    );
  }
}
