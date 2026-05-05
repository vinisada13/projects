const { SerialPort } = require('serialport');
const WebSocket = require('ws');

const port = new SerialPort({
  path: 'COM11', // ou /dev/ttyUSB0
  baudRate: 9600
});

const wss = new WebSocket.Server({ port: 8080 });

console.log("Servidor WS rodando em ws://localhost:8080");

let clients = [];
//let started = false;
wss.on('connection', (ws) => {
  console.log("Cliente conectado");
  clients.push(ws);
  ws.on('close', () => {
    clients = clients.filter(c => c !== ws);
  });
});
//verifica se a porta abriu
port.on('open', () => {
  console.log("Serial aberta");
});
// SERIAL → FRONTEND

port.on('data', (buffer) => {
  const dataCode = buffer.readUInt8(0)  & 0b01111111;


  console.log("Recebido:", dataCode);

  clients.forEach(ws => {
    ws.send(dataCode);//manda o dataCode para o frontend
  });
});
//verifica se tem erro na porta serial
port.on('error', (err) => {
  console.error("Erro serial:", err.message);
});

  // receber comandos do navegador (opcional)
 /* ws.on('message', (msg) => {
    console.log("Do navegador:", msg.toString());
  });*/