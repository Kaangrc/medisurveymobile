import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 saniye sonra ana sayfaya yönlendir
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/promotion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo veya uygulama adı
            Image.asset('assets/images/logo.png', width: 150),
            SizedBox(height: 20),
            // Yükleniyor göstergesi
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
