#include <YSI_Coding/y_hooks>

#define LOGO_SERVER            "https://cdn.discordapp.com/attachments/990041379038179368/990042121161560104/IMG_20220620_001902.png?ex=65f4df93&is=65e26a93&hm=48dcf167c5e9fc53a1d9244496a94c842488e8ef2d17f1a6b5d3c069c39bf9fb&"
#define IMG_ONLINE_DS          "https://cdn.discordapp.com/attachments/844324415004606505/1213943358733680750/b.png?ex=65f74fda&is=65e4dada&hm=a47fa52952d3201fef95b954e208b0a4f3f1d7d6400120d842bb013a53a3b167&"
#define IP_SERVER              "🔎**__IP__:** ```149.56.41.49:7788```"
#define NAME_SERVER            "Five Fugas 2024"

new DCC_Channel:statuschannel;
new joinquit;
new DCC_Channel:joinquitlog;

hook OnGameModeInit()
{
  joinquitlog = DCC_FindChannelById("1113604639493996615");
  statuschannel = DCC_FindChannelById("1213156618829701200");
  new DCC_Embed:embed = DCC_CreateEmbed("**Servidor Onlline**", IP_SERVER, "", "", 129310, NAME_SERVER, LOGO_SERVER, LOGO_SERVER, IMG_ONLINE_DS);
  DCC_SendChannelEmbedMessage(statuschannel, embed, "");
  return 1;
}

hook OnPlayerConnect(playerid)
{
  joinquit += 1;
  new name[MAX_PLAYER_NAME + 1];
  GetPlayerName(playerid, name, sizeof(name));
  new plrIP[20];
  GetPlayerIp(playerid, plrIP, sizeof(plrIP));
  new log05[40];
  format(log05, sizeof log05, "%s Entrou No Servidor", name, plrIP);
  DCC_SendChannelMessage(joinquitlog, log05);
  return 1;
}


hook OnPlayerDisconnect(playerid, reason)
{
  joinquit -= 1;
  new log04[MAX_PLAYER_NAME + 1];
  GetPlayerName(playerid, log04, sizeof(log04));
  new log02[20];
  GetPlayerIp(playerid, log02, sizeof(log02));
  new log03[40];
  format(log03, sizeof log03, "%s Saiu Do Servidor", log04, log02);
  DCC_SendChannelMessage(joinquitlog, log03);
  return 1;
}