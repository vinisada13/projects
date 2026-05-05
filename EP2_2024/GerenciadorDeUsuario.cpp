#include "GerenciadorDeUsuario.h"
GerenciadorDeUsuario::GerenciadorDeUsuario(vector<Usuario*>* usuarios){
    this->usuarios=usuarios;
}
GerenciadorDeUsuario::GerenciadorDeUsuario(){
    this->usuarios=new vector<Usuario*>;
}
GerenciadorDeUsuario::~GerenciadorDeUsuario(){
    int i;
    while(usuarios->empty()==false){
        usuarios->pop_back();
    }
    delete usuarios;
}
void GerenciadorDeUsuario::adicionar(Usuario* u){
    vector<Usuario*>::iterator i= usuarios->begin();
    while(i!=usuarios->end()){
        if((*i)->getId()==u->getId()){
            throw new invalid_argument("usuario ja existe");
        }
        i++;
    }
    usuarios->push_back(u);
    return;

}
Usuario* GerenciadorDeUsuario::getUsuario(int id){
    int i,b;
    b=usuarios->size();
    for(i=0;i<b;i++){
        if((*usuarios)[i]->getId()==id){
            return (*usuarios)[i];
        }
    }
    return nullptr;
}
vector<Usuario*>* GerenciadorDeUsuario::getUsuarios(){
    if(usuarios->size()==0){
        return nullptr;
    }
    return usuarios;
}
