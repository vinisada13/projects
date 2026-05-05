#include "Data.h"
#include <ctime>
using namespace std;
Data::Data(int hora, int minuto, int segundo, int dia, int mes, int ano){
    this->segundo = segundo;
    this->minuto = minuto;
    this->hora = hora;
    this->dia= dia;
    this->mes = mes;
    this->ano = ano;
    if(hora>23 || hora<0 || minuto >59 || minuto <0 || segundo >59 || segundo<0 || dia<1 || dia>31 || mes<0 || mes>12){
        throw new logic_error("erro: data");
    }
}
int Data::getHora(){
    return hora;
}
int Data::getMinuto(){
    return minuto;
}
int Data::getSegundo(){
    return segundo;
}
int Data::getDia(){
    return dia;
}
int Data::getMes(){
    return mes;
}
int Data::getAno(){
    return ano;
}
int Data::diferenca(Data* d){
    tm* data1= new tm;
    data1->tm_hour = d->getHora(); 
    data1->tm_min = d->getMinuto(); 
    data1->tm_sec = d->getSegundo(); 
    data1->tm_isdst = 0; 
    data1->tm_mday = d->getDia(); 
    data1->tm_mon = d->getMes() - 1; 
    data1->tm_year = d->getAno()- 1900;
    tm* presente= new tm;
    presente->tm_hour = this->getHora(); 
    presente->tm_min = this->getMinuto(); 
    presente->tm_sec = this->getSegundo(); 
    presente->tm_isdst = 0; 
    presente->tm_mday = this->getDia(); 
    presente->tm_mon = this->getMes() - 1; 
    presente->tm_year = this->getAno()- 1900;
    time_t t1=mktime(data1);
    time_t tpre=mktime(presente);
    return (int)difftime(tpre,t1);
}
Data::~Data(){

}