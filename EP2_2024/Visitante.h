#ifndef VISITANTE_H
#define VISITANTE_H
#include "Usuario.h"
class Visitante:public Usuario{
    private:
    Data* inicio;
    Data* fim;
    public:
    Visitante(int id, string nome, Data* inicio, Data* fim); 
    virtual ~Visitante(); 
    Data* getDataInicio(); 
    Data* getDataFim();
    bool entrar(Data *d);
    bool sair(Data *d);
    bool registrarEntradaManual(Data *d); 
    bool registrarSaidaManual(Data* d);
};
#endif