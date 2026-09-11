from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from transformers import pipeline
import uvicorn

app = FastAPI(title="JCVTRADUCTOR REAL")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

print("Cargando NLLB 600M...")
translator = pipeline("translation", model="facebook/nllb-200-distilled-600M")

@app.get("/")
def root():
    return {"status": "JCV TRADUCTOR REAL ONLINE - 600M", "version": "3.0"}

@app.post("/auth/register")
def register(phone: dict):
    return {"otp_sent": True, "to": phone.get('phone')}

@app.post("/webrtc/signal")
def signal(data: dict):
    return {"signal": data}

@app.post("/translate/text")
def translate_text(data: dict):
    text = data.get('text','')
    target = data.get('target_lang','en')
    mapa = {"en":"eng_Latn","es":"spa_Latn","fr":"fra_Latn","de":"deu_Latn"}
    tgt = mapa.get(target, "eng_Latn")
    result = translator(text, src_lang="spa_Latn", tgt_lang=tgt, max_length=200)
    return {"translated_text": result[0]['translation_text']}

@app.post("/translate/voice")
async def translate_voice(file: UploadFile = File(...)):
    audio = await file.read()
    return audio
