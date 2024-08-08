import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:right_premium_brain/auth_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  String message = "";
  bool wrongEmail = false;
  bool _emailValidate = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (shouldPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: Center(
          child: Form(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              wrongEmail = false;
                              _emailValidate = true;
                              message = "";
                            });
                          }
                        },
                        controller: emailController,
                        style: TextStyle(
                          color: _emailValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        cursorColor:
                        Theme.of(context).colorScheme.primaryContainer,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _emailValidate
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: _emailValidate
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          labelText: "Enter email",
                          labelStyle: TextStyle(
                            color: _emailValidate
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: wrongEmail ? 24 : 0,
                      child: wrongEmail
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Email does not exist",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      )
                          : null,
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
                        "Send Recovery Mail",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.3),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _emailValidate = (emailController.text.isEmpty ||
                              !EmailValidator.validate(
                                  emailController.text))
                              ? false
                              : true;
                          wrongEmail = false;
                        });
                        if (_emailValidate) {
                          print(emailController.text);
                          String result =
                          await AuthService(FirebaseAuth.instance)
                              .forgotPassword(emailController.text);

                          if (result == "Successful") {
                            setState(() {
                              message = "Email sent successfully";
                            });
                          } else {
                            setState(() {
                              wrongEmail = true;
                              _emailValidate = false;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
