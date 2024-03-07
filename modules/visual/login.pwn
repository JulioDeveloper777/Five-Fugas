#include <YSI_Coding/y_hooks>


stock CarregarTextdrawPlayer(playerid)
{
    TextdrawRegistro[0][playerid] = CreatePlayerTextDraw(playerid, 402.000000, 119.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[0][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[0][playerid], 2.679999, 21.999996);
    PlayerTextDrawColor(playerid, TextdrawRegistro[0][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[0][playerid], 471604479);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[0][playerid], 236.000000, 189.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[0][playerid], 0);

    TextdrawRegistro[1][playerid] = CreatePlayerTextDraw(playerid, 382.000000, 172.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[1][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[1][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[1][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[1][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[1][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[1][playerid], 0);

    TextdrawRegistro[2][playerid] = CreatePlayerTextDraw(playerid, 307.000000, 146.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[2][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[2][playerid], 4);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[2][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[2][playerid], 18.000000, -19.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[2][playerid], 0);

    TextdrawRegistro[3][playerid] = CreatePlayerTextDraw(playerid, 305.000000, 159.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[3][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[3][playerid], 4);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[3][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[3][playerid], 22.000000, -11.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[3][playerid], 0);

    TextdrawRegistro[4][playerid] = CreatePlayerTextDraw(playerid, 382.000000, 205.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[4][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[4][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[4][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[4][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[4][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[4][playerid], 0);

    TextdrawRegistro[5][playerid] = CreatePlayerTextDraw(playerid, 353.000000, 251.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[5][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[5][playerid], 0.529999, 2.299999);
    PlayerTextDrawColor(playerid, TextdrawRegistro[5][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[5][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[5][playerid], COR_ROXOCLARO);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[5][playerid], 284.000000, -252.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[5][playerid], 0);

    TextdrawRegistro[6][playerid] = CreatePlayerTextDraw(playerid, 316.000000, 174.000000, "Nome_Sobrenome");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[6][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[6][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[6][playerid], COR_BRANCO);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[6][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[6][playerid], 0);

    TextdrawRegistro[7][playerid] = CreatePlayerTextDraw(playerid, 317.000000, 207.000000, "Senha");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[7][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[7][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[7][playerid], COR_BRANCO);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[7][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[7][playerid], 30.0, 30.0);

    TextdrawRegistro[8][playerid] = CreatePlayerTextDraw(playerid, 318.000000, 255.000000, "Entrar");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[8][playerid], 010101);
    PlayerTextDrawFont(playerid, TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[8][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[8][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[8][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[8][playerid], 30.0, 30.0);

    TextdrawRegistro[9][playerid] = CreatePlayerTextDraw(playerid, 317.000000, 326.000000, "_"); // erro
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[9][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[9][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[9][playerid], 0.250000, 1.300000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[9][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[9][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[9][playerid], 0);
    return 1;
}