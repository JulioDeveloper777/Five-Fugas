Ola me chamo Louzin_DS e hj eu vou fazer meu primeiro tutorial no forum 
espero q gostem
SISTEMA DE ADMIN

bom pra começar devemos colocar uma enum nas informaçoes do player ou seja

enum pInfo
{
     pAdmin
}
new PlayerInfo[MAX_PLAYERS][pInfo];


apos isso voce deve criar uma stock para armazenar o nivel admin do player
para isso crie

stock SAVEADMIN(playerid)
{
     return 1;
}
apos isso crie uma variavel para formatar ela para onde esta armazenada as informaçoes do player e salvar em DOF2

stock SAVEADMIN(playerid)
{
    new file[128];    
    format(file, sizeof(file), Pasta_Contas, PlayerName(playerid))
    return 1;
}
apos isso nos armazenaremos o nivel admin
stock SAVEADMIN(playerid)
{
    new file[128];    
    format(file, sizeof(file), Pasta_Contas, PlayerName(playerid))
    DOF2_SetInt(file, "LevelAdmin", PlayerInfo[playerid][pAdmin]);
    return 1;
}

agora nos vamos criar uma stock para carregar essa informaçao qnd o player entrar
stock Carregaradmin(playerid)
{
    new file[128];    
    format(file, sizeof(file), Pasta_Contas, PlayerName(playerid))
    PlayerInfo[playerid][pAdmin] = DOF2_GetInt(file, "LevelAdmin");
    return 1;
}
agora vamos para a parte de setar o admin no player

CMD:criaradmin(playerid, params[])
{

if(PlayerInfo[playerid][pAdmin] < 3002)
{
SendClientMessage(playerid, COLOR_GRAD1, "Voce nao pode usar esse comando!");
return 1;
}
new para1,level,funcao[21];
if(sscanf(params, "uds[21]", para1, level, funcao))
{
SendClientMessage(playerid, MSG_USER, "Modo Correto: /criaradmin [ID do Player] [Nivel] [Funcao]");
return 1;
}
if(PlayerInfo[playerid][pAdmin] == 3000 && level > 1337)
{
SendClientMessage(playerid, 0xFF0000FF, " voce nao pode criar admin Nivel acima de 1337!");
return true;
}
if(level > 5000)
{
SendClientMessage(playerid, 0xFF0000FF, " nao se pode criar um admin com Nivel maior que 5003");
return true;
}
new letras = strlen(funcao);
if(letras < 1 && letras > 20)
return SendClientMessage(playerid, COLOR_GRAD1, " Voce nao pode usar menos que 1 e nem mais que 20 letras na funcao.");
GetPlayerName(para1, giveplayer, sizeof(giveplayer));
GetPlayerName(playerid, sendername, sizeof(sendername));
if(IsPlayerConnected(para1))
{


new string[MAX_STRING];
if(level == 0)
{
format(string, sizeof(string), "Voce retirou %s de admin.", giveplayer);
SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
format(string, sizeof(string), "Voce foi retirado de admin, pelo admin %s", sendername);
SendClientMessage(para1, COLOR_LIGHTBLUE, string);
PlayerInfo[para1][pAdmin] = 0;
admtrampando[para1] = 0;
SetPlayerToTeamColor(para1);
SetPlayerHealth(para1, 100);
getdate(year, month, day);
gettime(hour,minute,second);
format(string, sizeof(string), "%s retirou o admin de %s", sendername, giveplayer);
return true;
}
format(string, sizeof(string), "Voce foi promovido a Nivel %d de admin,com a Funcao de %s, pelo admin %s", level, PlayerInfo[para1][pFuncao], sendername);
SendClientMessage(para1, COLOR_LIGHTBLUE, string);
format(string, sizeof(string), "[Promocao]: [%s] Foi Promovido Para Nivel [%d] De Admin Por [%s].", giveplayer, level, sendername);
SendClientMessageToAll(COLOR_LIGHTBLUE, string);
PlayerInfo[para1][pAvaliacoes] = 1;
PlayerInfo[para1][pAFinal] = 1;
SetPlayerToTeamColor(para1);
SetPlayerHealth(para1, 99999);
format(string, sizeof(string), "%s deu admin Nivel %s para %s,com a funcao de %s", sendername, level, giveplayer, PlayerInfo[para1][pFuncao]);
PlayerInfo[para1][pAdmin] = level;
}
return 1;
}
ae rapaziada agr e so fazer os comandos so pra admin ex:


pra pegar admin de inicio
CMD:pegaradm(playerid)
{
      PlayerInfo[playerid][pAdmin] = 5000;
       return 1;
}

agr e so ir verificando
EX:
CMD:dargrana(playerid)
{
      if(PlayerInfo[playerid][pAdmin] == 5000)
      {
          executar funçao tal
       }
       else 
       {
             executar tal funçao
        }
} 


E FOI ESSE MEU TUTORIAL ESPERO Q GOSTEM