#include <YSI_Coding/y_hooks>



#define DIALOG_TELEPORT 880
#define DIALOG_PUXAR    881
#define DIALOG_IR       882



#define Scm                                                                     SendClientMessage
#define ISP                                                                     IsPlayerInRangeOfPoint
#define IPC                                                                     IsPlayerConnected
#define PlayerToPoint(%1,%2,%3)     IsPlayerInRangeOfPoint(%2,%1,%3)




new Trabalhando[MAX_PLAYERS];
#define D_ADMINISTRADOR        2
new EstaTv[MAX_PLAYERS];



#define varGet(%0)      getproperty(0,%0)
#define varSet(%0,%1)   setproperty(0, %0, %1)
#define new_strcmp(%0,%1) \
                (varSet(%0, 1), varGet(%1) == varSet(%0, 0))
#define   XXX::%0(%1) 	forward %0(%1);\
				public %0(%1)   

main()
{
  printf("===========================================================\n");
  printf("-----------------------( Running )-------------------------\n");
  printf("===========================================================\n");
}



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

hook OnGameModeExit()
{
  return 1;
}