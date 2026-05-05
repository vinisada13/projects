// const pergunta = [
//     ['2+2',"lingua do Canadá",'3a',"4a",'5a',"6a",'7a',"8a"],
//     ['teste',"2b",'3b',"4b",'5b',"6b",'7b',"8b"],
//     ['teste',"2c",'3c',"4c",'5c',"6c",'7c',"8c"]]

const alternativas = [[["Vai chover", "Vai fazer calor", "Vai esfriar", "Vai ventar muito"],
			["Está ensolarado", "Vai chover", "Está frio", "Está ventando"],
			["A pessoa errou algo", "A pessoa tentou e conseguiu algo", "A pessoa ficou doente", "A pessoa perdeu algo"],
			["Falar mais alto", "Correr", "Ir embora", "Ficar em silêncio"],
			["Abrir a porta", "Fechar a janela", "Ligar o ventilador", "Sair do quarto"],
			["Cair e escorregar", "Ficar com calor", "Ficar cansado", "Sentir fome"],
			["Comer", "Brincar", "Dormir", "Estudar"],
			["Aula", "Festa", "Reunião", "Viagem"],
],
[			["Triste", "Bravo", "Feliz", "Com medo"],
			["Feliz", "Triste", "Animado", "Bravo"],
			["Feliz", "Triste", "Bravo", "Surpreso"],
			["Medo", "Alegria", "Raiva", "Calma"],
			["Neutra / calma", "Feliz", "Bravo", "Com medo"],
			["Triste", "Surpreso", "Bravo", "Com sono"],
			["Feliz", "Bravo/irritado", "Triste", "Calmo"],
			["Medo", "Raiva", "Calma / tranquilidade", "Surpresa"],
],
[			["Que a pessoa quer saber o dia exato", "Que a pessoa não vai", "Que é uma ordem", "Que é uma reclamação"],
			["Que qualquer pessoa pode ir", "Que a pergunta é sobre outra pessoa", "Que a dúvida é especificamente se você vai", "Que é uma afirmação"],
			["Que a pessoa proíbe especificamente essa ação", "Que a pessoa está perguntando", "Que a pessoa não se importa", "Que é uma brincadeira"],
			["Que a pessoa está reforçando a proibição", "Que a pessoa está em dúvida", "Que a pessoa está elogiando", "Que é um pedido educado"],
			["Surpresa com a ação realizada", "Que a pessoa está feliz", "Que é uma ordem", "Que a pessoa não ouviu direito"],
			["Que qualquer pessoa poderia ter feito", "Que a dúvida é sobre quem fez a ação", "Que a frase é uma reclamação", "Que é uma afirmação"],
			["Que o importante é o momento em que ele iria", "Que não importa quando", "Que a pessoa está fazendo uma pergunta", "Que a frase é irônica"],
			["Que outra pessoa iria", "Que a ênfase está em quem disse isso", "Que a frase é uma ordem", "Que a pessoa está com medo"],
],
]

const pergunta = [[" O que provavelmente vai acontecer?", " Por que a pessoa disse isso?", " O que aconteceu antes?", " O que deve ser feito?", " O que a pessoa quer?", " O que pode acontecer?", " O que deve acontecer agora?", " O que provavelmente está acontecendo?", ],
[" Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", " Qual é a emoção?", ],
[" A entonação em “hoje” indica:", " A entonação em “você” indica:", " A entonação em “isso” indica:", " A entonação em “faça” indica:", " A entonação em “isso” indica:", " A entonação em “você” indica:", " A entonação em “agora” indica:", " A entonação em “ele” indica:", ],
]
const modo = 0

const reset = 0

const n_tentativas = 11

const n_contexto = 0

const n_emocao = 10

const n_entoncao = 0


// const alternativas =[[['1', '2', '3', '4'],
//                     ['Espanhol', 'Português', 'Inglês', 'Francês'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                 ],[['teste', 'test', '2', '4'],
//                     ['Espanhol', 'Português', 'Inglês', 'Francês'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                 ],[['teste', 'test', '2', '4'],
//                     ['Espanhol', 'Português', 'Inglês', 'Francês'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
//                     ['alt', 'alt', 'alt', 'alt'],
                // ]]