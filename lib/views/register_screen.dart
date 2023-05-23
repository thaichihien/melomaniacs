import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melomaniacs/utils/utils.dart';
import 'package:melomaniacs/viewmodels/authentication_view_model.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/gradient_text.dart';
import '../components/navigate_guide.dart';
import '../components/textfield.dart';
import '../utils/colors.dart';

class RegsiterScreen extends StatefulWidget {
  const RegsiterScreen({super.key});

  @override
  State<RegsiterScreen> createState() => _RegsiterScreenState();
}

class _RegsiterScreenState extends State<RegsiterScreen> {
  late final AuthViewModel _authViewModel;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _repasswordController;
  Uint8List? _image;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _repasswordController = TextEditingController();
    _authViewModel = context.watch<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
  }

  void selectImage() async {
    var img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    var (success, message) = await _authViewModel.register(
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
        image: _image);

    setState(() {
      _loading = false;
    });

    if (context.mounted) {
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
                      fontSize: 40,
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
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: primaryColor,
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkResponse(
                              onTap: selectImage,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: secondaryColor),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        textEditingController: _emailController,
                        hintText: "Enter your email",
                        type: InputType.email,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          textEditingController: _nameController,
                          hintText: "Enter your username"),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        textEditingController: _passwordController,
                        hintText: "Enter your password",
                        type: InputType.password,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        textEditingController: _repasswordController,
                        hintText: "Re-enter your password",
                        type: InputType.repassword,
                        comparePassword: _passwordController.text,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                LargeButton(
                  buttonText: "REGISTER",
                  onClick: () {
                    register();
                  },
                  loadingState: _loading,
                ),
                NavigateGuide(
                    guide: "Already have an account ?",
                    label: "Login",
                    onClick: () {
                     Navigator.of(context).pop();
                    },
                    alignment: MainAxisAlignment.center)
              ],
            )));
  }
}
