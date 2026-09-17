import express from "express";
import path from "path";
const app = express();
app.use(express.static("."));
app.get("*", (req,res) => res.sendFile(path.resolve("index.html")));
const port = process.env.PORT || 10000;
app.listen(port, () => console.log("Live en " + port));
