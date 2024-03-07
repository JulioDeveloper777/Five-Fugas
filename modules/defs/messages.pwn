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

stock GetPlayerNome(playerid)
{
  new aname[MAX_PLAYER_NAME];
  GetPlayerName(playerid, aname, sizeof(aname));
  return aname;
}

stock PlayerName(playerid)
{
    new Nick[MAX_PLAYER_NAME];
    GetPlayerName(playerid, Nick, sizeof(Nick));
    return Nick;
}