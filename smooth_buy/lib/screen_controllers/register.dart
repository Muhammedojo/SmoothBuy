
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_buy/screen_controllers/checkout_controller.dart';
import '../screen_views/register.dart';
import '../utils/auth.dart';
import '../utils/helper.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  //... //Initialization code, state vars etc, all go here

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Helper().showBasicSnackBar(context, 'Password does not match');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
 if (!mounted) return;
      Navigator.of(context).pop();

      if (userCredential.user != null) {
        Helper().showBasicSnackBar(context, 'Registration successful');

        completeLogin();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      switch (e.code) {
        case 'email-already-in-use':
          Helper().showBasicSnackBar(context, 'Email is already in use');
          break;
        case 'weak-password':
          Helper().showBasicSnackBar(context, 'Password is too weak');
          break;
        case 'invalid-email':
          Helper().showBasicSnackBar(context, 'Email is invalid');
          break;
        default:
          Helper().showBasicSnackBar(
            context,
            e.message ?? 'Registration failed',
          );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        Helper().showBasicSnackBar(context, 'An error occurred: $e');
      }
    }
  }

togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
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
  Widget build(BuildContext context) => RegisterView(this);
}
