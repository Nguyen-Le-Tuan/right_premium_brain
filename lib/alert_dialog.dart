import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<Object> yesAbort(BuildContext context, String title,
      String content, String yesText, String noText) async {
    final Future action = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            content: Text(
              content,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(
                  EvaIcons.clockOutline,
                  color: Color(0xff950F0F),
                ),
                onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                label: Text(
                  noText,
                  style: const TextStyle(
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
                onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                label: Text(
                  yesText,
                  style: const TextStyle(
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
              ),
            ],
          );
        });
    return (action != null) ? action : DialogAction.abort;
  }
}
