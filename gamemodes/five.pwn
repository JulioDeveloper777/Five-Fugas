#define CGEN_MEMORY 60000
#define YSI_YES_HEAP_MALLOC

//___________PRAGMAS________________//
#pragma warning disable 214
#pragma warning disable 239

//___________INCLUDES________________//


#include <a_samp>
#include <a_mysql>
// #include <YSI_Coding/y_timers>
#include <YSI_Data/y_iterate>
#include <YSI_Coding/y_hooks>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <float>
#include <discord-cmd>
#include <discord-connector>
#include <easyDialog>

// #define DEBUG
// #include <nex-ac_pt_br.lang>
// #include <nex-ac>


/* Database */
#include "../modules/database/connection.pwn"

/* Defs */
#include "../modules/defs/index.pwn"
#include "../modules/defs/cors.pwn"
#include "../modules/defs/utils.pwn"
#include "../modules/defs/load-interior.pwn"

/* Visual */
#include "../modules/visual/login.pwn"

/* Server */
#include "../modules/server/account/player-data.pwn"
#include "../modules/server/account/index.pwn"

/* Discord */
#include "../modules/discord/join-quit.pwn"
// #include "../modules/discord/account-link.pwn"

/* Admin */
#include "../modules/admin/funcs.pwn"
#include "../modules/admin/commands.pwn"

/* Faction */
#include "../modules/faction/data.pwn"
#include "../modules/faction/dialog.pwn"
#include "../modules/faction/commands.pwn"

/* Gameplay */
#include "../modules/gameplay/interior.pwn"
#include "../modules/gameplay/anims.pwn"

/* Vehicle */
#include "../modules/vehicle/control.pwn"

/* Maps */
#include "../modules/maps/objects/index.pwn"
#include "../modules/maps/exteriors/airport.pwn"
#include "../modules/maps/exteriors/eletronics.pwn"
#include "../modules/maps/exteriors/gangster.pwn"
#include "../modules/maps/exteriors/gasstation.pwn"
#include "../modules/maps/exteriors/hospital.pwn"
#include "../modules/maps/exteriors/lobby.pwn"
#include "../modules/maps/exteriors/lspd.pwn"
#include "../modules/maps/interiors/lspd.pwn"