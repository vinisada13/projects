#include "Registro.h"
#include <stdexcept>
using namespace std;
Registro::Registro(Data* d, bool manual){
    this->dr=d;
    this->manual=manual;
    if(d==nullptr){
        throw new invalid_argument("erro: registro ");
    }
}
Registro::Registro(Data*d){
    this->dr=d;
}
bool Registro::isManual(){
    return manual;
}
Registro::~Registro(){
    delete this->dr;
}
Data* Registro::getData(){
    return dr;
}