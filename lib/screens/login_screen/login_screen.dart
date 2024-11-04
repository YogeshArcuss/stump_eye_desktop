import 'package:flutter/material.dart';
import 'package:stump_eye/screens/player_screen/player_screen.dart';
import 'package:stump_eye/widgets/gradient_button.dart';
import 'package:stump_eye/widgets/login_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController urlController =
      TextEditingController(text: "rtsp://192.168.1.254/sjcam.mov");

  void onPressLogin(BuildContext context) {
    var url = urlController.text;
    if (url.isEmpty) {
      const snackBar = SnackBar(
          content: Text("Please enter url"), backgroundColor: Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (!_isValidRTSP(url)) {
      const snackBar = SnackBar(
          content: Text("Please enter valid protocol url"),
          backgroundColor: Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayerScreen(
                  url: urlController.text,
                )),
      );
    });
  }

  bool _isValidRTSP(String url) {
    final regex = RegExp(
      r'^rtsp://[a-zA-Z0-9._-]+(:[0-9]{1,5})?(/[a-zA-Z0-9._-]*)?$',
    );
    return regex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/signin_balls.png'),
              const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 30),
              LoginField(
                hintText: 'Enter URL',
                controller: urlController,
              ),
              const SizedBox(height: 30),
              GradientButton(
                isLoading: isLoading,
                onPressed: () => onPressLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
