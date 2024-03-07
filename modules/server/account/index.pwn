#include <YSI_Coding/y_hooks>

hook OnGameModeExit()
{
    DOF2_Exit();
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if (VerificarLogin[playerid] == false)
    {
        Kick(playerid);
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    CarregarTextdrawPlayer(playerid);
    VerificarLogin[playerid] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (VerificarLogin[playerid] == true)
    {
        SalvarDados(playerid);
    }
    return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if (!DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = false;
        VSenha[playerid] = "-1";
        VGenero[playerid] = -1;
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for (new i; i < 10; i++)
        {
            PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
        }
        SelectTextDraw(playerid, -1);
    }
    else if (DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = true;
        VSenha[playerid] = "-1";
        TentativasSenha[playerid] = 0;
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for (new i; i < 10; i++)
        {
            PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
        }
        SelectTextDraw(playerid, -1);
    }
    LimparChat(playerid, 30);
    TogglePlayerSpectating(playerid, 1);
    InterpolateCameraPos(playerid, 3243.553466, -410.080627, 48.884914, 3136.406005, -415.946533, 8.551589, 7000);
    InterpolateCameraLookAt(playerid, 3247.088623, -410.126434, 52.420448, 3141.343017, -416.213256, 9.296744, 8000);
    SetPlayerColor(playerid, 0xFFFF00AA);
    return 1;
}

stock CriarDadosPlayer(playerid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if (!DOF2_FileExists(arquivo))
    {
        DOF2_CreateFile(arquivo);
        DOF2_SetString(arquivo, "Senha", VSenha[playerid]);
        DOF2_SetInt(arquivo, "Dinheiro", 800);
        DOF2_SetInt(arquivo, "Level", 0);
        if (VGenero[playerid] == 1) // HOMEM
        {
            DOF2_SetInt(arquivo, "Skin", 29);
        }
        else if (VGenero[playerid] == 2)   // MULHER
        {
            DOF2_SetInt(arquivo, "Skin", 41);
        }
        DOF2_SetInt(arquivo, "Genero", VGenero[playerid]);
        DOF2_SetInt(arquivo, "Admin", 0);

        DOF2_SetInt(arquivo, "Interior", 0);
        DOF2_SetInt(arquivo, "VirtualW", 0);

        DOF2_SetFloat(arquivo, "VidaHP", 100.0);
        DOF2_SetFloat(arquivo, "ColeteHP", 0.0);

        DOF2_SaveFile();

        VSenha[playerid] = "-1";
        VGenero[playerid] = -1;
        CarregarDadosPlayer(playerid);
    }
    return 1;
}


stock CarregarDadosPlayer(playerid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if (DOF2_FileExists(arquivo))
    {
        GivePlayerMoney(playerid, DOF2_GetInt(arquivo, "Dinheiro"));
        SetPlayerScore(playerid, DOF2_GetInt(arquivo, "Level"));
        info[playerid][Genero] = DOF2_GetInt(arquivo, "Genero");
        SetPlayerSkin(playerid, DOF2_GetInt(arquivo, "Skin"));
        info[playerid][Admin] = DOF2_GetInt(arquivo, "Admin");
        SetPlayerInterior(playerid, DOF2_GetInt(arquivo, "Interior"));
        SetPlayerVirtualWorld(playerid, DOF2_GetInt(arquivo, "VirtualW"));
        SetPlayerHealth(playerid, DOF2_GetFloat(arquivo, "VidaHP"));
        SetPlayerArmour(playerid, DOF2_GetFloat(arquivo, "ColeteHP"));

        TogglePlayerSpectating(playerid, 0);
        VerificarLogin[playerid] = true;
        SetPlayerColor(playerid, 0xFFFFFFAA);

        new string[128];
        format(string, sizeof(string), "{9900FF}[Five] {FFFFFF}Seja bem-Vindo(a) %s!", PlayerName(playerid));
        SendClientMessage(playerid, -1, string);

        SetSpawnInfo(playerid, NO_TEAM, GetPlayerSkin(playerid), 1513.1312,-1362.5790,332.2578, 269.6020, 0, 0, 0, 0, 0, 0); // novo lobby
        SpawnPlayer(playerid);
        ShowLoadInt(playerid);
    }
    return 1;
}

stock SalvarDados(playerid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if (DOF2_FileExists(arquivo))
    {
        DOF2_SetInt(arquivo, "Dinheiro", GetPlayerMoney(playerid));
        DOF2_SetInt(arquivo, "Level", GetPlayerScore(playerid));
        DOF2_SetInt(arquivo, "Genero", info[playerid][Genero]);
        DOF2_SetInt(arquivo, "Skin", GetPlayerSkin(playerid));
        DOF2_SetInt(arquivo, "Admin", info[playerid][Admin]);
        DOF2_SetInt(arquivo, "Interior", GetPlayerInterior(playerid));
        DOF2_SetInt(arquivo, "VirtualW", GetPlayerVirtualWorld(playerid));

        DOF2_SaveFile();
    }
    return 1;
}


forward QuebrarText(playerid);
forward UmSegundo();