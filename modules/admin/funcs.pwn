#include <YSI_Coding/y_hooks>

Admin_Permission(playerid, level)
{
	if(PlayerData[playerid][pAdmin] < level)
	{
		Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao possui permissao para utilizar este comando.");
		return false;
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