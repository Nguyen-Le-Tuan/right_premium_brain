import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:right_premium_brain/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class SignInPage extends StatefulWidget {
  final Function toggle;
  const SignInPage(this.toggle, {super.key});

  @override
  _SignInPageState createState() => _SignInPageState(toggle);
}

class _SignInPageState extends State<SignInPage> {
  Function toggle;
  _SignInPageState(this.toggle);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool wrongEmail = false;
  bool wrongPassword = false;
  bool _emailValidate = true;
  bool _passwordValidate = true;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
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
                        if (value != "") {
                          setState(() {
                            _emailValidate = true;
                            wrongPassword = false;
                            wrongEmail = false;
                          });
                        }
                      },
                      controller: emailController,
                      style: TextStyle(
                        color: _emailValidate
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primaryContainer,
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
                          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
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
                              "Email doesnot exist",
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
                            _passwordValidate = true;
                            wrongPassword = false;
                            wrongEmail = false;
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0),
                        labelText: "Enter Password",
                        labelStyle: TextStyle(
                          color: _passwordValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: wrongPassword ? 30 : 0,
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
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/forgotPassword");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(
                      EvaIcons.checkmark,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    label: Text(
                      "Sign In",
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
                                !EmailValidator.validate(emailController.text))
                            ? false
                            : true;
                        _passwordValidate = (passwordController.text.isEmpty ||
                                passwordController.text.length < 6)
                            ? false
                            : true;
                        wrongEmail = wrongPassword = false;
                      });
                      if (_emailValidate && _passwordValidate) {
                        String result =
                            await context.read<AuthService>().signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                        if (result == "user-not-found") {
                          setState(() {
                            wrongEmail = true;
                            _emailValidate = false;
                          });
                        } else if (result == "wrong-password") {
                          setState(() {
                            wrongPassword = true;
                            _passwordValidate = false;
                          });
                        }
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: const Text("Create an account"),
                        onPressed: () {
                          toggle();
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
