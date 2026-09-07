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
      'texto_min': -1,
      'voz_min': -1,
      'video_min': 900,
      'mismo_idioma_ilimitado': true,
      'checkout_url': 'https://buy.stripe.com/test_8x29AU7Mq1MV8cwaevawo00',
    },
    Plan.enterprise: {
      'price': 15,
      'texto_min': -1,
      'voz_min': -1,
      'video_min': -1,
      'api_key': true,
      'mismo_idioma_ilimitado': true,
      'checkout_url': 'https://buy.stripe.com/test_8x29AU7Mq1MV8cwaevawo00',
    },
  };
