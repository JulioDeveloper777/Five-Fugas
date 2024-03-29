#include <YSI_Coding/y_hooks>


// #define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
new Engine[MAX_VEHICLES];
forward EngineTimer(playerid);

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(Engine[vehicleid] == 0)
        {
            TogglePlayerControllable(playerid, 0);
            SendClientMessage(playerid, -1, "Press (Shift) or Type (/engine) to start the vehicles engine");
        }
        else if(Engine[vehicleid] == 1)
        {
            SendClientMessage(playerid, -1, "Engine Running...");
        }
    }
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid))
    {
        if(Engine[vehicleid] == 0)
        {
            if(newkeys & KEY_SECONDARY_ATTACK)
            {
                RemovePlayerFromVehicle(playerid);
                TogglePlayerControllable(playerid, 1);
            }
            else if(newkeys & KEY_JUMP)
            {
                SendClientMessage(playerid, -1, "Engine Starting...");
                SetTimerEx("EngineTimer", 2000, 0, "i", playerid);
            }
        }
    }
    // if(newkeys == KEY_SUBMISSION) // ligarv (2)
    // {
    //     if(IsPlayerInAnyVehicle(playerid))
    //     {
    //         if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    //         {
    //             static vehicle, engine, light, alarm, door, hood, trunk, objective;
    //             vehicle = GetPlayerVehicleID (playerid);
    //             GetVehicleParamsEx(vehicle, engine, light, alarm, door, hood, trunk, objective);
    //             SetVehicleParamsEx(vehicle, (engine ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON), light, alarm, door, hood, trunk, objective);
    //         }
    //     }
    // }
    // if(newkeys == KEY_ACTION) // farolv (Control)
    // {
    //     if(IsPlayerInAnyVehicle(playerid))
    //     {
    //         if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    //         {
    //             new vehicleid = GetPlayerVehicleID(playerid);
    //             new engine, lights, alarm, doors, bonnet, boot, objective;
    //             GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    //             SetVehicleParamsEx(vehicleid, -1, !lights, alarm, doors, bonnet, boot, objective);
    //         }
    //     }
    // }
    return 1;
}


stock EngineTimer(playerid)
{
    new rand = random(2);
	if(rand == 0)
	{
        SendClientMessage(playerid, -1, "Engine Started...");
        SendClientMessage(playerid, -1, "To turn off the vehicle, Type (/engine)");
        new vehicleid = GetPlayerVehicleID(playerid);
        Engine[vehicleid] = 1;
        TogglePlayerControllable(playerid, 1);
	}
	if(rand == 1)
	{
        SendClientMessage(playerid, -1, "Engine Failed...");
        SendClientMessage(playerid, -1, "Try Again");
	}
}

CMD:engine(playerid, params[])
{
    #pragma unused params
    new vehicleid = GetPlayerVehicleID(playerid);
    if(Engine[vehicleid] == 0)
    {
        SendClientMessage(playerid, -1, "Engine Starting...");
        SetTimerEx("EngineTimer", 2000, 0, "i", playerid);
    }
    else if(Engine[vehicleid] == 1)
    {
        Engine[vehicleid] = 0;
        SendClientMessage(playerid, -1, "Engine Stopped...");
        SendClientMessage(playerid, -1, "To exit the vehicle press (F Key) Or (Enter)");
        SendClientMessage(playerid, -1, "Press (Shift) or Type (/engine) to start the vehicles engine");
        TogglePlayerControllable(playerid,0);
    }
    return 1;
}