enum Player 
{
	pID,
	pPassword,
	pName[MAX_PLAYER_NAME],
	pSkin,
	pAdmin,
	pDiscordID[DCC_ID_SIZE],
	pDiscordCode[12],
};
new PlayerData[MAX_PLAYERS][Player];