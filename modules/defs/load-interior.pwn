#include <YSI_Coding/y_hooks>

new Text:LoadingInteriorG[13];

stock ShowLoadInt(playerid)
{
  TogglePlayerControllable(playerid, false);
  SetTimerEx("xTFixContolePlay", 3000, false, "i", playerid);
  for (new text; text < 13; text++) TextDrawShowForPlayer(playerid, LoadingInteriorG[text]);
  return 1;
}

forward xTFixContolePlay(playerid);
public xTFixContolePlay(playerid)
{
  for (new text; text < 13; text++) TextDrawHideForPlayer(playerid, LoadingInteriorG[text]);
  return TogglePlayerControllable(playerid, true);
}