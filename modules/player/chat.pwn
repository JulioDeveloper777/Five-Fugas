#include <YSI_Coding/y_hooks>

public OnPlayerText(playerid, text[])
{
    return 1;
}


public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if (!success)
    {
        new string[256];
        format(string, 256, "{9900FF}[Five] {FFFFFF}Comando Invalido.", cmdtext);
        SendClientMessage(playerid, -1, string);
    }
    return 1;
}


stock LimparChat(playerid, linhas)
{
  for(new a = 0; a <= linhas; a++) Scm(playerid, -1, "");
}