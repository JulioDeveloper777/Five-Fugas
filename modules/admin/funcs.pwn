#include <YSI_Coding/y_hooks>


hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (info[playerid][Admin] < 10) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return Scm(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                new veh = GetPlayerVehicleID(playerid);
                SetVehiclePos(veh, fX, fY, fZ);
            }
            else
            {
                SetPlayerPosFindZ(playerid, fX, fY, fZ);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
            }
        }
    }
    return 1;
}