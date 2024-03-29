#include <YSI_Coding/y_hooks>


#define DCMD_PREFIX '!' 
#define DCMD_STRICT_CASE

//-----------------------------------------------------------------------------

new bool: gPlayerInDiscordAuth[MAX_PLAYERS] = {false, ...};

//-----------------------------------------------------------------------------

hook OnPlayerLoggedIn(playerid)
{
	if (!strcmp(PlayerData[playerid][pDiscordID], "Nenhum", true))
	{
		gPlayerInDiscordAuth[playerid] = true;

		Discord_GenerateAuthCode(playerid);
		Player_SaveData(playerid);
	}
	else
	{
		gPlayerInDiscordAuth[playerid] = false;
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

DCMD:verify(user, channel, params[]) 
{
    if (strcmp(DCC_ReturnChannelID(channel), "1076673340263120906"))
    {
    	DCC_SendChannelMessage(channel, "<@%s> Ops! Voce não esta no canal correto para vincular sua conta.", DCC_ReturnUserID(user));
    	return true;
    }

    new
    	idx = INVALID_PLAYER_ID,
    	name[MAX_PLAYER_NAME],
    	code[12];

    if (sscanf (params, "s[21]s[12]", name, code))
    {
    	DCC_SendChannelMessage(channel, "<@%s> Ei, Escreva dessa maneira: **!verify [username] [code]**", DCC_ReturnUserID(user));
    	return true;
    }

    mysql_format(SQL_GetHandle(), global_query, sizeof global_query, "SELECT `player_id` FROM `players` WHERE `player_discord_id` = '%e' LIMIT 1;", DCC_ReturnUserID(user));
    mysql_query(SQL_GetHandle(), global_query);

    if (cache_num_rows())
    {
    	DCC_SendChannelMessage(channel, "<@%s> Ops! Parece que voce ja possui uma conta vinculada ao seu Discord.", DCC_ReturnUserID(user));
    	return true;
    }

    foreach (new i : Player)
    {
    	if (!IsPlayerLogged(i))
    		continue;

    	if (!strcmp(ReturnPlayerName(i), name, false))
    	{
    		idx = i;
    		break;
    	}
    }

    if (idx == INVALID_PLAYER_ID)
    {
    	DCC_SendChannelMessage(channel, "<@%s> Ops! Parece que este jogador não esta logado no servidor.", DCC_ReturnUserID(user));
    	return true;
    }

    if (strcmp(PlayerData[idx][pDiscordID], "Nenhum"))
    {
    	DCC_SendChannelMessage(channel, "<@%s> Ops! Parece que este jogador ja tem um discord vinculado.", DCC_ReturnUserID(user));
    	return true;
    }

    if (!strcmp(PlayerData[idx][pDiscordCode], code, false))
    {
    	gPlayerInDiscordAuth[idx] = false;

    	format (PlayerData[idx][pDiscordID], DCC_ID_SIZE, DCC_ReturnUserID(user));
    	Player_SaveData(idx);


    	new str[32], DCC_Guild:guild = DCC_FindGuildById("1020822629545939079"); /*, DCC_Role:role = DCC_FindRoleById("1094695818235224255");*/

    	format (str, sizeof str, "%i | %s", PlayerData[idx][pID], ReturnPlayerName(idx));
    	// DCC_AddGuildMemberRole(guild, user, role);
    	DCC_SetGuildMemberNickname(guild, user, str);

    	DCC_SendChannelMessage(channel, "<:emoji_36:1077241188354097203> Wow! Sua conta foi vinculada com sucesso.", DCC_ReturnUserID(user));
    }
    else
    {
    	DCC_SendChannelMessage(channel, "Ops! O codigo inserido é invalido.", DCC_ReturnUserID(user));
    }

    return true;
}

//-----------------------------------------------------------------------------

DCC_ReturnUserID(DCC_User:user)
{
	new _id[DCC_ID_SIZE];
	DCC_GetUserId(user, _id);
	return _id;
}

DCC_ReturnChannelID(DCC_Channel:channel)
{
	new _id[DCC_ID_SIZE];
	DCC_GetChannelId(channel, _id);
	return _id;
}

// stock DCC_SendChannelMessage(DCC_Channel:channel, const message[], va_args<>)
// {
// 	new
// 		_formatted[256],
// 		_encoded[256]
// 	;

// 	va_format(_formatted, sizeof _formatted, message, va_start<2>);
// 	utf8encode(_encoded, _formatted);

// 	DCC_SendChannelMessage(channel, _encoded);
// 	return true;
// }

//-----------------------------------------------------------------------------

Discord_GenerateAuthCode(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	format (PlayerData[playerid][pDiscordCode], 12, Internal_ReturnCode());
	return true;
}

Internal_ReturnCode()
{
	new _str[12] = "";
	new _chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";

	for (new i = 0; i < 10; i++)
	{
		_str[i] = _chars[random (35)];
	}

	_str[10] = EOS;

	return _str;
}