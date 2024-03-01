//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                                CRIADO POR
//                              JULIO DEVELOPER
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <a_samp>
#include <DOF2>
#include <zcmd>
#include <Dini>
#include <sscanf2>
#include <streamer>
#include <float>
#include <discord-connector>
#include <MSelection>
#include <discord-cmd>
#include <gl_messages>
#pragma disablerecursion

#pragma warning disable 806
#pragma warning disable 1052
#pragma warning disable 1349
#pragma warning disable 1351
#pragma warning disable 1054
#pragma warning disable 808
#pragma warning disable 811
#pragma warning disable 1057
#pragma warning disable 1354


//___________DISCORD CONNECTOR_________//
new joinquit;
new DCC_Channel:joinquitlog;
new DCC_Channel:g_Discord_Chat;


//___________DEFINES CORES________________//
#define COR_UG                  0x62976DFF
#define AMARELO_COR             0xF6F600FF
#define VERDECLARO_COR          0x00FF00FF
#define ROXO_COR_COR            0xFF0000FF
#define LARANJA_COR             0xff6347FF
#define AZULCLARO_COR           0x33CCFFAA
#define VERDEESCURO_COR         0x00660CF6
#define BRANCO_COR              0xFFFFFFFF
#define ROXO_COR                0xC2A2DAAA
#define VERMELHO_COR            0xF78181AA
#define ROXOFORTE_COR           0x9900FFAA
#define AZULESCURO_COR          0x2641FEAA
#define PRETO_COR               0x6E6E6E6E

#define 	red             	"{FF0000}"
#define     grey                "{AFAFAF}"
#define     green   	    	"{00FF00}"


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define PASTA_CONTAS                                                            "Contas/%s.ini"
#define SCM                                                                     SendClientMessage
#define ISP                                                                     IsPlayerInRangeOfPoint
#define IPC                                                                     IsPlayerConnected
#define D_SENHA                                                                 0
#define D_ADMINISTRADOR                                                         2

#define varGet(%0)      getproperty(0,%0)
#define varSet(%0,%1)   setproperty(0, %0, %1)
#define new_strcmp(%0,%1) \
                (varSet(%0, 1), varGet(%1) == varSet(%0, 0))

#define Funcion%0(%1) 	 forward %0(%1); public %0(%1)

#define     USAGE       "{FF0000}USAGE: {FFFFFF}/"
#define     ERROR       "{FF0000}ERROR: {FFFFFF}"

#define     RED         "{FF0000}"
#define     GREEN       "{1DBF00}"

#define DIALOG_VEHICLES 		1

new playerCar[MAX_PLAYERS];


enum pInfo
{
    Senha[20],
    Dinheiro,
    Level,
    Skin,
    Admin,

    Interior,
	VirtualW,

	Float:VidaHP,
	Float:ColeteHP,

	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosR

};
new info[MAX_PLAYERS][pInfo];
//
new arquivo[128];
new VSenha[MAX_PLAYERS][20];
new TentativasSenha[MAX_PLAYERS];
//
new Trabalhando[MAX_PLAYERS];
new Gasolina[MAX_PLAYERS];
new skinadm[MAX_PLAYERS];
new EstaTv[MAX_PLAYERS];
//
new bool:VerificarLogin[MAX_PLAYERS];
new bool:EstaRegistrado[MAX_PLAYERS];
//
new PlayerText:TextdrawRegistro[10][MAX_PLAYERS];
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

main()
{
	joinquitlog = DCC_FindChannelById("1213140177229447201");
}

public OnGameModeInit()
{
    ShowNameTags(1); //NICK DO PLAYER
    DisableInteriorEnterExits(); //DESATIVA INTERIORES
    UsePlayerPedAnims(); //ATIVA AS ANIM PADRAO DO GTA
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); //DESATIVA O PLAYER NO MAPA
    SetGameModeText("BETA");
    EnableStuntBonusForAll(0);
    return 1;
}

