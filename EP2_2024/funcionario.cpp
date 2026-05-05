#include "Funcionario.h"
using namespace std;
Funcionario::Funcionario(int id, string nome):Usuario(id,nome){
    this->registros= new vector<Registro*>();
}
Funcionario::Funcionario(int id, string nome, vector<Registro*>* registros):Usuario(id,nome){
    this->registros=registros;

}
Funcionario::~Funcionario(){
    int i;
    for(i=0;i<registros->size();i++){
        delete (*registros)[i];
    }
}
int Funcionario::getHorasTrabalhadas(int mes, int ano){
    int i, soma;
    float horas;
    soma=0;
    for(i=0;i<registros->size()-1;i++){
        if((*registros)[i]->getData()->getMes()==mes && (*registros)[i]->getData()->getAno()==ano && dynamic_cast<Entrada*>((*registros)[i])!=nullptr){
            soma =soma+ (*registros)[i+1]->getData()->diferenca((*registros)[i]->getData());
        }
    }
    horas=soma/3600.0;
    return (int) horas;
}
vector<Registro*>* Funcionario::getRegistros(){
    if(registros->size()>0){
        return registros;
    }
    else{
        return nullptr;
    }
}
bool Funcionario::entrar(Data *d){
    if(ant==nullptr || (dynamic_cast<Saida*>(ant)!=nullptr && d->diferenca(ant->getData())>0)){
        Entrada *e=new Entrada(d,false);
        ant = e;
        registros->push_back(e);
        return true;
    }
    return false;
}
bool Funcionario::sair(Data *d){
    if(ant==nullptr || (dynamic_cast<Entrada*>(ant)!=nullptr && d->diferenca(ant->getData())>0)){
        Saida *e=new Saida(d,false);
        registros->push_back(e);
        ant= e;
        return true;
    }
    return false;
}
bool Funcionario::registrarEntradaManual(Data *d){
    if(ant==nullptr || (dynamic_cast<Saida*>(ant)!=nullptr && d->diferenca(ant->getData())>0)){
        Entrada *e=new Entrada(d,true);
        ant= e;
        registros->push_back(e);
        return true;
    }
    return false;
}
bool Funcionario::registrarSaidaManual(Data *d){
    if(ant==nullptr || (dynamic_cast<Entrada*>(ant)!=nullptr && d->diferenca(ant->getData())>0)){
        Saida *e=new Saida(d,true);
        ant= e;
        registros->push_back(e);
        return true;
    }
    return false;

}