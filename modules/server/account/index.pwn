#include <YSI_Coding/y_hooks>



// #define D_SENHA                                                                 0
// #define D_SENHA1                                                                1
// #define D_EMAIL                                                                 2
// #define D_GENERO                                                                3 
// #define D_ADMINISTRADOR                                                         4
// #define MAX_SENHA 125



// new Trabalhando[MAX_PLAYERS];
// new EstaTv[MAX_PLAYERS];

//-----------------------------------------------------------------------------

// forward OnPlayerRequestLogin(playerid);
// forward OnPlayerDataLoaded(playerid);
// forward OnPlayerAttempLogin(playerid);
// forward OnPlayerAttempRegister(playerid);
// forward OnPlayerLoggedIn(playerid);

//-----------------------------------------------------------------------------

static g_PlayerLoginAttemps[MAX_PLAYERS] = {0, ...},
	bool: g_PlayerIsLogged[MAX_PLAYERS] = {false, ...},
		ORM: g_PlayerORM[MAX_PLAYERS] = {MYSQL_INVALID_ORM, ...};

//-----------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
	Player_ResetData(playerid);
	// return Y_HOOKS_CONTINUE_RETURN_1;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Player_SaveData(playerid);
	Player_ResetData(playerid);
	UnloadLoginTextDraw(playerid);
	return 1;
	// return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerRequestClass(playerid, classid)
{
	if (IsPlayerLogged(playerid))
	{
		Player_Spawn(playerid);
		return 1;
	}

	LoadLoginTextDraw(playerid);
	TogglePlayerSpectating(playerid, true);
	TogglePlayerControllable(playerid, false);
	SetPlayerColor(playerid, -1);
	SetPlayerVirtualWorld(playerid, 0);
	ClearChatPlayer(playerid, 50);

	mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT player_id FROM players WHERE player_name = '%e' LIMIT 1;", ReturnPlayerName(playerid));
	mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerRequestLogin", "i", playerid);
	return true;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(playertextid == VisualLogin[playerid][15])
	{
		OnPlayerAttempLogin(playerid);
	}
	if(playertextid == VisualLogin[playerid][16])
	{
		ShowPlayerDialog(playerid, 717, DIALOG_STYLE_MSGBOX, "RECUPERAR CONTA", "Em Breve!", "Fechar", "");
	}
	return 1;
}


stock OnPlayerRequestLogin(playerid)
{
	new StrDL1[1500];

	if (mysql_errno(SQL_GetHandle()) != 0)
	{
		Kick(playerid);
		return false;
	}

	new rows = cache_num_rows();

	if(rows)
	{
		cache_get_value_name_int(0, "player_id", PlayerData[playerid][pID]);
		Dialog_Show(playerid, Dialog_Login, DIALOG_STYLE_PASSWORD, "Efetuando login...", StrDL1, "Login", "Cancelar",  ReturnPlayerName(playerid));
	}
	else{
		PlayerData[playerid][pID] = -1;
		Dialog_Show(playerid, Dialog_Register_1, DIALOG_STYLE_MSGBOX, "{FFFFFF}Registro|Passo[1/2]", StrDL1, "Sim", "Nao", ReturnPlayerName(playerid));
	}
	return 1;
}

stock OnPlayerAttempLogin(playerid)
{
	if (mysql_errno(SQL_GetHandle()) != 0)
	{
		Kick(playerid);
		return false;
	}

	new rows = cache_num_rows();

	if (rows) {
		Player_LoadData(playerid);
	}
	else {
		g_PlayerLoginAttemps[playerid] += 1;
		new StrDL1[1500];
		Dialog_Show(playerid, Dialog_Login, DIALOG_STYLE_PASSWORD, "Efetuando login...", StrDL1, "Login", "Cancelar",  ReturnPlayerName(playerid));
	
		if (g_PlayerLoginAttemps[playerid] >= 3)
		{
			Kick(playerid);
		}
	}
	return 1;
}

