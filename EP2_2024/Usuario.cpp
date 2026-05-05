#include "Usuario.h"
Usuario::Usuario(int id, string nome){
    int i;
    this->id=id;
    this->nome=nome;
}
int Usuario::getId(){
    return id;
}
string Usuario::getNome(){
    return nome;
}
bool Usuario::entrar(Data *d){
    if(ant==nullptr){
        ant=new Entrada(d,false);
        return true;
    }
    if(dynamic_cast<Saida*>(ant)!=nullptr && d->diferenca(ant->getData())<0){
        ant=new Entrada(d,false);
        return true;
    }

    return false;
} 
bool Usuario::sair(Data *d){
    if(ant==nullptr){
        ant=new Saida(d,false);
        return true;
    }
    if((dynamic_cast<Entrada*>(ant)!=nullptr) && d->diferenca(ant->getData())<0){
        ant=new Saida(d,false);
        return true;
    }
    return false;
}
bool Usuario::registrarEntradaManual(Data *d){
    if(ant==nullptr){
        ant=new Entrada(d,true);
        return true;
    }
    if(dynamic_cast<Saida*>(ant)!=nullptr && d->diferenca(ant->getData())>0){
        ant=new Entrada(d,true);
        return true;
    }

    return false;
} 
bool Usuario::registrarSaidaManual(Data* d){
    if(ant==nullptr){
        ant=new Saida(d,true);
        return true;
    }
    if(dynamic_cast<Entrada*>(ant)!=nullptr && d->diferenca(ant->getData())>0){
        ant=new Saida(d,true);
        return true;
    }
    return false;
}

Usuario::~Usuario(){
}
