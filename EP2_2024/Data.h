#ifndef Data_H
#define Data_H
#include <iostream>
#include<stdexcept>
class Data{
    int segundo = 0;
    int minuto = 0;
    int hora = 0;
    int dia;
    int mes;
    int ano;

public:
    Data(int hora, int minuto, int segundo, int dia, int mes, int ano);
    virtual ~Data();
    int getHora();
    int getMinuto();
    int getSegundo();
    int getDia();
    int getMes();
    int getAno();

    int diferenca(Data* d);
};
#endif
