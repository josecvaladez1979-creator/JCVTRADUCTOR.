# JCV TRADUCTOR - COBROS $5 y $15 + API KEY
import stripe
stripe.api_key = "sk_test_51UCnBLK4if6qZOxwx..." # tu key de prueba que ya tienes

PLANS = {
    "pro": {"price": 5, "texto": -1, "voz": -1, "video": 50,
            "link": "https://buy.stripe.com/test_aFa7sM3wadvDeAU86nawo01"},
    "enterprise": {"price": 15, "todo_ilimitado": True,
            "link": "https://buy.stripe.com/test_eVqdRaaYC77f64o72jawo02"}
}

def check_user_limit(user_plan, usado, tipo):
    if user_plan == "gratis":
        limits = {"texto": 20, "voz": 5, "video": 1}
        return usado < limits[tipo]
    return True # pro y enterprise ilimitado

def create_api_key_for_company(company_name):
    # Venta de API KEY a empresas grandes
    import secrets
    return f"jcv_live_{secrets.token_hex(16)}"

def get_payment_link(plan_name):
    return PLANS.get(plan_name, {}).get("link")
