from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(title="JCVTRADUCTOR REAL")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/")
def root(): return {"status": "JCV TRADUCTOR REAL ONLINE"}

@app.post("/auth/register")
def register(phone: dict):
    print(f"OTP para {phone['phone']}")
    return {"otp_sent": True, "to": phone['phone']}

@app.post("/webrtc/signal")
def signal(data: dict):
    return {"signal": data}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
