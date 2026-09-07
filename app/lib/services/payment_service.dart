import '../app/lib/models/subscription_tiers.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  // 3 PLANES: $0, $5, $15 - Checa límites
  static Future<bool> checkLimit(Plan plan, bool mismoIdioma, String tipo, int usados) {
    if (mismoIdioma) return Future.value(true);
    final tier = SubscriptionTiers.tiers[plan];
    if (tier == null) return Future.value(false);
                final limite = (tier[tipo] as int?)?? 0;
    if (limite == -1) return Future.value(true);
    return Future.value(usados < limite);
  }

  static String getPaywallMessage(Plan plan) {
    if (plan == Plan.gratis) {
      return "Se acabaron tus 5 min gratis. Actualiza a PRO \$5/mes.";
    }
    return "Actualiza a ENTERPRISE \$15/mes para ilimitado.";
  }

  // ABRE TU LINK DE STRIPE
  static Future<void> launchCheckout(Plan plan) async {
    final urlString = SubscriptionTiers.tiers[plan]!['checkout_url'] as String?;
    if (urlString == null) return;
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
