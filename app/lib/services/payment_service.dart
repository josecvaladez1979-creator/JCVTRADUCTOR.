import '../models/subscription_tiers.dart';

class PaymentService {
  // TUS 3 PLANES: $0, $5, $15
  static Future<bool> checkLimit(Plan plan, bool mismoIdioma, String tipo, int usados) {
    if (mismoIdioma) return Future.value(true);

    var limite = SubscriptionTiers.tiers[plan]!['${tipo}_min'];
    if (limite == -1) return Future.value(true);

    return Future.value(usados < limite);
  }

  static String getPaywallMessage(Plan plan) {
    if (plan == Plan.gratis) {
      return "Se acabaron tus 5 minutos gratis. Actualiza a PRO \$5/mes: texto y llamadas ilimitadas";
    }
    return "Actualiza a ENTERPRISE \$15/mes para todo ilimitado + API KEY para empresas";
  }
}
