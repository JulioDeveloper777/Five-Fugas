#include <YSI_Coding/y_hooks>


CMD:escolher(playerid, params[])
{
    if (!PlayerToPoint(2.0, playerid, 1634.6958, -1365.4015, 331.4063))
    return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce precisa estar no lobby para usar esse comando!");
    ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "Escolha sua ORG/CORP", "{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar");
    return true;
}


CMD:garagem(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2536.6902, -920.2032, 86.6194))
    {
        if (Bandido[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Garagem_Bandido, DIALOG_STYLE_LIST, "GARAGEM - VEICULOS", "{ff4848}Sultan\n{ff4848}Elegy\n{FF4848}Cheetah\n{FF4848}PCJ-600\n{FF4848}Burrito", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1588.4276, -1692.5383, 6.2188))
    {
        if (Policial[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Garagem_Policial, DIALOG_STYLE_LIST, "GARAGEM - VIATURAS", "{ff4848}Viatura LS\n{ff4848}Viatura SF\n{FF4848}Viatura LV\n{FF4848}Viatura FBI\n{FF4848}Blindado\n{FF4848}Rocam\n{FF4848}Helicoptero", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce nao faz parte da Policia!");
        }
    }
    return 1;
}


CMD:guardarv(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2534.2649, -911.4888, 86.6154))
    {
        if (Bandido[playerid] == 1)
        {
            if (!IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um veículo.");
            }
            SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
            new var0 = GetPlayerVehicleID(playerid);
            DestroyVehicle(var0);
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1585.6941, -1677.2054, 5.8978))
    {
        if (Policial[playerid] == 1)
        {
            if (!IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um veículo.");
            }
            SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
            new var0 = GetPlayerVehicleID(playerid);
            DestroyVehicle(var0);
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!.");
        }
    }
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1550.4474,-1609.7603,13.4933))
    {
        // if (Policial[playerid] == 1)
        // {
        //     if (IsPlayerInAnyVehicle(playerid))
        //     {
        //         if(IsPlayerInVehicle(playerid, 497)) 
        //         {
        //             SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
        //             new var0 = GetPlayerVehicleID(playerid);
        //             DestroyVehicle(var0);
        //         }
        //         return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce so pode guardar helicopteros nessa garagem.");
        //     }
        //     return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um helicoptero.");
        // }
        // else
        // {
        //     return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!.");
        // }
    }
    return 1;
}


CMD:skins(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2547.4292, -926.9975, 84.5811))
    {
        if (Bandido[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Skins_Bandidos, DIALOG_STYLE_LIST, "Skins Bandidos", "{1E90FF}Skins Masculinas\n{FF69B4}Skins Femininas", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1577.6028, 1606.5544, 1003.5000))
    {
        if (Policial[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Skins_Policiais, DIALOG_STYLE_LIST, "Fardas Policiais", "{1E90FF}Fardas Masculinas\n{FF69B4}Fardas Femininas", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!");
        }
    }
    return 1;
}