#include <YSI_Coding/y_hooks>

new PlayerText:VisualLogin[MAX_PLAYERS][18];

stock LoadLoginTextDraw(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;
		
	VisualLogin[playerid][0] = CreatePlayerTextDraw(playerid, 92.000000, -4.000000, "_");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][0], 0.600000, 50.450004);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][0], 333.500000, 187.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][0], 2);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][0], 0);

	VisualLogin[playerid][1] = CreatePlayerTextDraw(playerid, 24.000000, 87.000000, "Bem-vindo,");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][1], 0.220833, 1.600000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][1], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][1], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][1], 0);

	VisualLogin[playerid][2] = CreatePlayerTextDraw(playerid, 24.000000, 100.000000, "Nome_Sobrenome");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][2], 0.212500, 1.700000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][2], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][2], 0);

	VisualLogin[playerid][3] = CreatePlayerTextDraw(playerid, 22.000000, 150.000000, "CONTAS REGISTRADAS");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][3], 0.120833, 0.899999);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][3], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][3], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][3], 0);

	VisualLogin[playerid][4] = CreatePlayerTextDraw(playerid, 22.000000, 159.000000, "950");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][4], 0.262499, 1.299998);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][4], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][4], 0);

	VisualLogin[playerid][5] = CreatePlayerTextDraw(playerid, 89.000000, 150.000000, "PERSONAGENS CRIADOS");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][5], 0.120833, 0.899999);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][5], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][5], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][5], 0);

	VisualLogin[playerid][6] = CreatePlayerTextDraw(playerid, 88.000000, 159.000000, "4899");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][6], 0.258332, 1.299998);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][6], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][6], 0);

	VisualLogin[playerid][7] = CreatePlayerTextDraw(playerid, 22.000000, 199.000000, "LOGINS HOJE");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][7] , 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][7] , 0.120833, 0.899999);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][7] , 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][7] , 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][7] , 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][7] , 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][7] , 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][7] , 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][7] , 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][7] , 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][7] , 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][7] , 0);

	VisualLogin[playerid][8] = CreatePlayerTextDraw(playerid, 22.000000, 208.000000, "100");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][8] , 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][8] , 0.262499, 1.350000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][8] , 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][8] , 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][8] , 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][8] , 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][8] , -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][8] , 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][8] , 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][8] , 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][8] , 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][8] , 0);

	VisualLogin[playerid][9] = CreatePlayerTextDraw(playerid, 89.000000, 199.000000, "PLAYERS ONLINE");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][9] , 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][9] , 0.120833, 0.899999);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][9] , 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][9] , 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][9] , 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][9] , 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][9] , 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][9] , 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][9] , 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][9] , 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][9] , 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][9] , 0);

	VisualLogin[playerid][10] = CreatePlayerTextDraw(playerid, 88.000000, 208.000000, "50");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][10] , 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][10] , 0.262499, 1.350000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][10] , 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][10] , 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][10] , 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][10] , 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][10] , -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][10] , 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][10] , 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][10] , 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][10] , 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][10] , 0);

	VisualLogin[playerid][11] = CreatePlayerTextDraw(playerid, 88.000000, 254.000000, "_");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][11] , 0.600000, -0.249990);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][11] , 315.000000, 127.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][11] , 1);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][11] , 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][11] , 2);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][11] , 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][11], 1296911871);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][11], 0);

	VisualLogin[playerid][12] = CreatePlayerTextDraw(playerid, 23.000000, 264.000000, "Seja bem-vindo ao Underground Roleplay, Clique");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][12], 0.162496, 0.800000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][12], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][12], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][12], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][12], 0);

	VisualLogin[playerid][13] = CreatePlayerTextDraw(playerid, 25.000000, 272.000000, "no botao abaixo para selecionar um personagem:");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][13], 0.154164, 0.850000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][13], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][13], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][13], 0);

	VisualLogin[playerid][14] = CreatePlayerTextDraw(playerid, 91.000000, 303.000000, "_");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][14], 0.600000, 2.550002);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][14], 292.500000, 132.500000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][14], 2);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][14], 1097458175);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][14], 0);

	VisualLogin[playerid][15] = CreatePlayerTextDraw(playerid, 66.000000, 308.000000, "ENTRAR >");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][15], 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][15], 0.224996, 1.350000);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][15], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][15], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][15], -16776961);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][15], -1962934222);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][15], 1);

	VisualLogin[playerid][16] = CreatePlayerTextDraw(playerid, 110.000000, 336.000000, "RECUPERAR CONTA");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][16], 0.158328, 0.899999);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][16], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][16], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][16], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][16], 1);

	VisualLogin[playerid][17] = CreatePlayerTextDraw(playerid, 8.000000, 432.000000, "SERVIDOR 1");
	PlayerTextDrawFont(playerid, VisualLogin[playerid][17], 2);
	PlayerTextDrawLetterSize(playerid, VisualLogin[playerid][17], 0.149995, 1.049998);
	PlayerTextDrawTextSize(playerid, VisualLogin[playerid][17], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, VisualLogin[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, VisualLogin[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, VisualLogin[playerid][17], 1);
	PlayerTextDrawColor(playerid, VisualLogin[playerid][17], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, VisualLogin[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, VisualLogin[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, VisualLogin[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, VisualLogin[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, VisualLogin[playerid][17], 0);
	
	for (new i = 0; i < sizeof VisualLogin[]; i++)
  {
		if (VisualLogin[playerid][i] == PlayerText:INVALID_TEXT_DRAW)
			continue;
        
        PlayerTextDrawShow(playerid, VisualLogin[playerid][i]);
	}
	SelectTextDraw(playerid, 0x878787FF);
	TogglePlayerSpectating(playerid, 1);
	PlayerTextDrawSetString(playerid, VisualLogin[playerid][2], PlayerName(playerid));
	return 1;
}

stock UnloadLoginTextDraw(playerid)
{
	for (new i = 0; i < sizeof VisualLogin[]; i++)
  {
		if (VisualLogin[playerid][i] == PlayerText:INVALID_TEXT_DRAW)
			continue;
        
        PlayerTextDrawDestroy(playerid, VisualLogin[playerid][i]);
	}
	return 0;
}