stock OnPlayerAttempRegister(playerid)
{
	if (mysql_errno(SQL_GetHandle()) != 0)
	{
		Kick(playerid);
		return false;
	}

	PlayerData[playerid][pID] = cache_insert_id();
	Player_LoadData(playerid);
	return true;
}

stock OnPlayerDataLoaded(playerid)
{
	if (orm_errno(g_PlayerORM[playerid]) != ERROR_OK)
	{
		Kick(playerid);
		return true;
	}

	CallRemoteFunction("OnPlayerLoggedIn", "i", playerid);
	return true;
}

//-----------------------------------------------------------------------------

Dialog:Dialog_Login(playerid, response, listitem, inputtext[])
{
	new StrDL0[1500], StrDL1[1500];
	// if (!response)
	// {
	// 	Kick(playerid);
	// 	return true;
	// }

	if (!(4 <= strlen(inputtext) <= 20) || strfind(inputtext, " ") != -1)
	{
		// Dialog_Show(playerid, Dialog_Login, DIALOG_STYLE_PASSWORD, "{FF5555}ViSA > Login", "{FF1414}ERRO: Senha inv�lida!\n\n{FFFFFF}Ol� {FF5555}%s{FFFFFF}, bem-vindo(a) ao ViSA Multiplayer!\n\nEssa conta est� registrada, por favor insira a senha:", "Login", "Sair", ReturnPlayerName(playerid));
		format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}Bem-vindo, {006400}%s!", PlayerName(playerid));
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n\n{FFFFFF}Percebemos que ja possui uma conta registrada com este nome em nosso banco de dados.");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}Voce agora precisa informar a senha de login registrada nesta conta para continuar.");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n\n{808080}-		Aperte em 'recuperar conta'no lado esquerdo caso tenha");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n{808080}-		perdido a senha e possui o discord vinculado na conta.");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n\n{FFFFFF}Voce pode errar a senha no maximo {FF4500}3 {FFFFFF}vezes:");
		strcat(StrDL1, StrDL0);
		Dialog_Show(playerid, Dialog_Login, DIALOG_STYLE_PASSWORD, "Efetuando login...", StrDL1, "Login", "Cancelar",  ReturnPlayerName(playerid));
		// return true;
	}

	mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT * FROM players WHERE player_id = %i AND player_pass = md5('%e');", PlayerData[playerid][pID], inputtext);
	mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerAttempLogin", "i", playerid);
	return true;
}

Dialog:Dialog_Register_1(playerid, response, listitem, inputtext[])
{
	new StrDL0[1500], StrDL1[1500];
	// if (!response)
	// {
	// 	return true;
	// }

	if (response)
	{
		format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}Parece que o status da sua conta {B22222}NAO REGISTRADA {FFFFFF}no nosso servidor.");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}Confirme que voce quer criar uma conta neste servidor:");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n\n{808080}-Ao criar uma conta no servidor voce vai estar concordando");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n{808080}-Com todas as regras da comunidade que podem ser encontradas em");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n{808080}-Nosso discord ou pedindo ajuda a um administrador");
		strcat(StrDL1, StrDL0);
		format(StrDL0, sizeof(StrDL0), "\n\n{FFFFFF}Voce concorda em seguir todas as regras da comunidade?");
		strcat(StrDL1, StrDL0);
		Dialog_Show(playerid, Dialog_Register_1, DIALOG_STYLE_MSGBOX, "{FFFFFF}Registro|Passo[1/2]", StrDL1, "Sim", "Nao", ReturnPlayerName(playerid));
		// return 1;
	}
	Dialog_Show(playerid, Dialog_Register_2, DIALOG_STYLE_PASSWORD, "{FFFFFF}Registro|Passo[2/2]", StrDL1, "REGISTRAR", "", ReturnPlayerName(playerid));
	return 1;
}


