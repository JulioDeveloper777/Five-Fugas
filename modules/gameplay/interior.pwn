#include <YSI_Coding/y_hooks>


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SECONDARY_ATTACK) //(F/Enter)
    {
        cmd_entrar(playerid);
        cmd_sair(playerid);
    }
    return 1;
}

CMD:sair(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1564.1604, 1597.5245, 1003.5000)) //Saida DELEGACIA
    {
        SetPlayerFacingAngle(playerid, 91.2688);
        SetPlayerPos(playerid, 1553.7902, -1675.6311, 16.1953);
        ShowLoadInt(playerid);
    }

    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1127.9659, -1561.3444, -30.2015)) //Saida loja eletronicos magalu
    {
        SetPlayerFacingAngle(playerid, 91.2688);
        SetPlayerPos(playerid, 1128.4916, -1563.2698, 13.5489);
        ShowLoadInt(playerid);
    }
    return 1;
}

CMD:entrar(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1555.5005, -1675.6212, 16.1953)) //Entrada DELEGACIA
    {
        SetPlayerFacingAngle(playerid, 268.0929);
        SetPlayerPos(playerid, 1564.1604, 1597.5245, 1003.5000);
        ShowLoadInt(playerid);
    }

    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1128.4916, -1563.2698, 13.5489)) //Entrada Loja eletronico
    {
        SetPlayerFacingAngle(playerid, 268.0929);
        SetPlayerPos(playerid, 1127.9659, -1561.3444, -30.2015);
        ShowLoadInt(playerid);
    }
    return 1;
}

