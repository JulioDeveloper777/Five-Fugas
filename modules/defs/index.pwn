#include <YSI_Coding/y_hooks>




#define Scm                                                                     SendClientMessage
#define ISP                                                                     IsPlayerInRangeOfPoint
#define IPC                                                                     IsPlayerConnected
#define PlayerToPoint(%1,%2,%3)     IsPlayerInRangeOfPoint(%2,%1,%3)

#define varGet(%0)      getproperty(0,%0)
#define varSet(%0,%1)   setproperty(0, %0, %1)
#define new_strcmp(%0,%1) \
                (varSet(%0, 1), varGet(%1) == varSet(%0, 0))



hook OnGameModeInit()
{
  ManualVehicleEngineAndLights();
  ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
  SetNameTagDrawDistance(40.0);
  ShowNameTags(1);
  UsePlayerPedAnims();
  DisableInteriorEnterExits();
  EnableStuntBonusForAll(false);
  EnableStuntBonusForAll(0);
  SetGameModeText("BETA");
  return 1;
}

hook OnPlayerConnect(playerid)
{
  PlayAudioStreamForPlayer(playerid, "http://live.hunter.fm/sertanejo_high");
  // InterpolateCameraPos(playerid, 3243.553466, -410.080627, 48.884914, 3136.406005, -415.946533, 8.551589, 7000);
  // InterpolateCameraLookAt(playerid, 3247.088623, -410.126434, 52.420448, 3141.343017, -416.213256, 9.296744, 8000);
  return 1;
}

hook OnPlayerSpawn(playerid)
{
  StopAudioStreamForPlayer(playerid);
  return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
  DisablePlayerCheckpoint(playerid);
  return 1;
}