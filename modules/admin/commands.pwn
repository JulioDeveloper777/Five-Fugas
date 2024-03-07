#include <YSI_Coding/y_hooks>


CMD:developer(playerid)
{
    if (!DOF2_FileExists(arquivo))
    {
        DOF2_CreateFile(arquivo); // caso o nome dele nao esteja na pasta administradores.
    }
    if (info[playerid][Admin] > 5) return Scm(playerid, -1, "");

    DOF2_SetInt(arquivo, "Admin", 10); // irá setar na linha Admin o valor do nível desejado.
    DOF2_SaveFile(); // salva e fecha o arquivo.
    info[playerid][Admin] = 10;
    Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Correct!");
    return 1;
}
CMD:comandosadm(playerid, params[])
{
    new Str[1000];
    if (info[playerid][Admin] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            strcat(Str, "{FFFFFF}/trabalhar, /clear, /sethora, /setclima, /dv, /car, /setmoney \n");
            strcat(Str, "{FFFFFF}/setskin, /aviso, /trazer, /tvoff, /tv, /ir, /setvida, /pintar  \n");
            strcat(Str, "{FFFFFF}/setarma, /daradmin, /fix, /trabalhar, /esc, /virar\n");
            strcat(Str, "{FFFFFF}                                TELEPORTES                               \n");
            strcat(Str, "{FFFFFF}/lobby     |   /favela   |  /dp     |    /ls    | /sf | /lv  | /cachoeira\n");
            ShowPlayerDialog(playerid, D_ADMINISTRADOR, DIALOG_STYLE_MSGBOX, "Comandos Admin - Five Fugas", Str, "-", "");
        }
    }
    return 1;
}

CMD:setmoney(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, valor;
            if (sscanf(params, "ud", id, valor))
                return SendClientMessage(playerid, 0xBFC0C2FF, "{9900FF}[Five] {FFFFFF}* Use: /setmoney [ID] [Valor]");
            GivePlayerMoney(id, valor);
        }
    }
    return 1;
}

CMD:pintar(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new cor1, cor2;
            new vehicleid = GetPlayerVehicleID(playerid);
            if(sscanf(params, "ii", cor1, cor2)) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /pintar [COR1] [COR2]");
            ChangeVehicleColor(vehicleid, cor1, cor2);
        }
    }
    return 1;
}

CMD:virar(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                new currentveh;
                new Float:angle;
                currentveh = GetPlayerVehicleID(playerid);
                GetVehicleZAngle(currentveh, angle);
                SetVehicleZAngle(currentveh, angle);
            }
        }
    }
    return 1;
}

CMD:setvida(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, vida, string[100], str[100];
            if (sscanf(params, "ii", id, vida)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setvida [id] [vida]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce setou %d de vida no ID: %d", vida, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce recebeu %d de vida do Admin", vida);
            SetPlayerHealth(id, vida);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

CMD:daradmin(playerid, params[])
{
    new id, adm, funcao[999], str[999];
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "dds", id, adm, funcao)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /admin0 [ID] [NIVEL] [FUNCAO].");
            format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu administrador {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF} Para {FFFFFF}{F0E68C}%s(%d){FFFFFF}{FFFFFF}.", adm, funcao, PlayerName(id), id);
            Scm(playerid, -1, str);
            format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu admin nivel {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF}.", PlayerName(playerid), playerid, adm, funcao);
            Scm(id, -1, str);
            format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(id));
            if (DOF2_FileExists(arquivo))
            {
                info[id][Admin] = adm;
                DOF2_SetInt(arquivo, "Admin", adm);
                DOF2_SetString(arquivo, "Funcao", funcao);
                DOF2_SaveFile();
            }
        }
    }
    return 1;
}
CMD:clear(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            LimparChat(playerid, 30);
        }
    }
    return 1;
}
CMD:sethora(playerid, params[])
{
    new hora;
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", hora)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /sethora [HORA].");
            SetWorldTime(hora);
        }
    }
    return 1;
}

CMD:setclima(playerid, params[])
{
    new clima;
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", clima)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setclima [CLIMA].");
            SetWeather(clima);
        }
    }
    return 1;
}

CMD:car(playerid, const params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            static PlayerVehicle, IDVehicle, Color[2], Float:Pos[4];

            if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce ja esta em um veiculo.");
            if(sscanf(params, "k<vehicle>dd", IDVehicle, Color[0], Color[1])) return SendClientMessage(playerid, -1, "Aviso: Use {00FFFF}/car [ID/NOME][cor1][cor2]");
            if(IDVehicle < 400 || IDVehicle > 611) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}ID Invalido.");
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
            GetPlayerFacingAngle(playerid, Pos[3]);
            PlayerVehicle = CreateVehicle(IDVehicle, Pos[0], Pos[1], Pos[2], Pos[3], Color[0], Color[1], -1);
            SetVehicleVirtualWorld(PlayerVehicle, GetPlayerVirtualWorld(playerid));
            PutPlayerInVehicle(playerid, PlayerVehicle, 0);
        }
    }
    return 1;   
}


