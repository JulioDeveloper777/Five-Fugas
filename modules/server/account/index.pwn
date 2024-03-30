#include <YSI_Coding/y_hooks>



// #define D_SENHA                                                                 0
// #define D_SENHA1                                                                1
// #define D_EMAIL                                                                 2
// #define D_GENERO                                                                3 
// #define D_ADMINISTRADOR                                                         4
// #define MAX_SENHA 125



// new Trabalhando[MAX_PLAYERS];
// new EstaTv[MAX_PLAYERS];

new bool:AllowedEnter = false;

//-----------------------------------------------------------------------------

forward OnPlayerRequestLogin(playerid);
forward OnPlayerDataLoaded(playerid);
forward OnPlayerAttempLogin(playerid);
forward OnPlayerAttempRegister(playerid);
forward OnPlayerLoggedIn(playerid);
forward Player_SaveData(playerid);
forward Player_LoadData(playerid);
forward Player_Spawn(playerid);
forward Player_ResetData(playerid);
//-----------------------------------------------------------------------------

static g_PlayerLoginAttemps[MAX_PLAYERS] = {0, ...},
	bool: g_PlayerIsLogged[MAX_PLAYERS] = {false, ...},
		ORM: g_PlayerORM[MAX_PLAYERS] = {MYSQL_INVALID_ORM, ...};

//-----------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
	Player_ResetData(playerid);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Player_SaveData(playerid);
	Player_ResetData(playerid);
	UnloadLoginTextDraw(playerid);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (IsPlayerLogged(playerid))
	{
		Player_Spawn(playerid);
		return 1;
	}

	LoadLoginTextDraw(playerid);
	SetPlayerColor(playerid, -1);
	SetPlayerVirtualWorld(playerid, 0);
	ClearChatPlayer(playerid, 50);

	mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT player_id FROM players WHERE player_name = '%e' LIMIT 1;", ReturnPlayerName(playerid));
	mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerRequestLogin", "i", playerid);
	return true;
}

public OnPlayerRequestSpawn(playerid)
{
	return false;
}


public OnPlayerRequestLogin(playerid)
{
	if (mysql_errno(SQL_GetHandle()) != 0)
	{
		Kick(playerid);
		return false;
	}

	new rows = cache_num_rows();

	if (rows)
	{
		cache_get_value_name_int(0, "player_id", PlayerData[playerid][pID]);
		DialogLogin(playerid);
	}
	else{
		PlayerData[playerid][pID] = -1;
		DialogRegistro(playerid);
	}
	return true;
}

public OnPlayerAttempLogin(playerid)
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
		DialogLogin(playerid);
	
		if (g_PlayerLoginAttemps[playerid] >= 3)
		{
			Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerAttempRegister(playerid)
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

public OnPlayerDataLoaded(playerid)
{
	if (orm_errno(g_PlayerORM[playerid]) != ERROR_OK)
	{
		Kick(playerid);
		return true;
	}
	// CallRemoteFunction("OnPlayerLoggedIn", "i", playerid);
	// CallRemoteFunction("Player_Spawn", "i", playerid);
	return true;
}

//-----------------------------------------------------------------------------



Dialog:LOGANDO(playerid, response, listitem, inputtext[]) 
{
	if (!(4 <= strlen(inputtext) <= 20) || strfind(inputtext, " ") != -1)
	{
		DialogLogin(playerid);
		return true;
	}

	mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT * FROM players WHERE player_id = %i AND player_pass = md5('%e');", PlayerData[playerid][pID], inputtext);
	mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerAttempLogin", "i", playerid);
	AllowedEnter = true;
	return true;
}

Dialog:REGISTRO(playerid, response, listitem, inputtext[]) 
{
	if (response)
	{
		SegundaDialogRegistro(playerid);
		return true;
	}
	return true;
}

Dialog:REGISTROFINAL(playerid, response, listitem, inputtext[]) 
{
	if(response)
	{
		if (!(4 <= strlen(inputtext) <= 20) || strfind(inputtext, " ") != -1)
		{
			SegundaDialogRegistro(playerid);
			return true;
		}
		mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "INSERT INTO players (`player_name`, `player_pass`) VALUES ('%e', md5('%e'));", ReturnPlayerName(playerid), inputtext);
		mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerAttempRegister", "i", playerid);
		AllowedEnter = true;
	}
	return true;
}


//-----------------------------------------------------------------------------

IsPlayerLogged(playerid)
{
	return g_PlayerIsLogged[playerid];
}

public Player_Spawn(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	if (IsPlayerInAnyVehicle(playerid))
	{
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y, z);
	}

	new string[128];
	ClearChatPlayer(playerid, 50);
	UnloadLoginTextDraw(playerid);
	ShowLoadInt(playerid);
	format(string, sizeof(string), "{9900FF}[Five] {FFFFFF}Seja bem-Vindo(a) %s!", PlayerName(playerid));
	Scm(playerid, -1, string);
	SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][pSkin], 1513.1312,-1362.5790,332.2578, 269.6020, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		TogglePlayerSpectating(playerid, false);
	}
	// else {
	// 	SpawnPlayer(playerid);
	// }
	return true;
}

public Player_ResetData(playerid)
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

public Player_SaveData(playerid) 
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (g_PlayerORM[playerid] == MYSQL_INVALID_ORM)
		return false;

	orm_update(g_PlayerORM[playerid]);
	return 1;
}

public Player_LoadData(playerid)
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
	// orm_addvar_string(g_PlayerORM[playerid], PlayerData[playerid][pPassword], MAX_PLAYER_NAME, "player_pass");
	orm_addvar_int(g_PlayerORM[playerid], PlayerData[playerid][pSkin], "player_skin");
	orm_addvar_int(g_PlayerORM[playerid], PlayerData[playerid][pAdmin], "player_admin");
	orm_setkey(g_PlayerORM[playerid], "player_id");

	orm_load(g_PlayerORM[playerid], "OnPlayerDataLoaded", "i", playerid);
	OnPlayerDataLoaded(playerid);
	return true;
}



hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(playertextid == VisualLogin[playerid][15] || playertextid == VisualLogin[playerid][14])
	{
		if(AllowedEnter == false) {
			mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT player_id FROM players WHERE player_name = '%e' LIMIT 1;", ReturnPlayerName(playerid));
			mysql_tquery(SQL_GetHandle(), global_query, "OnPlayerRequestLogin", "i", playerid);
		} else {
			Player_Spawn(playerid);
		}
	}
	if(playertextid == VisualLogin[playerid][16])
	{
		ShowPlayerDialog(playerid, 717, DIALOG_STYLE_MSGBOX, "RECUPERAR CONTA", "Em Breve!", "Fechar", "");
	}
	return 1;
}