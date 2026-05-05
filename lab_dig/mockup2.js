const { SerialPortMock } = require('serialport');
const WebSocket = require('ws');
const readline = require('readline');

const path = 'COM_TEST';

SerialPortMock.binding.createPort(path);

const port = new SerialPortMock({
  path,
  baudRate: 9600
});

const wss = new WebSocket.Server({ port: 8080 });

console.log("Servidor WS rodando em ws://localhost:8080");
console.log("Teclas: 1, 2 ou 3 = começar no modo 1, 2 ou 3 | a = acerto | e = erro | r = reset | c = sair");

let clients = [];
let started = false;

wss.on('connection', (ws) => {
  console.log("Cliente conectado");
  clients.push(ws);

  if (!started) {
    started = true;
  }

  ws.on('close', () => {
    clients = clients.filter(c => c !== ws);
  });
});

// SERIAL → FRONTEND
port.on('data', (buffer) => {
  const dataCode = buffer.readUInt8(0) & 0b01111111;

  console.log("Recebido:", dataCode);
  console.log("Clientes conectados:", clients.length);

  clients.forEach(ws => {
    clients.forEach(ws => {
  if (ws.readyState === WebSocket.OPEN) {
    ws.send(dataCode.toString());
  }
});
  });
});

// ================= ESTADO DO JOGO =================
let t = 0; // tentativas
let a = 0; // acertos
let mod = 0;
// ================= TECLADO =================
readline.emitKeypressEvents(process.stdin);

if (process.stdin.isTTY) {
  process.stdin.setRawMode(true);
}

process.stdin.resume();

process.stdin.on('keypress', (str, key) => {
  switch (key.name) {
    case '1':
      t = 0;
      a = 0;
      mod=0;
      enviar(0b11000000+mod*8);
      console.log(`Jogo iniciado: ${mod}`);
      break;
    case '2':
      t = 0;
      a = 0;
      mod=1;
      enviar(0b11000000+mod*8);
      console.log(`Jogo iniciado: ${mod}`);
      break;
    case '3':
      t = 0;
      a = 0;
      mod=2;
      enviar(0b11000000+mod*8);
      console.log(`Jogo iniciado: ${mod}`);
      break;

    case 'a':
      t = t + 1;
      a = a + 1;

      // resposta certa
      enviar(32 + t + 128);
      if(a==8){
         setTimeout(() => {
         enviar(127 + 128); // fim
      }, 1500);
      console.log(`pts: ${a}, tent: ${t}`)
      }
      else{
      setTimeout(() => {
        enviar(a + 96 + 128+mod*8); // acertos
      }, 1000);

      setTimeout(() => {
        enviar(64 + a + 128+mod*8); // id
      }, 1200);
      console.log(`pts: ${a}, tent: ${t}`)
    }
      break;

    case 'e':
      t = t + 1;

      // resposta errada
      enviar(t + 128);
      console.log(`pts: ${a}, tent: ${t}`)
      break;

    /*case 'f':
      enviar(127 + 128); // fim
      break;*/

    case 'r':
      enviar(121 + 128); // reset
      t=0;
      a=0;
      break;

    case 'c':
      console.log("Encerrando...");
      process.exit();
      break;
  }
});

// ================= ENVIO MOCK =================
function enviar(code) {
  console.log("Enviado:", code.toString(2).padStart(8, '0'));
  port.port.emitData(Buffer.from([code]));
    console.log("Enviado:", code.toString(2).padStart(8, '0'));
    port.port.emitData(Buffer.from([code]));
}
