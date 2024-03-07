#include <YSI_Coding/y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SUBMISSION) // ligarv (2)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                static vehicle, engine, light, alarm, door, hood, trunk, objective;
                vehicle = GetPlayerVehicleID (playerid);
                GetVehicleParamsEx(vehicle, engine, light, alarm, door, hood, trunk, objective);
                SetVehicleParamsEx(vehicle, (engine ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON), light, alarm, door, hood, trunk, objective);
            }
        }
    }
    if(newkeys == KEY_ACTION) // farolv (Control)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(vehicleid, -1, !lights, alarm, doors, bonnet, boot, objective);
            }
        }
    }
    return 1;
}