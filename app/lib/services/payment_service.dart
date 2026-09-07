import '../models/subscription_tiers.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  // TUS 3 PLANES: $0, $5, $15 - Checa límites
  static Future<bool> checkLimit(Plan plan, bool mismoIdioma, String tipo, int usados) {
    if (mismoIdioma) return Future.value(true);
    var limite = SubscriptionTiers.tiers[plan]!['${tipo}_min'];
    if (limite == -1) return Future.value(true);
    return Future.value(usados < limite);
  }

  static String getPaywallMessage(Plan plan) {
    if (plan == Plan.gratis) {
      return "Se acabaron tus 5 minutos gratis. Actualiza a PRO \$5/mes para voz ilimitada";
    }
    return "Actualiza a ENTERPRISE \$15/mes para todo ilimitado + API";
  }

  // ESTO ES LO NUEVO - ABRE TU LINK DE STRIPE
  static Future<void> launchCheckout(Plan plan) async {
    String? url = SubscriptionTiers.tiers[plan]!['checkout_url'];
    if (url == null) return;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> pagarPro() async {
    await launchCheckout(Plan.pro);
  }

  static Future<void> pagarEnterprise() async {
    await launchCheckout(Plan.enterprise);
  }
}
