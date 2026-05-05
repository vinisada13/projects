const { SerialPortMock } = require('serialport');
const WebSocket = require('ws');

const path = 'COM_TEST';

SerialPortMock.binding.createPort(path);

const port = new SerialPortMock({
  path,
  baudRate: 9600
});

const wss = new WebSocket.Server({ port: 8080 });

console.log("Servidor WS rodando em ws://localhost:8080");

let clients = [];
let started = false;
wss.on('connection', (ws) => {
  console.log("Cliente conectado");
  clients.push(ws);
  if(!started){

  started=true;
  }
  ws.on('close', () => {
    clients = clients.filter(c => c !== ws);
  });
});

// SERIAL → FRONTEND
port.on('data', (buffer) => {
  const dataCode = buffer.readUInt8(0) & 0b01111111;


  console.log("Recebido:", dataCode);

  clients.forEach(ws => {
    //ws.send(JSON.stringify({ modo, valor }));
    ws.send(dataCode);
  });
});
let t = 0;
let a = 0;
process.stdin.on('keypress', (str, key) => {

  switch (key.name) {
    case 'c':
      enviar(0b11000000);
      console.log("oi");
      break;
    case 'a':
      t=t+1;
      a=a+1;
      enviar(32+a+128); // certo
      setTimeout(() => {
      enviar(a+96+128);
  }, 50);
      setTimeout(() => {
        enviar(64+a+128);
  }, 100);
      break;

    case 'e':
      t=t+1;
      enviar(t); // errado
      break;

    case 'f':
      enviar(127+128); // fim
      break;
    case 'r':
      enviar(121+128); // fim
      break;
    case 'q':
      console.log("Encerrando...");
      process.exit();
      break;
  }
});

function enviar(code) {
  //const data = ((modo << 5) | valor) << 1;
  console.log(Buffer.from([code]));
  port.port.emitData(Buffer.from([code]));
}
