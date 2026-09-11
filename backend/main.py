from fastapi import FastAPI, Form, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(title="JCVTRADUCTOR REAL")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/")
def root(): 
    return {"status": "JCV TRADUCTOR REAL ONLINE", "version": "2.0"}

@app.post("/auth/register")
def register(phone: dict):
    print(f"OTP para {phone.get('phone')}")
    return {"otp_sent": True, "to": phone.get('phone')}

@app.post("/webrtc/signal")
def signal(data: dict):
    return {"signal": data}

# --- ESTAS SON LAS QUE FALTABAN ---
@app.post("/translate/text")
def translate_text(data: dict):
    text = data.get('text', '')
    target = data.get('target_lang', 'en')
    # Aquí luego conectamos tu ai_model real
    print(f"Traduciendo texto: {text} -> {target}")
    return {"translated_text": f"[{target}] {text}"} # Mock por ahora

@app.post("/translate/voice")
async def translate_voice(file: UploadFile = File(...), target_lang: str = Form(...)):
    audio = await file.read()
    print(f"Traduciendo voz: {len(audio)} bytes -> {target_lang}")
    # Aquí luego conectamos tu ai_model real
    return audio # Por ahora regresa el mismo audio

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
