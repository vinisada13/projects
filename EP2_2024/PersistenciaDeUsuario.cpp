#include "PersistenciaDeUsuario.h"
#include <fstream>
PersistenciaDeUsuario::PersistenciaDeUsuario(){

}
PersistenciaDeUsuario::~PersistenciaDeUsuario(){

}
vector<Usuario*>* PersistenciaDeUsuario::carregar(string arquivo){
    vector<Usuario*>* us=new vector<Usuario*>();
    GerenciadorDeUsuario* gerenciador= new GerenciadorDeUsuario(us);
    string t, nome,rt;
    int id, hora,min,s,dia,mes,ano, i, qnt;
    bool isManual;
    ifstream input;
    input.open(arquivo);

    input>>t>>id>>nome;
    while(input){
        if(t=="F"){
            input>>qnt;
            Funcionario* f=new Funcionario(id,nome);
            for(i=0;i<qnt;i++){
                input>>rt;
                input>>hora>>min>>s>>dia>>mes>>ano;
                input>>isManual;
                Data* d=new Data(hora,min,s,dia,mes,ano);
                //cout<<"regN:"<<f->getRegistros()->size();
                if(rt=="E"){
                    if(isManual){
                        f->registrarEntradaManual(d);
                    }
                    else{
                        f->entrar(d);
                    }
                }
                else{
                    if(isManual){
                        f->registrarSaidaManual(d);
                    }
                    else{
                        f->sair(d);
                    }
                }
            }
            gerenciador->adicionar(f);
        }
        else if(t=="A"){
            Aluno* a= new Aluno(id,nome);
            gerenciador->adicionar(a);
        }
        else if(t=="V"){
            input>>hora>>min>>s>>dia>>mes>>ano;
            Data* inicio=new Data(hora,min,s,dia,mes,ano);
            input>>hora>>min>>s>>dia>>mes>>ano;
            Data* fim=new Data(hora,min,s,dia,mes,ano);
            Visitante *v= new Visitante(id,nome,inicio,fim);
            gerenciador->adicionar(v);
        }
                input>>t>>id>>nome;
    }
    if(!input.eof()){
        throw new logic_error("erro no arquivo");
    }
    input.close();
    return us;
}
void PersistenciaDeUsuario::salvar(string arquivo, vector<Usuario*>* v){
    int i;
    Data* d;
    ofstream output;
    output.open(arquivo);
    for(i=0;i<v->size();i++){
        if(dynamic_cast<Funcionario*>((*v)[i])!=nullptr){
            output<<"F ";
        }else if(dynamic_cast<Aluno*>((*v)[i])!=nullptr){
            output<<"A ";
        }
        else if(dynamic_cast<Visitante*>((*v)[i])!=nullptr){
            output<<"V ";
        }
        output<<(*v)[i]->getId() << " "<< (*v)[i]->getNome()<<" ";
        if(dynamic_cast<Funcionario*>((*v)[i])!=nullptr){
            output<<endl<<dynamic_cast<Funcionario*>((*v)[i])->getRegistros()->size();
            vector<Registro*>::iterator j=dynamic_cast<Funcionario*>((*v)[i])->getRegistros()->begin();
            while(j!=dynamic_cast<Funcionario*>((*v)[i])->getRegistros()->end()){
                output<<endl;
                if(dynamic_cast<Entrada*>(*j)!=nullptr){
                    output<<"E ";
                }
                else{
                    output<<"S ";
                }
                d= (*j)->getData();
                output<<d->getHora()<<" "<<d->getMinuto()<<" "<<d->getSegundo()<<" "<<d->getDia()<<" "<<d->getMes()<<" "<<d->getAno()<<" ";
                output<<(*j)->isManual();
                j++;
            }
        }else if(dynamic_cast<Visitante*>((*v)[i])!=nullptr){
            d= dynamic_cast<Visitante*>((*v)[i])->getDataInicio();
            output<<d->getHora()<<" "<<d->getMinuto()<<" "<<d->getSegundo()<<" "<<d->getDia()<<" "<<d->getMes()<<" "<<d->getAno()<<" ";
            d= dynamic_cast<Visitante*>((*v)[i])->getDataFim();
            output<<d->getHora()<<" "<<d->getMinuto()<<" "<<d->getSegundo()<<" "<<d->getDia()<<" "<<d->getMes()<<" "<<d->getAno();

        }
        output<<endl;
    }
    output.close();
}