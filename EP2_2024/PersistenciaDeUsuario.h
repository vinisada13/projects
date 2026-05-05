#ifndef PERSISTENCIADEUSUARIOS_H
#define PERSISTENCIADEUSUARIOS_H
#include "GerenciadorDeUsuario.h"
#include"Funcionario.h"
#include"Aluno.h"
#include"Visitante.h"
class PersistenciaDeUsuario{
    public:
    PersistenciaDeUsuario(); 
    virtual ~PersistenciaDeUsuario(); 
    vector<Usuario*>* carregar(string arquivo); 
    void salvar(string arquivo, vector<Usuario*>* v);
};
#endif