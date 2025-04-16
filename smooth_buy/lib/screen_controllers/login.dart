import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_buy/screen_controllers/checkout_controller.dart';
import '../screen_views/login.dart';
import '../utils/auth.dart';
import '../utils/helper.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  //... //Initialization code, state vars etc, all go here

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  String? errorMessage = '';
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential = await Auth().signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();

      if (userCredential.user != null) {
        Helper().showBasicSnackBar(context, 'Login successful');

        completeLogin();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      switch (e.code) {
        case 'user-not-found':
          Helper().showBasicSnackBar(context, 'No user found with this email');
          break;
        case 'wrong-password':
          Helper().showBasicSnackBar(context, 'Incorrect password');
          break;
        case 'invalid-email':
          Helper().showBasicSnackBar(context, 'Email is invalid');
          break;
        case 'user-disabled':
          Helper().showBasicSnackBar(context, 'This account has been disabled');
          break;
        case 'too-many-requests':
          Helper().showBasicSnackBar(
            context,
            'Too many attempts. Try again later',
          );
          break;
        default:
          Helper().showBasicSnackBar(context, e.message ?? 'Login failed');
      }
    } catch (e) {
      Navigator.of(context).pop();

      Helper().showBasicSnackBar(context, 'An error occurred: $e');
    }
  }

  void completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Checkout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LoginView(this);
}