Dialog:Dialog_Register_2(playerid, response, listitem, inputtext[])
{
	// if (!response)
	// {
	// 	Kick(playerid);
	// 	return true;
	// }

	if(response)
	{
		if (!(4 <= strlen(inputtext) <= 20) || strfind(inputtext, " ") != -1)
		{
			new StrDL0[1500], StrDL1[1500];
			format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}Ola %s,voce ainda nao tem uma conta no servidor!", PlayerName(playerid));
			strcat(StrDL1, StrDL0);
			format(StrDL0, sizeof(StrDL0), "\n{FFFFFF}OBS:Voce precisa digitar sua senha abaixo para efetuar o registro no servidor.");
			strcat(StrDL1, StrDL0);
			format(StrDL0, sizeof(StrDL0), "\n\n{FFFFFF}OBS:A senha que voce digitar precisa ter no minimo 4 caracteres para ser valida.");
			strcat(StrDL1, StrDL0);
			Dialog_Show(playerid, Dialog_Register_2, DIALOG_STYLE_PASSWORD, "{FFFFFF}Registro|Passo[2/2]", StrDL1, "REGISTRAR", "", ReturnPlayerName(playerid));
			return true;
		}

		mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "INSERT INTO players (`player_name`, `player_pass`) VALUES ('%e', md5('%e'));", ReturnPlayerName(playerid), inputtext);
		mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerAttempRegister", "i", playerid);
	}
	return 1;
}


//-----------------------------------------------------------------------------

stock IsPlayerLogged(playerid)
{
	return g_PlayerIsLogged[playerid];
}

stock Player_Spawn(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	UnloadLoginTextDraw(playerid);
	SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][pSkin], 161.5915, -2790.6873, 30.1002, 160.8168, 0, 0, 0, 0, 0, 0);

	if (IsPlayerInAnyVehicle(playerid))
	{
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y, z);
	}

	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		TogglePlayerSpectating(playerid, false);
	}
	else
	{
		SpawnPlayer(playerid);
	}
	return true;
}

stock Player_ResetData(playerid)
{
	// login setup
	g_PlayerIsLogged[playerid] = false;
	g_PlayerLoginAttemps[playerid] = 0;

	// name
	GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);

	// dummy reset
	new emptyEnum[Player];
	PlayerData[playerid] = emptyEnum;

	// orm
	g_PlayerORM[playerid] = MYSQL_INVALID_ORM;
	return 1;
}

stock Player_SaveData(playerid)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (g_PlayerORM[playerid] == MYSQL_INVALID_ORM)
		return false;

	orm_update(g_PlayerORM[playerid]);
	return 1;
}

stock Player_LoadData(playerid)
{
	if (IsPlayerLogged(playerid))
		return false;

	// valid orm
	if (g_PlayerORM[playerid] != MYSQL_INVALID_ORM)
	{
		orm_destroy(g_PlayerORM[playerid]);
		g_PlayerORM[playerid] = MYSQL_INVALID_ORM;
	}

	// set
	g_PlayerIsLogged[playerid] = true;

	// create 
	g_PlayerORM[playerid] = orm_create("players");
	orm_addvar_int(g_PlayerORM[playerid], PlayerData[playerid][pID], "player_id");
	orm_addvar_string(g_PlayerORM[playerid], PlayerData[playerid][pDiscordID], 21, "player_discord_id");
	orm_addvar_string(g_PlayerORM[playerid], PlayerData[playerid][pDiscordCode], 12, "player_discord_code");
	orm_addvar_string(g_PlayerORM[playerid], PlayerData[playerid][pName], MAX_PLAYER_NAME, "player_name");
	orm_addvar_string(g_PlayerORM[playerid], PlayerData[playerid][pPassword], MAX_PLAYER_NAME, "player_pass");
	orm_addvar_int(g_PlayerORM[playerid], PlayerData[playerid][pSkin], "player_skin");
	orm_addvar_int(g_PlayerORM[playerid], PlayerData[playerid][pAdmin], "player_admin");
	orm_setkey(g_PlayerORM[playerid], "player_id");

	orm_load(g_PlayerORM[playerid], "OnPlayerDataLoaded", "i", playerid);
	return true;
}