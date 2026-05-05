let dataCode =0;
const socket = new WebSocket("ws://localhost:8080");
socket.onopen = () => {
  console.log("Conectado ao servidor");
};

socket.onmessage = (event) => {
    dataCode=Number(JSON.parse(event.data));
    console.log(`dataCode: ${dataCode}`);
    //localStorage.setItem('sig',dataCode.toString())
    if((dataCode >> 5)== 0b10){
      localStorage.setItem('lastID',dataCode.toString());
      console.log("entra id");//guarda na memória do servidor
    }else if(dataCode >> 6 == 0){
      localStorage.setItem('attemps',dataCode.toString());
      console.log(`attemps: ${n_attemps}`);
    }else if(dataCode >> 5 ==0b11 && dataCode >> 3 !== 0b1111){
      localStorage.setItem('acertos',dataCode.toString());
      console.log(`acertos: ${n_acertos}`);
    }else if(dataCode ==121){
      window.location.href="inicio.html"
    }
}


// ================= JOGO =================
let currentAudio = null;
let n_acertos = 0b0;
let n_attemps;
let mode = 0b00;
let resposta = null;
//let reset = false;

// ================= FUNÇÕES =================

function iniciar() {
  latsTheme();
  localStorage.setItem('lastID','0');
  localStorage.setItem('acertos','0');
  localStorage.setItem('attemps','0');
  console.log("Aguardando sinal...");
  console.log(localStorage.getItem('lastID'));

  // verifica periodicamente (sem travar)
  const interval = setInterval(() => {
    //console.log("Verificando sinal...", localStorage.getItem('lastID'));
    if (localStorage.getItem('lastID') >0) {
      clearInterval(interval);
      console.log("inicio",dataCode);
      window.location.href = "quiz.html";
    }
  }, 100);
}

function startQuiz() {
  latsTheme();
  dataCode=Number(localStorage.getItem('lastID'));
  console.log("startQuiz:",dataCode);
  if((dataCode >> 5)== 0b10){
    const n_question = (dataCode) & 0b0000111;
    mode  = (dataCode >> 3) & 0b0011;
    loadData(n_question,mode);//add mode
  }
}

function final() { // função usada na pagina de acertou
  console.log('audio')
  if (currentAudio) {
    currentAudio.pause();
    currentAudio.currentTime = 0;
  }
  new Audio("audio/correct.mp3").play();
  let lastData = dataCode;
  setTimeout(() => {
    window.location.href="quiz.html";
  },3000);
  const interval = setInterval(() => {
    if (dataCode !== lastData) {
      if(((dataCode >> 5)== 0b10) || (dataCode == 127)){
        console.log('fnal:', dataCode);
        clearInterval(interval);
        if(dataCode == 0b1111111){
          console.log('fim: ',dataCode);
          window.location.href="fim.html"
        }else if((dataCode >> 5)== 0b10){
          console.log('proximo id:', dataCode)
          window.location.href="quiz.html"
        }
      }
    }
  },50)
};
recomeçar = ()=>{ //ativada na aba fim
  console.log('audio')
  if (currentAudio) {
    currentAudio.pause();
    currentAudio.currentTime = 0;
  }
  new Audio("audio/end3.mp3").play();
  latsTheme();
  getAcertos();
  getAttemps();
  document.getElementById("pontos").textContent =(`acertos: ${n_acertos+1}`);
  document.getElementById("tentativas").textContent =(`tentativas: ${n_attemps}`);
  iniciar();
}

function getAttemps() {
    n_attemps = Number(localStorage.getItem('attemps')) & 0b0011111;
  return n_attemps;
}


function getAcertos() {
  n_acertos = (Number(localStorage.getItem('acertos')) & 0b0000111);
}

function loadData(num,modf) {
  document.getElementById("question").textContent = pergunta[modf][num];

  document.getElementById("answer1").textContent = `a) ${alternativas[modf][num][0]}`;
  document.getElementById("answer2").textContent = "b) " + alternativas[modf][num][1];
  document.getElementById("answer3").textContent = "c) " + alternativas[modf][num][2];
  document.getElementById("answer4").textContent = "d) " + alternativas[modf][num][3];

 
  getAcertos();
  getAttemps();
  let nameMode;
  switch(mode){
    case 0: nameMode = "Contexto";
    break;
    case 1: nameMode = "Emoção";
    break;

    case 2: nameMode = "Entonação";
    break;
    case 3: nameMode = "Desconhecido";
    break;
  }
  document.getElementById("mode").textContent =(`modo: ${nameMode}`);
  document.getElementById("Pontuação").textContent =(`Pontos: ${n_acertos}`);
  document.getElementById("tentativas").textContent =(`Tentativas: ${n_attemps}`);
  playAudio(num);

  /*if (reset) {
    n_attemps = 0;
  }*/

  console.log( mode);

  // espera resposta sem travar
  waitForResposta();
}

function playAudio(id) {

  console.log('audio')
  if (currentAudio) {
    currentAudio.pause();
    currentAudio.currentTime = 0;
  }
  let n_question=Number(localStorage.getItem('lastID'))  & 0b0000111;
  currentAudio = new Audio("audio/q" + (mode*8 + n_question) + ".mp3");
  console.log(currentAudio)
  currentAudio.play();
}

function pauseAudio() {
  if (currentAudio.paused) {
    currentAudio.play();
  } else {
    currentAudio.pause();
  }
}

// ================= RESPOSTA =================

function waitForResposta() {
  console.log("esperando resposta");

let lastData = getAttemps();
let lastRep = dataCode;

const interval = setInterval(() => {
  if(dataCode==123){
    console.log("entra dataCode==123");
    if (currentAudio) {
    currentAudio.pause();
    currentAudio.currentTime = 0;
    dataCode = 666;
  }
  console.log(currentAudio)
  currentAudio.play();
  }
  if ((getAttemps()) !== lastData) {
    if((Number(localStorage.getItem('attemps')) >> 5)==1){//código que indica acerto
        resposta = true;
        //lastData = dataCode;
        lastData = Number(localStorage.getItem('attemps'));
        clearInterval(interval);
        compare();
    }else if((Number(localStorage.getItem('attemps')) >> 5)==0){//código que indica que errou
        resposta=false;
        //lastData = dataCode;
        lastData = Number(localStorage.getItem('attemps'));
        clearInterval(interval);
        compare();
    }
  }
}, 100)};

function compare() {
  console.log("Resposta recebida:", resposta);

  // exemplo simples:
  // 1 = acertou, 0 = errou
  if (resposta) {
    console.log("acertou");
    window.location.href = "acertou.html";
  } else {
    console.log("errou");
    myFunction();
  }
}

// ================= AUXILIARES =================

/*function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}*/

function myFunction() {
  console.log('audio')
  if (currentAudio) {
    currentAudio.pause();
    currentAudio.currentTime = 0;
  }
  new Audio("audio/wrong.mp3").play();
  const popup = document.getElementById("myPopup");
  popup.classList.toggle("show");

  setTimeout(() => {
    window.location.href = "quiz.html";
  }, 3000);

  // aqui você pode enviar erro para FPGA
}
latsTheme=()=>{
  let last = localStorage.getItem("theme");
  if(last==null){
    last='theme-default'
  }
  document.body.className = last;
}