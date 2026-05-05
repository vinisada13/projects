#ifndef Registro_H
#define Registro_H
#include <iostream>
#include "Data.h"
class Registro{
    protected:
    Data* dr;
    bool manual;
    public:
    virtual ~Registro()=0;
    Registro(Data*d);
    Registro(Data* d, bool manual);
    Data* getData();
    bool isManual();
};
#endif