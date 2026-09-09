# backend/webhook.py - DESBLOQUEO AUTOMATICO DESPUES DEL PAGO
from flask import Flask, request, jsonify
import stripe

app = Flask(__name__)

# PON AQUI TU CLAVE DE PRUEBA
stripe.api_key = "sk_test_51UCnBLK4if6qZOxwx..."

# TUS 2 LINKS DE PRUEBA
PRO_LINK = "https://buy.stripe.com/test_aFa7sM3wadvDeAU86nawo01"
ENTERPRISE_LINK = "https://buy.stripe.com/test_eVqdRaaYC77f64o72jawo02"

# Esta es tu "base de datos" simple por ahora
# Luego la cambiamos a Firebase
users_db = {}

@app.route('/webhook', methods=['POST'])
def stripe_webhook():
    payload = request.get_data()
    sig_header = request.headers.get('Stripe-Signature')
    # Este es el secreto del webhook, lo sacas de Stripe Dashboard > Webhooks
    endpoint_secret = "whsec_TU_SECRETO_AQUI"

    try:
        event = stripe.Webhook.construct_event(payload, sig_header, endpoint_secret)
    except Exception as e:
        return jsonify(error=str(e)), 400

    # CUANDO ALGUIEN PAGA CON EXITO
    if event['type'] == 'checkout.session.completed':
        session = event['data']['object']
        customer_email = session.get('customer_details', {}).get('email')
        payment_link = session.get('payment_link')

        # Detectar que plan compro
        plan = "gratis"
        if payment_link == PRO_LINK:
            plan = "pro"
        elif payment_link == ENTERPRISE_LINK:
            plan = "enterprise"

        # DESBLOQUEAR AL USUARIO
        if customer_email:
            users_db[customer_email] = {
                "plan": plan,
                "paid": True,
                "email": customer_email
            }
            print(f"✅ USUARIO DESBLOQUEADO: {customer_email} -> {plan}")

    return jsonify(success=True), 200

@app.route('/check_plan/<email>', methods=['GET'])
def check_plan(email):
    # Tu app Flutter le pregunta a esto: "que plan tiene jose@gmail.com ?"
    user = users_db.get(email, {"plan": "gratis"})
    return jsonify(user)

if __name__ == '__main__':
    app.run(port=4242)
