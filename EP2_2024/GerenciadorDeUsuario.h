#ifndef GERENCIADORDEUSUARIOS_H
#define GERENCIADORDEUSUARIOS_H
#include "Usuario.h"
#include <vector>
class GerenciadorDeUsuario{
    private:
    vector<Usuario*>* usuarios;
    

    public:
    GerenciadorDeUsuario(vector<Usuario*>* usuarios);
    GerenciadorDeUsuario(); 
    virtual ~GerenciadorDeUsuario(); 
    void adicionar(Usuario* u); 
    Usuario* getUsuario(int id); 
    vector<Usuario*>*  getUsuarios(); 
};
#endif