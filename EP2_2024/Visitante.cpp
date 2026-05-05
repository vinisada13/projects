#include "Visitante.h"
Visitante::Visitante(int id, string nome, Data* inicio, Data* fim):Usuario(id,nome){
    if(inicio==nullptr || fim==nullptr || fim->diferenca(inicio)<0){
        throw new logic_error("data invalida visitate");
    }
    this->inicio=inicio;
    this->fim=fim;
}
Visitante::~Visitante(){
    delete fim;
    delete inicio;
}
Data* Visitante::getDataInicio(){
    return inicio;
}
Data* Visitante::getDataFim(){
    return fim;
}
bool Visitante::entrar(Data* d){
    if(d->diferenca(inicio)>=0 && d->diferenca(fim)<=0){
        return true;
    }
    return false;
}
bool Visitante::sair(Data* d){
    if(d->diferenca(inicio)>=0 && d->diferenca(fim)<=0){
        return true;
    }
    return false;
}
bool Visitante::registrarEntradaManual(Data *d){
    return false;
} 
bool Visitante::registrarSaidaManual(Data* d){
    return false;
}