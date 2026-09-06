# JCV TRADUCTOR - COBROS $5 y $15 + API KEY EMPRESAS
import stripe
stripe.api_key = "sk_test_51UCnBLK4if6qZOxwxVNbuhNBkNtdOMPh9YNmo5b589xkbm8duszfa7nJkarVBCytKWRXbMwBzxNoeJQu418c9IDi00l8kuFQYn

PLANS = {
  "pro": {"price": 5, "texto": -1, "voz": -1, "video": 900},
  "enterprise": {"price": 15, "todo_ilimitado": True, "api_key": True}
}

def check_user_limit(user_plan, usado, tipo):
    if user_plan == "gratis":
        limits = {"texto": 20, "voz": 5, "video": 5}
        return usado < limits[tipo]
    return True # pro y enterprise ilimitado

def create_api_key_for_company(company_name):
    # Venta de API KEY a empresas grandes
    import secrets
    return f"jcv_live_{secrets.token_hex(16)}"
