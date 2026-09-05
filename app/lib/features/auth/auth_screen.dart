import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final phoneController = TextEditingController(text: '+52');
  final dio = Dio();

  Future<void> sendOTP() async {
    await dio.post('http://TU_IP:8000/auth/register', data: {'phone': phoneController.text});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP enviado a ${phoneController.text}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JCVTRADUCTOR - Registro')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Número +52')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: sendOTP, child: Text('Enviar código')),
          ],
        ),
      ),
    );
  }
}
