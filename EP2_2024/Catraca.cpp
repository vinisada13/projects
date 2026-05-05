    #include "Catraca.h"
    Catraca::Catraca(GerenciadorDeUsuario* g){
        gerenciador =g;
    }
    Catraca::~Catraca(){
    }
    bool Catraca::entrar(int id, Data* d){
        if(gerenciador->getUsuarios()==nullptr){
            return false;
        }
        vector<Usuario*>::iterator i= gerenciador->getUsuarios()->begin();
        while(i!=gerenciador->getUsuarios()->end()){
            if((*i)->getId()==id){
                if(dynamic_cast<Funcionario*>(*i)!=nullptr){
                    return dynamic_cast<Funcionario*>(*i)->entrar(d);
                }
                else if(dynamic_cast<Aluno*>(*i)!=nullptr){
                        return dynamic_cast<Aluno*>(*i)->entrar(d);
                }
                else if(dynamic_cast<Visitante*>(*i)!=nullptr){
                        return dynamic_cast<Visitante*>(*i)->entrar(d);
                }
            }
            i++;
        }
        return false;
    }
    bool Catraca::sair(int id, Data* d){
        if(gerenciador->getUsuarios()==nullptr){
            return false;
        }
        vector<Usuario*>::iterator i= gerenciador->getUsuarios()->begin();
        while(i!=gerenciador->getUsuarios()->end()){
            if((*i)->getId()==id){
                if(dynamic_cast<Funcionario*>(*i)!=nullptr){
                    return dynamic_cast<Funcionario*>(*i)->sair(d);
                }
                else if(dynamic_cast<Aluno*>(*i)!=nullptr){
                        return dynamic_cast<Aluno*>(*i)->sair(d);
                }
                else if(dynamic_cast<Visitante*>(*i)!=nullptr){
                    return dynamic_cast<Visitante*>(*i)->sair(d);
                }
            }
            i++;
        }
        return false;
    }