public OnGameModeExit()
{
    DOF2_Exit();
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if(!DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = false;
        VSenha[playerid] = "-1";
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for(new i; i < 10; i++)
		{
			PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
		}
		SelectTextDraw(playerid, 0xFF0000AA);
    }
    else if(DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = true;
        VSenha[playerid] = "-1";
        TentativasSenha[playerid] = 0;
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for(new i; i < 10; i++)
		{
			PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
		}
		SelectTextDraw(playerid, 0xFF0000AA);
    }
    LimparChat(playerid, 30);
    TogglePlayerSpectating(playerid, 1);
    InterpolateCameraPos(playerid, 828.892395, -1470.234985, 159.147048, 1855.578247, -1356.315795, 106.570388, 90000);
    InterpolateCameraLookAt(playerid, 833.859008, -1469.715087, 158.897155, 1860.529296, -1355.671020, 106.302513, 90000);
    SetPlayerColor(playerid, ROXO_COR);
    return 1;
}

public OnPlayerConnect(playerid)
{
    joinquit += 1;
	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    new plrIP[16];
    GetPlayerIp(playerid, plrIP, sizeof(plrIP));
	new log05[34];
	format(log05, sizeof log05, "%s Entrou No Servidor", name, plrIP);
	DCC_SendChannelMessage(joinquitlog, log05);

    PlayAudioStreamForPlayer(playerid, "http://live.hunter.fm/sertanejo_high");
    CarregarTextdrawPlayer(playerid);
    VerificarLogin[playerid] = false;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    joinquit -= 1;
	new log04[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, log04, sizeof(log04));
    new log02[16];
    GetPlayerIp(playerid, log02, sizeof(log02));
	new log03[34];
	format(log03, sizeof log03, "%s Saiu Do Servidor", log04, log02);
	DCC_SendChannelMessage(joinquitlog, log03);




    DestroyVehicle(playerCar[playerid]);
    if(VerificarLogin[playerid] == true)
    {
        SalvarDados(playerid);
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    StopAudioStreamForPlayer(playerid);
    if(VerificarLogin[playerid] == false)
    {
        Kick(playerid);
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(VerificarLogin[playerid] == false)
	{
		MensagemText(playerid, "~r~ERRO: ~w~Voce nao pode falar no chat.");
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{

	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

forward QuebrarText(playerid);
forward UmSegundo();

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {

    }
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == D_SENHA)
    {
        if(response)
        {
            if(strlen(inputtext) < 5 || strlen(inputtext) > 20)
            {
                MensagemText(playerid, "~r~ERRO: ~w~Voce informou uma senha muito pequena ou muito grande, informe senha maior que 5 e menor que 20");
            }
            else
            {
                format(VSenha[playerid], 20, inputtext);
				for(new i; i < strlen(inputtext); i++)
				{
					inputtext[i] = ']';
				}
                PlayerTextDrawSetString(playerid, TextdrawRegistro[7][playerid], inputtext);
				PlayerTextDrawShow(playerid, TextdrawRegistro[7][playerid]);
            	SelectTextDraw(playerid, 0xFF0000AA);
            }
        }
        else
        {
            SelectTextDraw(playerid, 0xFF0000AA);
        }
    }
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid != INVALID_PLAYER_TEXT_DRAW)
	{
        if(playertextid == TextdrawRegistro[7][playerid]) // Botao Senha
		{
            if(EstaRegistrado[playerid] == false)
			{
				CancelSelectTextDraw(playerid);
				ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo uma senha para registrar-se.", "Pronto", "Voltar");
			}
            if(EstaRegistrado[playerid] == true)
			{
				CancelSelectTextDraw(playerid);
				ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo sua senha para logar no servidor.", "Pronto", "Voltar");
			}
        }
        if(playertextid == TextdrawRegistro[8][playerid])
		{
            if(EstaRegistrado[playerid] == false)
            {
                if(new_strcmp(VSenha[playerid], "-1"))
				{
					return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
				}
                else
                {
					for(new i; i < 10; i++)
					{
						PlayerTextDrawHide(playerid, TextdrawRegistro[i][playerid]);
					}
					CancelSelectTextDraw(playerid);
                }
            }
            else if(EstaRegistrado[playerid] == true)
			{
                if(new_strcmp(VSenha[playerid], "-1"))
				{
					return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
				}
                format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
				if(!new_strcmp(VSenha[playerid], DOF2_GetString(arquivo, "Senha")))
				{

                    
                    if(TentativasSenha[playerid] < 3)
					{
						new string[120];
						TentativasSenha[playerid] ++;
						format(string, sizeof(string), "~r~ERRO: ~w~Voce informou sua senha incorretamente, informe sua senha corretamente (%02d/03).", TentativasSenha[playerid]);
						MensagemText(playerid, string);
					}
                    else
                    {
                        Kick(playerid);
                    }
                }
                else
                {
                    for(new i; i < 10; i++)
					{
						PlayerTextDrawHide(playerid, TextdrawRegistro[i][playerid]);
					}
					CancelSelectTextDraw(playerid);
					CarregarDadosPlayer(playerid);
                }
            }
        }
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public QuebrarText(playerid)
{
	return PlayerTextDrawHide(playerid, TextdrawRegistro[9][playerid]);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(success == -1)
    {
        SendClientMessage(playerid, 0x77786FFF, "-> Voce digitou um comando nao reconhecido");

        return 0;
    }
    return 1;
}




CMD:dev(playerid)
{
   if(info[playerid][Admin] > 5) return SCM(playerid, -1, "");
   SCM(playerid, AMARELO_COR, "[FIVE] Voce pegou Admin Level 10!");
   info[playerid][Admin] = 10;
   return 1;
}
CMD:comandosadm(playerid,params[])
{
    new Str[1000];
    if(info[playerid][Admin] < 1) return SCM(playerid, ROXO_COR, "[FIVE]: Voce nao tem permissao.");
	{
        if(Trabalhando[playerid] < 1) return SCM(playerid, ROXO_COR, "[FIVE] Voce nao esta em modo trabalho.");
	    {
            strcat(Str, "{2E8B57}/setadm | /trabalhar | /limparchat | /sethora | /setclima | /rc | /dv | /cv\n");
            strcat(Str, "{2E8B57}/setskin | /rcar | /aviso | /trazer | /ir | /tv | tvoff");
            ShowPlayerDialog(playerid, D_ADMINISTRADOR, DIALOG_STYLE_MSGBOX, "Comandos", Str, "-", "");
        }
    }
    return 1;
}
CMD:setadm(playerid,params[])
{
	new id,adm,funcao[999],str[999];
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
	    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
	    {
			if(sscanf(params,"dds",id,adm,funcao)) return SCM(playerid,-1,"{FF0000}Use: /setadm [ID] [NIVEL] [FUNCAO].");

            format(str,sizeof(str),"SERVER: voce deu administrador {2E8B57}%d{FFFFFF} Funcao {2E8B57}%s{FFFFFF} Para {FFFFFF}{F0E68C}%s(%d){FFFFFF}{FFFFFF}.",adm,funcao,PlayerName(id),id);
			SCM(playerid,-1,str);
			format(str,sizeof(str),"SERVER: O Administrador {FFFFFF}{2E8B57}%s(%d){FFFFFF}{FFFFFF} te deu admin nivel {2E8B57}%d{FFFFFF} Funcao {2E8B57}%s{FFFFFF}.",PlayerName(playerid),playerid,adm,funcao);
			SCM(id,-1,str);
			format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(id));
			if(DOF2_FileExists(arquivo))
			{
			    info[id][Admin] = adm;
				DOF2_SetInt(arquivo, "Admin", adm);
				DOF2_SetString(arquivo, "Funcao", funcao);
				DOF2_SaveFile();
			}
		}
	}
	return 1;
}
CMD:limparchat(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
	    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
	    {
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, " ");
            SendClientMessageToAll(-1, "SERVER: Chat limpo!");
        }
    }
    return 1;
}
CMD:sethora(playerid,params[])
{
    new hora;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
	    {
            if(sscanf(params,"d",hora)) return SCM(playerid,-1,"{FF0000}Use: /sethora [HORA].");
			SetWorldTime(hora);
        }
    }
    return 1;
}

