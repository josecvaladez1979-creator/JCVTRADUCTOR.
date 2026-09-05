import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/encryption/signal_protocol.dart';
import 'core/webrtc/webrtc_service.dart';
import 'core/translation/translation_service.dart';
import 'features/auth/auth_screen.dart';
import 'features/chats/chats_screen.dart';
import 'features/calls/call_manager.dart';
import 'features/billing/billing_service.dart';

// Instancias globales reales
final secureStorage = FlutterSecureStorage();
final signalProtocol = SignalProtocol();
final webrtcService = WebRTCService();
final translationService = TranslationService();
final billingService = BillingService();
final callManager = CallManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializar cifrado libsignal real
  await signalProtocol.initIdentity();
  
  // 2. Inicializar WebRTC
  await webrtcService.init();
  
  // 3. Inicializar motores de traducción
  await translationService.init();

  runApp(JCVTRADUCTOR());
}

class JCVTRADUCTOR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JCV TRADUCTOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF00FF88),
        scaffoldBackgroundColor: Color(0xFF0A0E1A),
      ),
      // Verifica si ya esta logeado con +52
      home: FutureBuilder<String?>(
        future: secureStorage.read(key: 'session_token'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data != null) {
            return ChatsScreen(); // Ya logueado
          }
          return AuthScreen(); // Registro por numero +52
        },
      ),
      routes: {
        '/auth': (context) => AuthScreen(),
        '/chats': (context) => ChatsScreen(),
        '/calls': (context) => CallManagerScreen(),
      },
    );
  }
}

class CallManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Llamadas y Video JCV')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => callManager.startVoiceCall('+521...'),
              child: Text('Llamada de Voz WebRTC'),
            ),
            ElevatedButton(
              onPressed: () => callManager.startVideoCall('+521...'),
              child: Text('Video Llamada WebRTC'),
            ),
            ElevatedButton(
              onPressed: () => billingService.payWithStripe(99.0),
              child: Text('Pagar con Stripe'),
            ),
          ],
        ),
      ),
    );
  }
}