CMD:trabalhar(playerid, params[])
{
    new str[999];
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] > 0)
        {
            Trabalhando[playerid] = 0;
            SetPlayerHealth(playerid, 100);
            SetPlayerArmour(playerid, 0);
            SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
            format(str, sizeof(str), "{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Jogando.", PlayerName(playerid), playerid);
            SendClientMessageToAll(-1, str);
        }
        else
        {
            Trabalhando[playerid] = 1;
            SetPlayerHealth(playerid, 99999);
            SetPlayerArmour(playerid, 99999);
            SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
            format(str, sizeof(str), "{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Trabalhando.", PlayerName(playerid), playerid);
            SendClientMessageToAll(-1, str);
        }
    }
    return 1;
}
CMD:setskin(playerid, params[])
{
    new ID, SKIN, str[999];
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "dd", ID, SKIN)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setskin [ID] [SKIN]");
            {
                format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu skin {FFFFFF}%d{FFFFFF} Para {9900FF}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
                Scm(playerid, -1, str);
                format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu Skin {9900FF}%d{FFFFFF}.", PlayerName(playerid), playerid, SKIN);
                Scm(ID, -1, str);
                format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(ID));
                if (DOF2_FileExists(arquivo))
                {
                    SetPlayerSkin(ID, SKIN);
                    DOF2_SetInt(arquivo, "Skin", SKIN);
                    DOF2_SaveFile();
                }
            }
        }
    }
    return 1;
}
CMD:dv(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            DestroyVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:fix(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            RepairVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}

CMD:aviso(playerid, params[]) {
    new aviso[100], string[500];
    if(info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "s", aviso)) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /aviso [TEXTO]");
            {
                SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
                format(string, 500, "{FFFFFF}Admin {9900FF}%s(%d){FFFFFF}{FFFFFF}: %s!", PlayerName(playerid), playerid, aviso);
                SendClientMessageToAll(-1, string);
            }
        }
    }
    return 1;
}

CMD:av(playerid, params[]){
    new msg, str[500];
    if(sscanf(params, "s", msg)){
        return SendClientMessage(playerid, -1, "Use /av [mensagem]");
    }
    else{
        format(str, sizeof(str), "{FF00FF}| AVISO | %s[%d] diz: {FFFF00}%s", PlayerName(playerid), playerid, msg);
        SendClientMessageToAll(-1, str);
    }
    return 1;
}

CMD:tv(playerid, params[])
{
    new id;
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if (EstaTv[playerid] == 0)
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "i", id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use /tv [ID]");
            if (id == playerid) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao pode assistir!");
            if (!IsPlayerConnected(id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Para parar de assistir use /tvoff.");
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectatePlayer(playerid, id);
            PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
            EstaTv[playerid] = 1;
        }
    }
    else
    {
        Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce ja esta tv em alguem, Use: /tvoff");
    }
    return 1;
}
CMD:tvoff(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if (EstaTv[playerid] == 1)
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            TogglePlayerSpectating(playerid, 0);
            PlayerSpectatePlayer(playerid, playerid);
            PlayerSpectateVehicle(playerid, GetPlayerVehicleID(playerid));
            EstaTv[playerid] = 0;
        }
    }
    else
    {
        Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta tv em alguem.");
    }
    return 1;
}
CMD:ir(playerid, params[])
{
    new id, Float:PedPos[3], string[999];
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /ir [ID].");
            if (!IsPlayerConnected(id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            GetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "{9900FF}[Five] {FFFFFF}Voce foi ate o player {9900FF}%s{FFFFFF}.", PlayerName(id));
            Scm(playerid, -1, string);
        }
    }
    return 1;
}
CMD:trazer(playerid, params[])
{
    new id, Float:PedPos[3], string[999];
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /trazer [ID].");
            if (!IsPlayerConnected(id)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            GetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "{9900FF}[Five] {FFFFFF}O administrador trouxe o Player {9900FF}%s{FFFFFF}.", PlayerName(id));
            Scm(playerid, -1, string);
        }
    }
    return 1;
}

CMD:setarma(playerid, params[])
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, arma, municao, string[100], str[100];
            if (sscanf(params, "iii", id, arma, municao)) return SendClientMessage(playerid, COR_AMARELO, "{9900FF}[Five] {FFFFFF}Use: /setarma [id] [arma] [municao]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce Setou a Arma: %d Com: %d de municao para o id: %d", arma, municao, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce Recebeu a Arma: %d Com: %d de Municao", arma, municao);
            GivePlayerWeapon(id, arma, municao);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

// CMD:esc(playerid, params[])
// {
//     if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
//     {
//         if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
//         {
//             ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "(ADMIN) Escolha sua ORG/CORP", "{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar");
//         }
//     }
//     return true;
// }

//TELEPORTES
CMD:ls(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LS.");
            SetPlayerPos(playerid, 1479.7734, -1706.5443, 14.0469);
        }
    }
    return 1;
}
CMD:lv(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 1569.0677, 1397.1111, 10.8460);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LV.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}
CMD:sf(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, -1988.3597, 143.4470, 27.5391);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para SF.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}


CMD:favela(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 2530.9797, -939.0609, 83.4220);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Favela");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:dp(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 1579.5828, -1607.0725, 13.3828);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Delegacia de LS.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:lobby(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 1513.1312,-1362.5790,332.2578);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para o Lobby!");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:cachoeira(playerid)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 3115.7041, -352.2107, 7.9271);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a cachoeira!");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}