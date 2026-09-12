package com.jcv.traductor

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.*
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject

class MainActivity : ComponentActivity() {
    private val client = OkHttpClient()
    private val SERVER = "https://jcvtraductor.onrender.com"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            var messages by remember { mutableStateOf(listOf("JCV Traductor - Listo ✅\n")) }
            var input by remember { mutableStateOf("") }

            Column(Modifier.fillMaxSize().background(Color(0xFF121212)).padding(16.dp)) {
                Text("JCV Traductor • ES → EN", color = Color(0xFF25D366))
                Spacer(Modifier.height(10.dp))
                
                Column(Modifier.weight(1f).background(Color(0xFF1E1E1E)).padding(8.dp).fillMaxWidth()) {
                    messages.forEach { Text(it, color = Color.White) }
                }
                
                Row(Modifier.padding(top=8.dp)) {
                    TextField(value = input, onValueChange = { input = it }, modifier = Modifier.weight(1f), placeholder = { Text("Escribe en español...") })
                    Spacer(Modifier.width(8.dp))
                    Button(onClick = {
                        val currentInput = input
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                val json = JSONObject().put("text", currentInput).put("target_lang", "EN").toString()
                                val req = Request.Builder().url("$SERVER/translate/text").post(json.toRequestBody("application/json".toMediaType())).build()
                                val res = client.newCall(req).execute().body?.string()
                                val t = JSONObject(res ?: "{}").optString("translated_text", "Error")
                                withContext(Dispatchers.Main) {
                                    messages = messages + "Tú (ES): $currentInput\nBot (EN): $t\n"
                                    input = ""
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) { messages = messages + "Error: ${e.message}\n" }
                            }
                        }
                    }) { Text("ES→EN") }
                }
            }
        }
    }
}
