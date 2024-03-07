#include <YSI_Coding/y_hooks>

#define PASTA_CONTAS                                                            "Accounts/%s.ini"
#define D_SENHA                                                                 0
#define D_GENERO                                                                1
#define D_ADMINISTRADOR                                                         2

enum pInfo
{
    Senha[20],
    Dinheiro,
    Level,
    Skin,
    Genero,
    Admin,
    Interior,
    VirtualW
};
new info[MAX_PLAYERS][pInfo];
//
new arquivo[128];
new VSenha[MAX_PLAYERS][20];
new VGenero[MAX_PLAYERS];
new TentativasSenha[MAX_PLAYERS];
//
new Trabalhando[MAX_PLAYERS];
new EstaTv[MAX_PLAYERS];
//
new bool:VerificarLogin[MAX_PLAYERS];
new bool:EstaRegistrado[MAX_PLAYERS];
//
new PlayerText:TextdrawRegistro[10][MAX_PLAYERS];