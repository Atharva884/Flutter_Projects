import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/widgets/user_image.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  var _isLogin = true;
  var _isAuthenticating = false;
  File? selectedImage;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void _saveCredentials() async {
    if (_form.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final username = _usernameController.text;

      try {
        setState(() {
          _isAuthenticating = true;
        });
        if (_isLogin) {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
              email: email, password: password);
          print(userCredentials);
        } else {
          final userCredentials = await _firebase
              .createUserWithEmailAndPassword(email: email, password: password);
          final storageRef = FirebaseStorage.instance
              .ref()
              .child("user_images")
              .child("${userCredentials.user!.uid}.jpg");

          await storageRef.putFile(selectedImage!);
          final url = await storageRef.getDownloadURL();

          // Storing data in Firebase -> Firestore Database
          await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
            "email": email,
            "image_url": url,
            "username": username,
          });
          
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication failed"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      "https://img.freepik.com/free-photo/fashion-boy-with-yellow-jacket-blue-pants_71767-96.jpg?w=826&t=st=1688799254~exp=1688799854~hmac=4b283fb984ba747e73c71515fea88649c8410d5b16256043b519a6b12bdefb0b",
                  fit: BoxFit.cover,
                  width: 200,
                  fadeInCurve: Curves.easeInOut,
                ),
              ),
              Card(
                margin: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        if (!_isLogin)
                          UserImage(
                            onPickedImage: (pickedImage) {
                              selectedImage = pickedImage;
                            },
                          ),
                        if (!_isLogin)
                          TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 4) {
                                return "Username must be 4 characters long";
                              }
                              return null;
                            },
                          ),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return "Please Enter a valid Email Address";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 6) {
                              return "Password must be 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: _saveCredentials,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: _isAuthenticating
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  _isLogin ? "Login" : "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                        ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? "Create an Account"
                                  : "I already have an account",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
