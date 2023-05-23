import 'package:flutter/material.dart';
import 'package:melomaniacs/components/button.dart';
import 'package:melomaniacs/components/gradient_text.dart';
import 'package:melomaniacs/components/navigate_guide.dart';
import 'package:melomaniacs/components/textfield.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/utils/utils.dart';
import 'package:melomaniacs/views/register_screen.dart';
import 'package:provider/provider.dart';

import '../viewmodels/authentication_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthViewModel _authViewModel;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authViewModel = context.watch<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    var (success, message) = await _authViewModel.login(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _loading = false;
    });

    if (context.mounted) {
      if (success) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RegsiterScreen()));
      }

      showSnakeBar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const GradientText(
                "Melodimaniacs",
                gradient:
                    LinearGradient(colors: [primaryColor, secondaryColor]),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                    fontFamily: 'Dancing Script'),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      textEditingController: _emailController,
                      hintText: "Enter your email",
                      type: InputType.email,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      textEditingController: _passwordController,
                      hintText: "Enter your password",
                      type: InputType.password,
                    ),
                    NavigateGuide(
                        guide: "Don't have any account ?",
                        label: "Register",
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegsiterScreen()));
                        },
                        alignment: MainAxisAlignment.start)
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              LargeButton(
                buttonText: "LOGIN",
                onClick: () {
                  login();
                },
                loadingState: _loading,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 16),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
