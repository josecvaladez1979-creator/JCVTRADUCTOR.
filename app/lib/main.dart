import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/encryption/signal_protocol.dart';
import 'core/webrtc/webrtc_service.dart';
import 'core/translation/translation_service.dart';
import 'features/auth/auth_screen.dart';
import 'features/chats/chats_screen.dart';
import 'features/calls/call_manager.dart';
import 'services/payment_service.dart';
import 'models/subscription_tiers.dart';

// Instancias globales reales
final secureStorage = FlutterSecureStorage();
final signalProtocol = SignalProtocol();
final webrtcService = WebRTCService();
final translationService = TranslationService();
final callManager = CallManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await signalProtocol.initIdentity();
  await webrtcService.init();
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
      home: FutureBuilder<String?>(
        future: secureStorage.read(key: 'session_token'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data != null) {
            return ChatsScreen();
          }
          return AuthScreen();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => callManager.startVoiceCall('+521...'),
              child: Text('Llamada de Voz WebRTC'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => callManager.startVideoCall('+521...'),
              child: Text('Video Llamada WebRTC'),
            ),
            SizedBox(height: 24),
            // BOTON QUE YA COBRA $5 REALES
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF88)),
              onPressed: () async {
                await PaymentService.launchCheckout(SubscriptionTier.proVoice);
              },
              child: Text('PAGAR PLAN PRO \$5 - VOZ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00D4FF)),
              onPressed: () async {
                await PaymentService.launchCheckout(SubscriptionTier.proVideo);
              },
              child: Text('PAGAR PLAN PRO \$15 - VIDEO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
