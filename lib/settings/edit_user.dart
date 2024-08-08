import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../alert_dialog.dart';
import '../auth_service.dart';

class EditUser extends StatefulWidget {
  final Function setIndex;
  const EditUser(this.setIndex, {super.key});
  @override
  _EditUserState createState() => _EditUserState(setIndex);
}

class _EditUserState extends State<EditUser> {
  Function setIndex;
  _EditUserState(this.setIndex);
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool wrongPassword = false;
  bool _newPasswordValidate = true;
  bool _oldPasswordValidate = true;

  Future<bool> checkPassword() async {
    return await context
        .read<AuthService>()
        .checkPassword(oldPasswordController.text);
  }

  void editPassword() async {
    setState(() {
      _oldPasswordValidate = (oldPasswordController.text.isEmpty ||
              oldPasswordController.text.length < 6)
          ? false
          : true;
      _newPasswordValidate = (newPasswordController.text.isEmpty ||
              newPasswordController.text.length < 6)
          ? false
          : true;
      wrongPassword = false;
    });
    if (_newPasswordValidate && _oldPasswordValidate) {
      final action = await Dialogs.yesAbort(
          context, "Edit Password", "Are you sure?", "Edit", "No");
      if (action == DialogAction.yes) {
        if (await checkPassword()) {
          context.read<AuthService>().editPassword(newPasswordController.text);
          // Navigator.popAndPushNamed(context, "/settings");
          setIndex(2);
        } else {
          setState(() {
            wrongPassword = true;
            _oldPasswordValidate = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Edit Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: Center(
          child: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 300,
                child: TextFormField(
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        _oldPasswordValidate = true;
                      });
                    }
                  },
                  controller: oldPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: _oldPasswordValidate
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.onError,
                  ),
                  cursorColor: Theme.of(context).colorScheme.primaryContainer,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _oldPasswordValidate
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
                        color: _oldPasswordValidate
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    labelText: "Enter old password",
                    labelStyle: TextStyle(
                      color: _oldPasswordValidate
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
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: TextFormField(
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        _newPasswordValidate = true;
                      });
                    }
                  },
                  controller: newPasswordController,
                  style: TextStyle(
                    color: _newPasswordValidate
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.onError,
                  ),
                  cursorColor: Theme.of(context).colorScheme.primaryContainer,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _newPasswordValidate
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
                        color: _newPasswordValidate
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    labelText: "Enter password",
                    labelStyle: TextStyle(
                      color: _newPasswordValidate
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                icon: Icon(
                  EvaIcons.checkmark,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                label: Text(
                  "Edit Password",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(30.0), // Set the height
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: editPassword,
              ),

              // RaisedButton(
              //   onPressed: editPassword,
              //   child: Text(
              //     "Edit",
              //     style: TextStyle(
              //         color: Theme.of(context).colorScheme.primaryContainer),
              //   ),
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
