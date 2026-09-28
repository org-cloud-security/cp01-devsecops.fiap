const express = require("express");
const helmet = require("helmet");
const Tokens = require("csrf");

const tokens = new Tokens();
const secret = tokens.secretSync();

const app = express();

app.use(helmet());

app.use((req, res, next) => {
  if (["GET", "HEAD", "OPTIONS"].includes(req.method)) return next();
  if (tokens.verify(secret, req.get("x-csrf-token") || "")) return next();
  res.sendStatus(403);
});

app.use(express.static("public"));

app.get("/hello", (req, res) => {
  // res.send("Hello, " + req.query.name);
  res.type("text").send("Hello, " + req.query.name);
});

app.listen(3000, () => console.log("listening on port 3000"));
