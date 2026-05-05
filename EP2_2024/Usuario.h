#ifndef Usuario_H
#define Usuario_H
#include "Registro.h"
#include <string>
#include "Entrada.h"
#include "Saida.h"
using namespace std;
class Usuario{
    //protected:
    protected:
    int id;
    string nome;
    Registro* ant=nullptr;
    public:
    Usuario(int id, string nome); 
    virtual ~Usuario()=0; 
    string getNome(); 
    int getId(); 
    bool entrar(Data *d); 
    bool sair(Data *d); 
    bool registrarEntradaManual(Data *d); 
    bool registrarSaidaManual(Data* d); 
};
#endif