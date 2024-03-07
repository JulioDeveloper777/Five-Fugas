//___________INCLUDES________________//
#include <a_samp>
#include <a_mysql>
#include <YSI_Data/y_iterate>
#include <YSI_Coding/y_hooks>
#include <DOF2>
#include <zcmd>
#include <sscanf2>
// #include <foreach>
#include <streamer>
#include <float>
#include <discord-cmd>
#include <discord-connector>
// #include <td-actions>



/* Database */
// #include "../modules/data/connection.pwn"

/* Defs */
#include "../modules/defs/index.pwn"
#include "../modules/defs/cors.pwn"
#include "../modules/defs/messages.pwn"
#include "../modules/defs/load-interior.pwn"

/* Discord */
#include "../modules/discord/join-quit.pwn"

/* Player */
#include "../modules/player/chat.pwn"
// #include "../modules/player/commands.pwn"
// #include "../modules/player/dialogs.pwn"
// #include "../modules/player/textdraw.pwn"

/* Server */
#include "../modules/server/account/data.pwn"
#include "../modules/server/account/textdraw.pwn"
#include "../modules/server/account/index.pwn"
#include "../modules/server/account/dialogs.pwn"

/* Visual */
#include "../modules/visual/login.pwn"

/* Admin */
#include "../modules/admin/commands.pwn"
#include "../modules/admin/funcs.pwn"

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
