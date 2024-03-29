#include <YSI_Coding/y_hooks>


// stock SendClientLocalMessage(playerid, color, Float:radius, string[])
// {
// 	new Float:fDist[3];
// 	GetPlayerPos(playerid, fDist[0], fDist[1], fDist[2]);
// 	SetPlayerChatBubble(playerid, string, color, radius, 5000);
// 	foreach(new i: Player)
// 	{
// 		if(GetPlayerDistanceFromPoint(i, fDist[0], fDist[1], fDist[2]) <= radius && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
// 		{
// 			SendClientMessage(i, color, string);
// 		}
// 	}
// }

stock GetSizeNamePlayer(playerid)
{
  new Nick[MAX_PLAYER_NAME];
  GetPlayerName(playerid, Nick, sizeof(Nick));
  return Nick;
}


stock GetPlayerNameEx(playerid)
{
  static pname[MAX_PLAYER_NAME];
  GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
  return pname;
}

stock PlayerName(playerid)
{
  new Nick[MAX_PLAYER_NAME];
  GetPlayerName(playerid, Nick, sizeof(Nick));
  return Nick;
}

// stock Specting(playerid) {
// 	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
// 		TogglePlayerSpectating(playerid, false);
// 		printf("- TogglePlayerSpectating ( DESATIVADO )");
// 	} else{
// 		TogglePlayerSpectating(playerid, true);
// 		printf("- TogglePlayerSpectating ( ATIVADO )");
// 	}
// 	return true;
// }

stock ClearChatPlayer(playerid, linhas)
{
  for(new a = 0; a <= linhas; a++) Scm(playerid, -1, "");
}

stock ClearChatAll(linhas)
{
  for(new a = 0; a <= linhas; a++) SendClientMessageToAll(-1, "");
}

hook OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
  if (!success)
  {
    new string[256];
    format(string, 256, "{9900FF}[Five] {FFFFFF}Comando Invalido.", cmdtext);
    SendClientMessage(playerid, -1, string);
  }
  return 1;
}
