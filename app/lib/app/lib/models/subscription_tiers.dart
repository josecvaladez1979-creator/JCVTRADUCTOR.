enum Plan { gratis, pro, enterprise }

class SubscriptionTiers {
  static Map<Plan, Map<String, dynamic>> tiers = {
    Plan.gratis: {
      'price': 0,
      'texto_min': 20,
      'voz_min': 5,
      'video_min': 5,
      'mismo_idioma_ilimitado': true,
    },
    Plan.pro: {
      'price': 5,
      'texto_min': -1, // -1 = ilimitado
      'voz_min': -1,
      'video_min': 900, // 15 horas = 900 min
      'mismo_idioma_ilimitado': true,
    },
    Plan.enterprise: {
      'price': 15,
      'texto_min': -1,
      'voz_min': -1,
      'video_min': -1,
      'api_key': true,
      'mismo_idioma_ilimitado': true,
    },
  };

  static bool canTranslate({required Plan plan, required bool mismoIdioma, required String tipo, required int usados}) {
    if (mismoIdioma) return true; // Siempre gratis si es mismo idioma
    var limite = tiers[plan]!['${tipo}_min'];
    if (limite == -1) return true;
    return usados < limite;
  }
}