CMD:setclima(playerid,params[])
{
    new clima;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
           	if(sscanf(params,"d",clima)) return SCM(playerid,-1,"{FF0000}Use: /setclima [CLIMA].");
 			SetWeather(clima);
        }
    }
    return 1;
}
CMD:car(playerid,params[])
{
    new Vehi[MAX_PLAYERS], vehicle, C1, C2, Float:X, Float:Y, Float:Z, Float:R;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
       if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            Gasolina[playerid] = 100;
			if(sscanf(params,"ddd",vehicle , C1, C2)) return  SCM(playerid, -1, "{FF0000}Use: /cv [CARID] [COR1] [COR2]");
			GetPlayerPos(playerid,X,Y,Z);
			GetPlayerFacingAngle(playerid, R);
			Vehi[playerid] = CreateVehicle(vehicle, X, Y, Z, R, C1, C2, -1);
			PutPlayerInVehicle(playerid, Vehi[playerid],0);
        }
    }
    return 1;
}
CMD:trabalhar(playerid, params[])
{
    new str[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] > 0)
	    {
	        SetPlayerSkin(playerid,skinadm[playerid]);
			Trabalhando[playerid] = 0;
 			SetPlayerHealth(playerid,100);
			SetPlayerArmour(playerid,0);
			SendClientMessageToAll(-1, "{2E8B57}|_______________ {FFFFFF}Aviso da Administracao{2E8B57} _______________|");
			format(str,sizeof(str),"{FFFFFF}O Admin {FFFFFF}{2E8B57}%s(%d){FFFFFF}{FFFFFF} Esta Jogando.",PlayerName(playerid),playerid);
			SendClientMessageToAll(-1, str);
		}
		else
		{
		    skinadm[playerid] = GetPlayerSkin(playerid);
			Trabalhando[playerid] = 1;
			SetPlayerHealth(playerid,99999);
			SetPlayerArmour(playerid,99999);
			SetPlayerSkin(playerid,217);
			SendClientMessageToAll(-1, "{2E8B57}|_______________ {FFFFFF}Aviso da Administracao{2E8B57} _______________|");
			format(str,sizeof(str),"{FFFFFF}O Admin {FFFFFF}{2E8B57}%s(%d){FFFFFF}{FFFFFF} Esta Trabalhando.",PlayerName(playerid),playerid);
			SendClientMessageToAll(-1, str);
		}
    }
    return 1;
}
CMD:setskin(playerid, params[])
{
    new ID,SKIN,str[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "dd",ID,SKIN)) return SCM(playerid, -1, "{FF0000}Use: /setskin [ID] [SKIN]");
			{
                format(str,sizeof(str), "SERVER: Voce deu skin {FFFFFF}%d{FFFFFF} Para {2E8B57}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
				SCM(playerid, -1, str);
				format(str,sizeof(str), "SERVER: O Administrador {FFFFFF}{2E8B57}%s(%d){FFFFFF}{FFFFFF} te deu Skin {2E8B57}%d{FFFFFF}.",PlayerName(playerid), playerid,SKIN);
				SCM(ID, -1, str);
	         	format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(ID));
				if(DOF2_FileExists(arquivo))
                {
                    SetPlayerSkin(ID, SKIN);
		 			DOF2_SetInt(arquivo, "Skin", SKIN);
				    DOF2_SaveFile();
                }
            }
        }
    }
    return 1;
}
CMD:dv(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            DestroyVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:fix(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            RepairVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:aviso(playerid,params[])
{
    new str[999],TEXTO;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "s",TEXTO)) return SCM(playerid, -1, "{FF0000}Use: /aviso [TEXTO]");
			{
			  	SendClientMessageToAll(-1, "{2E8B57}|_______________ {FFFFFF}Aviso da Administracao{2E8B57} _______________|");
				format(str, 128, "{FFFFFF}Admin {2E8B57}%s(%d){FFFFFF}{FFFFFF}: %s.",PlayerName(playerid), playerid, TEXTO);
				SendClientMessageToAll(-1, str);
			}
        }
    }
    return 1;
}
CMD:tv(playerid,params[])
{
    new id;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    if(EstaTv[playerid] == 0)
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            if(sscanf(params,"i",id)) return SCM(playerid, -1, "Use /tv [ID]");
    	    if(id == playerid) return SCM(playerid, 0xFF0000AA, "Voce nao pode assistir!");
    	    if(!IsPlayerConnected(id)) return SCM(playerid, -1, "SERVER: Esse player nao esta online.");
    	    SCM(playerid, 0xFF0000AA, "Para parar de assistir use /tvoff.");
    		TogglePlayerSpectating(playerid, 1);
    		PlayerSpectatePlayer(playerid, id);
    		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
    	    EstaTv[playerid] = 1;
      }
  	  }else {
  		SCM(playerid, -1, "Voce ja esta tv em alguem, Use: /tvoff");
    }
    return 1;
}
CMD:tvoff(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    if(EstaTv[playerid] == 1){
    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
 	{
		TogglePlayerSpectating(playerid, 0);
		PlayerSpectatePlayer(playerid, playerid);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(playerid));
	    EstaTv[playerid] = 0;
    }
    }else {
    	SCM(playerid, 0xFF0000AA, "Voce nao esta tv em alguem.");
    }
   	return 1;
}
CMD:ir(playerid,params[])
{
    new id, Float:PedPos[3], string[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "use: /ir [ID].");
            if(!IsPlayerConnected(id)) return SCM(playerid, -1, "SERVER: Esse player nao esta online.");
            GetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "SERVER: Voce foi ate o player {2E8B57}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}
CMD:trazer(playerid,params[])
{
    new id, Float:PedPos[3], string[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "use: /trazer [ID].");
            if(!IsPlayerConnected(id)) return SCM(playerid, -1, "SERVER: Esse player nao esta online.");
            GetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "SERVER: O administrador trouxe o Player {2E8B57}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}

stock CriarDadosPlayer(playerid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
	if(!DOF2_FileExists(arquivo))
	{
        DOF2_CreateFile(arquivo);
		DOF2_SetString(arquivo, "Senha", VSenha[playerid]);
		DOF2_SetInt(arquivo, "Dinheiro", 800);
		DOF2_SetInt(arquivo, "Level", 0);

        DOF2_SetInt(arquivo, "Admin", 0);

        DOF2_SetInt(arquivo, "Interior", 0);
		DOF2_SetInt(arquivo, "VirtualW", 0);

		DOF2_SetFloat(arquivo, "VidaHP", 100.0);
		DOF2_SetFloat(arquivo, "ColeteHP", 0.0);

		DOF2_SetFloat(arquivo, "PosX", 1613.837280);
		DOF2_SetFloat(arquivo, "PosY", -2242.931152);
		DOF2_SetFloat(arquivo, "PosZ", 13.530795);
		DOF2_SetFloat(arquivo, "PosR", 182.039520);

        DOF2_SaveFile();

		VSenha[playerid] = "-1";
		CarregarDadosPlayer(playerid);
    }
    return 1;
}

stock CarregarDadosPlayer(playerid)
{
	format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
	if(DOF2_FileExists(arquivo))
	{
		GivePlayerMoney(playerid, DOF2_GetInt(arquivo, "Dinheiro"));
		SetPlayerScore(playerid, DOF2_GetInt(arquivo, "Level"));
		SetPlayerSkin(playerid, DOF2_GetInt(arquivo, "Skin"));
		info[playerid][Admin] = DOF2_GetInt(arquivo, "Admin");
        SetPlayerInterior(playerid, DOF2_GetInt(arquivo, "Interior"));
		SetPlayerVirtualWorld(playerid, DOF2_GetInt(arquivo, "VirtualW"));
		SetPlayerHealth(playerid, DOF2_GetFloat(arquivo, "VidaHP"));
		SetPlayerArmour(playerid, DOF2_GetFloat(arquivo, "ColeteHP"));
		info[playerid][PosX] = DOF2_GetFloat(arquivo, "PosX");
		info[playerid][PosY] = DOF2_GetFloat(arquivo, "PosY");
		info[playerid][PosZ] = DOF2_GetFloat(arquivo, "PosZ");
		info[playerid][PosR] = DOF2_GetFloat(arquivo, "PosR");

		TogglePlayerSpectating(playerid, 0);
		VerificarLogin[playerid] = true;
		SetPlayerColor(playerid, 0xFFFFFFAA);

		new string[128];
		format(string, sizeof(string), "{FF8080}SERVER:{FFFFFF} Seja bem-Vindo(a) %s!", PlayerName(playerid));
		SendClientMessage(playerid, -1, string);

		SetSpawnInfo(playerid, NO_TEAM, GetPlayerSkin(playerid), info[playerid][PosX], info[playerid][PosY], info[playerid][PosZ], info[playerid][PosR], 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
	}
	return 1;
}

stock SalvarDados(playerid)
{
	new Float:X, Float:Y, Float:Z, Float:R, Float:health, Float:armour;
	GetPlayerPos(playerid, Float:X, Float:Y, Float:Z);
	GetPlayerFacingAngle(playerid, Float:R);
	GetPlayerHealth(playerid, Float:health);
	GetPlayerArmour(playerid, Float:armour);

	format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
	if(DOF2_FileExists(arquivo))
	{
		DOF2_SetInt(arquivo, "Dinheiro", GetPlayerMoney(playerid));
		DOF2_SetInt(arquivo, "Level", GetPlayerScore(playerid));
		DOF2_SetInt(arquivo, "Skin", GetPlayerSkin(playerid));
		DOF2_SetInt(arquivo, "Admin", info[playerid][Admin]);
        DOF2_SetInt(arquivo, "Interior", GetPlayerInterior(playerid));
		DOF2_SetInt(arquivo, "VirtualW", GetPlayerVirtualWorld(playerid));

		DOF2_SetFloat(arquivo, "VidaHP", health);
		DOF2_SetFloat(arquivo, "ColeteHP", armour);

		DOF2_SetFloat(arquivo, "PosX", X);
		DOF2_SetFloat(arquivo, "PosY", Y);
		DOF2_SetFloat(arquivo, "PosZ", Z);
		DOF2_SetFloat(arquivo, "PosR", R);

        DOF2_SaveFile();
	}
	return 1;
}

stock CarregarTextdrawPlayer(playerid)
{
    TextdrawRegistro[0][playerid] = CreatePlayerTextDraw(playerid,402.000000, 119.000000, "_");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[0][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[0][playerid], 2.679999, 21.999996);
    PlayerTextDrawColor(playerid,TextdrawRegistro[0][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[0][playerid], 471604479);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[0][playerid], 236.000000, 189.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[0][playerid], 0);

    TextdrawRegistro[1][playerid] = CreatePlayerTextDraw(playerid,382.000000, 172.000000, "_");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[1][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[1][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[1][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[1][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[1][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[1][playerid], 0);

    TextdrawRegistro[2][playerid] = CreatePlayerTextDraw(playerid,307.000000, 146.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[2][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[2][playerid], 4);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[2][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[2][playerid], 18.000000, -19.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[2][playerid], 0);

    TextdrawRegistro[3][playerid] = CreatePlayerTextDraw(playerid,305.000000, 159.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[3][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[3][playerid], 4);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[3][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[3][playerid], 22.000000, -11.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[3][playerid], 0);

    TextdrawRegistro[4][playerid] = CreatePlayerTextDraw(playerid,382.000000, 205.000000, "_");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[4][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[4][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[4][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[4][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[4][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[4][playerid], 0);

    TextdrawRegistro[5][playerid] = CreatePlayerTextDraw(playerid,353.000000, 251.000000, "_");
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[5][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[5][playerid], 0.529999, 2.299999);
    PlayerTextDrawColor(playerid,TextdrawRegistro[5][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[5][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawUseBox(playerid,TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawBoxColor(playerid,TextdrawRegistro[5][playerid], -2147483393);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[5][playerid], 284.000000, -252.000000);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[5][playerid], 0);

    TextdrawRegistro[6][playerid] = CreatePlayerTextDraw(playerid,316.000000, 174.000000, "NICK");
    PlayerTextDrawAlignment(playerid,TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[6][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[6][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[6][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[6][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[6][playerid], 0);

    TextdrawRegistro[7][playerid] = CreatePlayerTextDraw(playerid,317.000000, 207.000000, "SENHA");
    PlayerTextDrawAlignment(playerid,TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[7][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[7][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[7][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[7][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[7][playerid], 30.0, 30.0);

    TextdrawRegistro[8][playerid] = CreatePlayerTextDraw(playerid, 318.000000, 255.000000, "ENTRAR");
    PlayerTextDrawAlignment(playerid,TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[8][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[8][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[8][playerid], ROXO_COR);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[8][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawTextSize(playerid,TextdrawRegistro[8][playerid], 30.0, 30.0);

    TextdrawRegistro[9][playerid] = CreatePlayerTextDraw(playerid,317.000000, 326.000000, "_"); // erro
    PlayerTextDrawAlignment(playerid,TextdrawRegistro[9][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[9][playerid], 255);
    PlayerTextDrawFont(playerid,TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawLetterSize(playerid,TextdrawRegistro[9][playerid], 0.250000, 1.300000);
    PlayerTextDrawColor(playerid,TextdrawRegistro[9][playerid], -1);
    PlayerTextDrawSetOutline(playerid,TextdrawRegistro[9][playerid], 0);
    PlayerTextDrawSetProportional(playerid,TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetShadow(playerid,TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[9][playerid], 0);
    return 1;
}

stock MensagemText(playerid, const text[])
{
	PlayerTextDrawSetString(playerid, TextdrawRegistro[9][playerid], text);
	PlayerTextDrawShow(playerid, TextdrawRegistro[9][playerid]);
	PlayerPlaySound(playerid,1085,0.0,0.0,0.0);
	SelectTextDraw(playerid, 0xFFFFFFAA);
	return SetTimerEx("QuebrarText", 8000, false, "i", playerid);
}

stock LimparChat(playerid, linhas)
{
	for(new a = 0; a <= linhas; a++) SCM(playerid, -1, "");
}

stock PlayerName(playerid)
{
    new Nick[MAX_PLAYER_NAME];
    GetPlayerName(playerid, Nick, sizeof(Nick));
    return Nick;
}

DCMD:servidor(user, channel, params[])
{
	new log01[64];
	format(log01, sizeof log01, "Jogadores Onlline: %d", joinquit);
	DCC_SendChannelMessage(channel, log01);
	return 1;
}



//TELEPORTES
CMD:ls(playerid)
{
    SetPlayerInterior(playerid, 0);
     SetPlayerVirtualWorld(playerid, 0);
      SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra Ls");
       SetPlayerPos(playerid, 1479.7734,-1706.5443,14.0469);
    return 1;
}
CMD:lv(playerid)
{
    SetPlayerPos(playerid,1569.0677,1397.1111,10.8460);
    SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra LV");
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}
CMD:sf(playerid)
{
    SetPlayerPos(playerid,-1988.3597,143.4470,27.5391);
    SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra SF");
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

CMD:pintar(playerid, params[])
{
	new cor1, cor2;
	new vehicleid = GetPlayerVehicleID(playerid);
    if(sscanf(params, "ii", cor1, cor2)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /pintar [COR] [COR]");
	ChangeVehicleColor(vehicleid, cor1, cor2);
	return 1;
}


CMD:nickon(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(playerid, i, true);
	GameTextForPlayer(playerid, "Os Nicks Foram Ativados!", 5000, 3);
	return 1;
}


CMD:nickoff(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(playerid, i, false);
	GameTextForPlayer(playerid, "Os Nicks Foram Desativados!", 5000, 3);
    return 1;
}


CMD:dia(playerid, params[])
{
	SendClientMessage(playerid, 0x80FF00FF, "{00FF00}[FIVE]{FFFFFF} Tempo Alterado Para Dia Com Sucesso !");
	SetPlayerTime(playerid, 12,0);
	return 1;
}

CMD:noite(playerid, params[])
{
	SendClientMessage(playerid, 0x80FF00FF, "{00FF00}[FIVE]{FFFFFF} Tempo Alterado Para Noite Com Sucesso !");
	SetPlayerTime(playerid, 00,0);
	return 1;
}

CMD:tarde(playerid, params[])
{
	SendClientMessage(playerid,0x80FF00FF,"{00FF00}[FIVE]{FFFFFF} Tempo Alterado Para Tarde Com Sucesso!");
	SetPlayerTime(playerid, 20, 0);
	return 1;
}


CMD:virar(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        new currentveh;
        new Float:angle;
        currentveh = GetPlayerVehicleID(playerid);
        GetVehicleZAngle(currentveh, angle);
        SetVehicleZAngle(currentveh, angle);
        SendClientMessage(playerid, 0xFFFFFFFF, "Voce virou seu carro!");
    }
    else
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "Voce nao esta em um veiculo");
    }
    return true;
}




CMD:testar(playerid)
{
    new name[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, name, sizeof name);
	if (_:g_Discord_Chat == 0)
	g_Discord_Chat = DCC_FindChannelById("996185610186391662"); // Discord channel ID
	new string[128];
	format(string, sizeof string, " %s Usou Comando /testar", name);
	DCC_SendChannelMessage(g_Discord_Chat, string);
    return 1;
}


stock VeiculoOcupado(vehicleid)
{
	for(new r = 0; r < MAX_PLAYERS; r++)
	{
		if(GetPlayerState(r) == PLAYER_STATE_DRIVER || GetPlayerState(r) == PLAYER_STATE_PASSENGER)
		{
			if(GetPlayerVehicleID(r) == vehicleid)
			{
				return 1;
			}
		}
	}
    return 0;
}