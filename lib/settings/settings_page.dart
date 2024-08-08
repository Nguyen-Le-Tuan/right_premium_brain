import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:right_premium_brain/alert_dialog.dart';
import 'package:right_premium_brain/database.dart';
import 'package:provider/provider.dart';
import 'package:right_premium_brain/auth_service.dart';

import '../app_state.dart';

class Settings extends StatefulWidget {
  final Function setIndex;
  const Settings(this.setIndex, {super.key});
  @override
  _SettingsState createState() => _SettingsState(setIndex);
}

class _SettingsState extends State<Settings> {
  Function setIndex;
  _SettingsState(this.setIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Options",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    EvaIcons.editOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    "Edit Password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    setIndex(5);
                  },
                ),
              ),
              Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    EvaIcons.refreshOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    "Reset Stats",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () async {
                    final action = await Dialogs.yesAbort(
                        context, "Reset Stats", "Are you sure?", "Reset", "No");

                    if (action == DialogAction.yes) {
                      await DatabaseService()
                          .resetStats()
                          .then((value) => {print(value)})
                          .catchError((onError) => {print(onError)});
                    }
                  },
                ),
              ),
              Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    EvaIcons.sunOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    Provider.of<AppState>(context, listen: false).mode,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false).changeTheme();
                    setIndex(0);
                  },
                ),
              ),
              Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    EvaIcons.logOutOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () async {
                    final action = await Dialogs.yesAbort(
                        context, "Logout", "Are you sure?", "Logout", "No");

                    if (action == DialogAction.yes) {
                      context.read<AuthService>().signOut();
                    }
                  },
                ),
              ),
              Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    EvaIcons.personDeleteOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const DeleteAlert();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAlert extends StatefulWidget {
  const DeleteAlert({super.key});

  @override
  _DeleteAlertState createState() => _DeleteAlertState();
}

class _DeleteAlertState extends State<DeleteAlert> {
  bool wrongPassword = false;
  bool _passwordValidate = true;

  final TextEditingController passwordController = TextEditingController();

  Future<bool> checkPassword() async {
    return await context
        .read<AuthService>()
        .checkPassword(passwordController.text);
  }

  void deleteAccount() async {
    setState(() {
      _passwordValidate = (passwordController.text.isEmpty ||
              passwordController.text.length < 6)
          ? false
          : true;
      wrongPassword = false;
    });
    if (_passwordValidate) {
      if (await checkPassword()) {
        await context.read<AuthService>().deleteUser(passwordController.text);
        Navigator.of(context).pop();
      } else {
        setState(() {
          wrongPassword = true;
          _passwordValidate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Account',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: SizedBox(
        height: 75.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              // width: 0,
              child: TextFormField(
                onChanged: (value) {
                  if (value != "") {
                    setState(() {
                      _passwordValidate = true;
                    });
                  }
                },
                controller: passwordController,
                style: TextStyle(
                  color: _passwordValidate
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.onError,
                ),
                cursorColor: Theme.of(context).colorScheme.primaryContainer,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordValidate
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
                      color: _passwordValidate
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  labelText: "Confirm password",
                  labelStyle: TextStyle(
                    color: _passwordValidate
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: wrongPassword ? 24 : 0,
              child: wrongPassword
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Wrong Password",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 12),
                      ),
                    )
                  : null,
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
          onPressed: () {
            Navigator.of(context).pop();
            passwordController.text = "";
            wrongPassword = false;
          },
          label: const Text(
              "Cancel",
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
            deleteAccount();
          },
          label: const Text(
            "Confirm",
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
        ),
      ],
    );
  }
}
