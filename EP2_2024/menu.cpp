#include "PersistenciaDeUsuario.h"
#include "Catraca.h"
using namespace std;
Data *lerData();
void menu(){
    int resp;
    int ncatraca, id, hora, minuto,segundo, dia, mes, ano;
    bool tf;
    string carregar,salvar, es, arquivo;
    GerenciadorDeUsuario *g=new GerenciadorDeUsuario();
    PersistenciaDeUsuario* p=new PersistenciaDeUsuario();
    cout<<"Deseja carregar usuarios (s/n): ";
    cin>>carregar;
    if(carregar=="s"){
        cout<<"arquivo: ";
        cin>>arquivo;
        try{
            g=new GerenciadorDeUsuario(p->carregar(arquivo));
        }catch (logic_error *e){
            cout<<e->what();
            delete e;
        }
    }
    Catraca *c1= new Catraca(g);
    Catraca *c2= new Catraca(g);
    Catraca**catracas=new Catraca*[1];
    catracas[0]=c1;
    catracas[1]=c2;
    do{
        cout << "Acesso ao predio " << endl << "1) Entrada " << endl << "2) Saida " << endl << "3) Registro manual " << endl << "4) Cadastro de usuario " << endl << "5) Relatorio " << endl <<"6) Configuracao"<<endl<<"0) Sair " << endl << "Escolha uma opcao: ";
        cin >> resp;
        cout << endl;
        if(resp==1 || resp==2){
            cout << "Catraca: ";
            cin >> ncatraca;
            cout << "Id: ";
            cin >> id;
            Data *d=lerData();
            if(resp==1){
                if(catracas[ncatraca]->entrar(id,d)){
                    cout << "[Entrada] Catraca " << ncatraca <<" abriu: id " << id << endl;
                }else{
                    cout<< "[Entrada] Catraca "<< ncatraca <<" travada" << endl;
                }
            }
            else{
                tf=catracas[ncatraca]->sair(id,d);
                if(tf){
                    cout << "[Saida] Catraca " << ncatraca <<" abriu: id " << id << endl;
                }else{
                    cout<< "[Saida] Catraca "<< ncatraca<<" travada" << endl;
                }
            }
            cout << endl;
        }else if(resp == 3){
            cout << "Entrada (e) ou Saida (s)? ";
            cin >> es;
            cout << "Id: ";
            cin >> id;
            Data* d=lerData();
            if(es=="e"){
                if(g->getUsuario(id)==nullptr){
                    tf=false;
                }
                else{
                    if(dynamic_cast<Funcionario*>(g->getUsuario(id))!=nullptr){
                        tf = dynamic_cast<Funcionario*>(g->getUsuario(id))->registrarEntradaManual(d);
                    }
                    else if(dynamic_cast<Aluno*>(g->getUsuario(id))!=nullptr){
                        tf = dynamic_cast<Aluno*>(g->getUsuario(id))->registrarEntradaManual(d);
                    }
                    else if(dynamic_cast<Visitante*>(g->getUsuario(id))!=nullptr){
                        tf = dynamic_cast<Visitante*>(g->getUsuario(id))->registrarEntradaManual(d);
                    }
                }
                if(tf){
                    cout << "Entrada manual registrada: id " << id << endl;
                }else{
                    cout<< "Erro ao registrar entrada manual" << endl;
                }
            }
            else{
                if(g->getUsuario(id)==nullptr){
                    tf=false;
                }
                else{
                    tf= dynamic_cast<Funcionario*>(g->getUsuario(id))->registrarSaidaManual(d);
                }
                if(tf){
                    cout << "Saida manual registrada: id " << id << endl;
                }else{
                    cout<< "Erro ao registrar saida manual" << endl;
                }
            }
            cout << endl;
        }else if(resp==4){
            string nm,tipo;
            cout<<"Tipo (v, a ou f): ";
            cin>>tipo;
            cout << "Id: ";
            cin >> id;
            cout << "Nome: ";
            cin >> nm;
            try{
                if(tipo=="a"|| tipo=="f"){
                    if(tipo=="a"){
                        Aluno * u=new Aluno(id,nm);
                        g->adicionar(u);
                    }else{
                        Funcionario* u = new Funcionario(id,nm); 
                        g->adicionar(u);
                    }
                }else{
                    cout<<"Data de inicio:"<<endl;
                    Data* inicio=lerData();
                    cout<<"Data de fim:"<<endl;
                    Data *fim=lerData();
                    Visitante* v=new Visitante(id,nm,inicio,fim);
                    g->adicionar(v);
                }
            }catch (invalid_argument* e){
                cout<<e->what();
                delete e;
            }catch (logic_error* e){
                cout<<e->what();
                delete e;
            }
            cout << "Usuario cadastrado com sucesso" << endl;
        }else if(resp==5){
            int i,j;
            cout << "Mes: ";
            cin >> mes;
            cout << "Ano: ";
            cin >> ano;
            cout << "Relatorio de horas trabalhadas" << endl;
            for(i=0;i<g->getUsuarios()->size();i++){
                if(dynamic_cast<Funcionario*>((*g->getUsuarios())[i])!=nullptr){
                    cout << (*g->getUsuarios())[i]->getNome() << ": " << dynamic_cast<Funcionario*>((*g->getUsuarios())[i])->getHorasTrabalhadas(mes,ano) << endl;
                }
            }
        }else if(resp==6){
            cout<<"Horario de fim da janela dos Alunos "<<endl<<"Hora: ";
            cin>>hora;
            cout<<"Minuto: ";
            cin>>minuto;
            Aluno::setHorarioFim(hora,minuto);
        }
        else if(resp==0){
            cout<<"Deseja salvar usuarios (s/n): ";
            cin>>salvar;
            if(salvar=="s"){
                cout<<"Arquivo: ";
                cin>>arquivo;
                p->salvar(arquivo, g->getUsuarios());
            }
        }
        cout << endl;
    }while(resp !=0);
}
Data* lerData(){
    int hora,minuto,segundo,dia,mes,ano;
    Data* d;
            cout << "Hora: ";
            cin >> hora; 
            cout << "Minuto: ";
            cin >> minuto; 
            cout << "Segundo: ";
            cin >> segundo;
            cout << "Dia: ";
            cin >> dia;
            cout << "Mes: ";
            cin >> mes;
            cout << "Ano: ";
            cin >> ano;
            try{
                d=new Data(hora,minuto,segundo,dia,mes,ano);
            }catch (logic_error *e){
                cout<<e->what();
                delete e;
            }
            return d;
}