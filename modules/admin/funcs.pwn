#include <YSI_Coding/y_hooks>

Admin_Permission(playerid, level)
{
	if(PlayerData[playerid][pAdmin] < level)
	{
		Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao possui permissao para utilizar este comando.");
	}
	return true;
}

Admin_Working(playerid)
{
	if (Trabalhando[playerid] < 1)
  {
		Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
		return false;
	}
	return true;
}

Admin_CheckID(playerid, id, bool: perms = false)
{
	if(!IsPlayerConnected(id) || IsPlayerNPC(id))
	{
		Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce inseriu um ID invalido.");
		return false;	
	}

	if (!IsPlayerLogged(id))
	{
		Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Jogador especificado nao esta logado.");
		return false;
	}

	if (perms && PlayerData[playerid][pAdmin] < 4)
	{
		if (!IsPlayerAdmin(playerid) && PlayerData[id][pAdmin] >= PlayerData[playerid][pAdmin] && id != playerid)
		{
			Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Jogador especificado e um admin superior.");
			return false;
		}
	}

	return true;
}


// hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
// {
//   if (!Admin_Permission(playerid, 10)) 
//   {
//     if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
//     {
//       ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Admin - Teleporte", "Deseja teleportar para o local selecionado no mapa?", "Sim", "Nao");
//     }
//   }
//   return 1;
// }