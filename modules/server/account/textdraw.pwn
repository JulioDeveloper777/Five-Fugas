#include <YSI_Coding/y_hooks>

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if (playertextid != INVALID_PLAYER_TEXT_DRAW)
    {
        if (playertextid == TextdrawRegistro[7][playerid]) // Botao Senha
        {
            if (EstaRegistrado[playerid] == false)
            {
                CancelSelectTextDraw(playerid);
                ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo uma senha para registrar-se.", "Pronto", "Voltar");
            }
            if (EstaRegistrado[playerid] == true)
            {
                CancelSelectTextDraw(playerid);
                ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo sua senha para logar no servidor.", "Pronto", "Voltar");
            }
        }
        if (playertextid == TextdrawRegistro[8][playerid])
        {
            if (EstaRegistrado[playerid] == false)
            {
                if(new_strcmp(VSenha[playerid], "-1"))
                {
                    return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
                }
                else
                {
                    ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");

                    for (new i; i < 10; i++)
                    {
                        PlayerTextDrawHide(playerid, TextdrawRegistro[i][playerid]);
                    }
                    CancelSelectTextDraw(playerid);
                }
            }
            else if (EstaRegistrado[playerid] == true)
            {
                if (new_strcmp(VSenha[playerid], "-1"))
                {
                    return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
                }
                format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
                if (!new_strcmp(VSenha[playerid], DOF2_GetString(arquivo, "Senha")))
                {
                    if (TentativasSenha[playerid] < 3)
                    {
                        new string[120];
                        TentativasSenha[playerid]++;
                        format(string, sizeof(string), "~r~ERRO: ~w~Voce informou sua senha incorretamente, informe sua senha corretamente (%02d/03).", TentativasSenha[playerid]);
                        MensagemText(playerid, string);
                    }
                    else
                    {
                        Kick(playerid);
                    }
                }
                else
                {
                    for (new i; i < 10; i++)
                    {
                        PlayerTextDrawHide(playerid, TextdrawRegistro[i][playerid]);
                    }
                    CancelSelectTextDraw(playerid);
                    CarregarDadosPlayer(playerid);
                }
            }
        }
    }
    return 1;
}

public QuebrarText(playerid)
{
    return PlayerTextDrawHide(playerid, TextdrawRegistro[9][playerid]);
}

stock MensagemText(playerid, const text[])
{
    PlayerTextDrawSetString(playerid, TextdrawRegistro[9][playerid], text);
    PlayerTextDrawShow(playerid, TextdrawRegistro[9][playerid]);
    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
    SelectTextDraw(playerid, 0xFFFFFFAA);
    return SetTimerEx("QuebrarText", 8000, false, "i", playerid);
}
