#ifndef ENTRADA_H
#define ENTRADA_H
#include "Registro.h"
class Entrada: public Registro{
    public:
    Entrada(Data* d); 
    Entrada(Data* d, bool manual); 
    virtual ~Entrada(); 
};
#endif