#include "catraca.h"
#include"PersistenciaDeUsuario.h"
#include<fstream>
#include <string>
/*int main(){
    try{PersistenciaDeUsuario*p=new PersistenciaDeUsuario();
    vector<Usuario*>* uss = new vector<Usuario*>();
    uss= p->carregar("aaa.txt");
    cout<<uss->size()<<endl;
    vector<Usuario*>::iterator i=uss->begin();
    while(i!=uss->end()){
        if(dynamic_cast<Funcionario*>((*i))!=nullptr){
            cout<<"funcionario "<<(*i)->getNome()<<": id "<<(*i)->getId()<<endl<<dynamic_cast<Funcionario*>((*i))->getRegistros()->size()<<" registros"<<endl;
        }
        else if(dynamic_cast<Aluno*>((*i))!=nullptr){
            cout<<"Aluno "<<(*i)->getNome()<<": id "<<(*i)->getId()<<endl;
        }
        else{
            cout<<"visitante "<<(*i)->getNome()<<": id "<<(*i)->getId()<<endl;
        }
        i++;
    }
    p->salvar("aba.txt", uss);
    }catch (logic_error* e){
        cout<<e->what();
        delete e;
    }
}*/
void menu();
int main(){
    menu();
}