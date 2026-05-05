#include "Aluno.h"
Aluno::Aluno(int id, string nome):Usuario(id,nome){

}
Aluno::~Aluno(){

}
void Aluno::setHorarioFim(int hora, int minuto){
    if(hora>23 || hora<HORARIO_INICIO){
        throw new logic_error("erro: aluno");
    }
    if(minuto>59 || minuto<0){
        throw new logic_error("erro: aluno ");
    }
    horaf=hora;
    minf=minuto;
}
int Aluno::getHoraFim(){
    return horaf;
}
int Aluno::getMinutoFim(){
    return minf;
}
bool Aluno::entrar(Data* d){
    if(d->getHora()>=HORARIO_INICIO){
        if(d->getHora()<horaf){
            return true;
        }else if(d->getHora()==horaf){
            if(d->getMinuto()<minf){
                return true;
            }
        }
    }
    return false;
}
bool Aluno::sair(Data* d){
        return true;
}
bool Aluno::registrarEntradaManual(Data *d){
    return false;
} 
bool Aluno::registrarSaidaManual(Data* d){
    return true;
}
int Aluno::horaf=22;
int Aluno::minf=59;