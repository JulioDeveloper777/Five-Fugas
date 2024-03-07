#include <YSI_Coding/y_hooks>


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_ESCOLHER_LADO)
    {
        if (response)
        {
            if (listitem == 0)
            {
                Scm(playerid, COR_BRANCO, "{63AFF0}[Five] Policial: {FFFFFF}Voce Virou Policial, Use {9900FF}/ajudapm, {FFFFFF}para ver os comandos!");
                Policial[playerid] = 1;
                Bandido[playerid] = 0;
                SetPlayerSkin(playerid, 285);
                SetPlayerColor(playerid, COR_AZUL);
                SetPlayerPos(playerid, 1551.9346, -1675.5179, 16.0681);
                ShowLoadInt(playerid);
            }
            if (listitem == 1)
            {
                Scm(playerid, COR_BRANCO, "{FB0000}[Five] Bandido: {FFFFFF}Voce Virou Bandido, Use {9900FF}/ajudabandidos, {FFFFFF}para ver os comandos!");
                Bandido[playerid] = 1;
                Policial[playerid] = 0;
                SetPlayerSkin(playerid, 19);
                SetPlayerColor(playerid, COR_MARROM);
                SetPlayerPos(playerid, 2583.4858, -873.5188, 84.0401);
                ShowLoadInt(playerid);
            }
        }
    }
    if (dialogid == Garagem_Policial)
    {
        if (response)
        {
            if (listitem == 0)
            {
                new VTR_LS;
                VTR_LS = CreateVehicle(596, 1601.8549, -1704.2041, 5.5705, 89.6262, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_LS, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 1)
            {
                new VTR_SF;
                VTR_SF = CreateVehicle(597, 1600.9486, -1700.1726, 5.5705, 90.1010, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_SF, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 2)
            {
                new VTR_LV;
                VTR_LV = CreateVehicle(598, 1601.2448, -1696.0468, 5.5700, 90.6570, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_LV, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 3)
            {
                new VTR_FBI;
                VTR_FBI = CreateVehicle(490, 1601.0087, -1683.9307, 6.0225, 89.8976, 1, 1, 0); // 0, -1, 0
                PutPlayerInVehicle(playerid, VTR_FBI, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 4)
            {
                new Blindado;
                Blindado = CreateVehicle(427, 1601.6797, -1692.0331, 5.5701, 89.7597, 1, 1, 0);
                PutPlayerInVehicle(playerid, Blindado, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 5)
            {
                new Rocam;
                Rocam = CreateVehicle(523, 1601.8209, -1687.7991, 5.5705, 91.5505, 1, 1, 0);
                PutPlayerInVehicle(playerid, Rocam, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 6)
            {
                new Helicoptero;
                Helicoptero = CreateVehicle(497, 1550.4500, -1609.7612, 13.5594, 272.5140, 1, 1, 0);
                PutPlayerInVehicle(playerid, Helicoptero, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
        }
    }
    if (dialogid == Garagem_Bandido)
    {
        if (response)
        {
            if (listitem == 0)
            {
                new CarSultan;
                CarSultan = CreateVehicle(560, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarSultan, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 1)
            {
                new CarElegy;
                CarElegy = CreateVehicle(562, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarElegy, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 2)
            {
                new CarCheetah;
                CarCheetah = CreateVehicle(415, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarCheetah, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 3)
            {
                new MotoPCJ;
                MotoPCJ = CreateVehicle(461, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, MotoPCJ, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 4)
            {
                new VanBurrito;
                VanBurrito = CreateVehicle(482, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, VanBurrito, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
        }
    }
    if (dialogid == Skins_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                ShowPlayerDialog(playerid, SkinsMasculinas_Bandidos, DIALOG_STYLE_LIST, "Skins Masculinas", "{1E90FF}Skin 01\n{1E90FF}Skin 02\n{1E90FF}Skin 03\n{1E90FF}Skin 04\n{1E90FF}Skin 05", "Selecionar", "Fechar");
            }
            if (listitem == 1)
            {
                ShowPlayerDialog(playerid, SkinsFemininas_Bandidos, DIALOG_STYLE_LIST, "Skins Femininas", "{FF69B4}Skin 01\n{FF69B4}Skin 02\n{FF69B4}Skin 03\n{FF69B4}Skin 04\n{FF69B4}Skin 05", "Selecionar", "Fechar");
            }
        }
    }
    if (dialogid == SkinsMasculinas_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 115);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 01 Selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 293);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 02 Selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 123);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 03 Selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 230);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 04 Selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 292);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 05 Selecionada!");
            }
        }
    }
    if (dialogid == SkinsFemininas_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 298);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 01 Selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 193);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 02 Selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 169);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 03 Selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 55);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 04 Selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 12);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 05 Selecionada!");
            }
        }
    }
    if (dialogid == Skins_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                ShowPlayerDialog(playerid, 72, 2, "Fardas Masculinas", "{1E90FF}Farda 01\n{1E90FF}Farda 02\n{1E90FF}Farda 03\n{1E90FF}Farda 04\n{1E90FF}Farda 05", "Selecionar", "Fechar");
            }
            if (listitem == 1)
            {
                ShowPlayerDialog(playerid, 73, 2, "Fardas Femininas", "{FF69B4}Farda 01\n{FF69B4}Farda 02", "Selecionar", "Fechar");
            }
        }
    }
    if (dialogid == SkinsMasculinas_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 280);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 01 selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 281);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 02 selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 285);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 03 selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 284);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 04 selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 286);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 05 selecionada!");
            }
        }
    }
    if (dialogid == SkinsFemininas_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 306);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda feminina 01 selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 309);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda feminina 02 selecionada!");
            }
        }
    }
    return 1;
}