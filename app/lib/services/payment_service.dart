import 'subscription_tiers.dart';

class PaymentService {
  // TUS 3 PLANES
  static Future<bool> checkLimit(Plan plan, bool mismoIdioma, String tipo, int usados) {
    if (mismoIdioma) return Future.value(true); // Gratis siempre si es mismo idioma

    var limite = SubscriptionTiers.tiers[plan]!['${tipo}_min'];
    if (limite == -1) return Future.value(true); // Ilimitado

    return Future.value(usados < limite);
  }

  static String getPaywallMessage(Plan plan) {
    if (plan == Plan.gratis) {
      return "Te quedan 0 minutos gratis. Actualiza a PRO \$5/mes para texto y llamadas ilimitadas";
    }
    return "Actualiza a ENTERPRISE \$15/mes para todo ilimitado + API KEY";
  }
}
