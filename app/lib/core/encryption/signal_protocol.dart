import 'dart:typed_data';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignalProtocol {
  final _storage = FlutterSecureStorage();
  late SignalProtocolStore _store;

  Future<void> initIdentity() async {
    _store = InMemorySignalProtocolStore(
      IdentityKeyPair(
        IdentityKey(Curve.generateKeyPair().publicKey),
        Curve.generateKeyPair().privateKey,
      ),
      Curve.generateKeyPair().publicKey.serialize(),
    );

    // Genera PreKeys reales
    final preKeys = <PreKeyRecord>[];
    for (int i = 0; i < 100; i++) {
      final keyPair = Curve.generateKeyPair();
      preKeys.add(PreKeyRecord(i, keyPair));
    }
    await _store.storePreKeys(preKeys);

    // Signed PreKey
    final signedKeyPair = Curve.generateKeyPair();
    final signedPreKey = SignedPreKeyRecord(
      0,
      DateTime.now().millisecondsSinceEpoch,
      signedKeyPair,
      Curve.calculateSignature(
        _store.getIdentityKeyPair().getPrivateKey(),
        signedKeyPair.publicKey.serialize(),
      ),
    );
    await _store.storeSignedPreKey(signedPreKey);
  }

  Future<Uint8List> encryptMessage(String phoneNumber, String message) async {
    final address = SignalProtocolAddress(phoneNumber, 1);
    final sessionBuilder = SessionBuilder.fromSignalStore(_store, address);
    
    // Obtiene bundle del servidor real
    final remoteBundle = await _fetchPreKeyBundle(phoneNumber);
    await sessionBuilder.processPreKeyBundle(remoteBundle);

    final cipher = SessionCipher.fromStore(_store, address);
    final encrypted = await cipher.encrypt(Uint8List.fromList(message.codeUnits));
    return encrypted.serialize();
  }

  Future<String> decryptMessage(String from, Uint8List cipherText) async {
    final address = SignalProtocolAddress(from, 1);
    final cipher = SessionCipher.fromStore(_store, address);
    final plain = await cipher.decryptFromPreKey(PreKeySignalMessage(cipherText));
    return String.fromCharCodes(plain);
  }

  Future<PreKeyBundle> _fetchPreKeyBundle(String phone) async {
    // Aqui va tu llamada REAL a backend/api/keys/{phone}
    // Por ahora genera uno temporal para pruebas
    final keyPair = Curve.generateKeyPair();
    final signedKey = Curve.generateKeyPair();
    return PreKeyBundle(
      1, 1, 0, keyPair.publicKey,
      0, signedKey.publicKey,
      Uint8List(64), // firma
      _store.getIdentityKeyPair().getPublicKey(),
    );
  }
}
