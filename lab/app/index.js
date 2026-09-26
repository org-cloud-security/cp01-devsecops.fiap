const express = require("express");

const app = express();

app.use(express.static("public"));

app.get("/hello", (req, res) => {
  // VULNERAVEL: a entrada do usuario vai para o HTML sem escape (XSS refletido, CWE-79)
  res.send("Hello, " + req.query.name);

  // CORRECAO: comente a linha acima e descomente a linha abaixo.
  // Content-Type text/plain faz o navegador tratar a resposta como texto, nao como HTML.
  // res.type("text").send("Hello, " + req.query.name);
});

app.listen(3000, () => console.log("listening on port 3000"));
