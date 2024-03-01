//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                             CREDITOS AO
//                              DEVSCRIPT
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



//___________INCLUDES________________//
#include <a_samp>
#include <DOF2>
#include <zcmd>
#include <Dini>
#include <sscanf2>
#include <streamer>
#include <float>
#include <foreach>
#include <discord-cmd>
#include <discord-connector>
#include <td-actions>


//___________MYSQL________________//
#define HOST      "localhost"
#define USUARIO   "root"
#define DATABASE  "FIVE"
#define SENHA     "five2024"



//___________PRAGMAS________________//
#pragma disablerecursion


//___________DEFINES CORES________________//
#define COR_MARROM 0x993300AA
#define COR_HELPER 0x2edaecFF
#define COR_ADM 0xFF1493FF
#define COR_VIP 0x00FFFFAA
#define COR_EMPRESA 0x458B00FF
#define COR_CASA 0xDCDCDCFF
#define COR_ERRO 0xDF3A01FF
#define COR_AZUL 0x058AFFFF
#define COR_AMARELO 0xFFFF00FF
#define COR_ROSA 0xFF05CDFF
#define COR_VERDE 0x33AA33AA
#define COR_BRANCO 0xFFFFFFAA
#define COR_VERMELHO 0xFF0000FF
#define COR_PRETO 0x000000FF
#define COR_CINZA 0x878787FF
#define COR_AZULCLARO 0x03F2FFFF
#define COR_VERDECLARO 0x03FF35FF
#define COR_ROXO 0x7D03FFFF
#define COR_ROXOCLARO 0x9A03FFFF
#define COR_LARANJA 0xFE642EFF

#define COR_UG 0x77786FFF
#define BRANCO  FFFFFF

//___________DEFINES________________//
#define PASTA_CONTAS                                                            "Accounts/%s.ini"
#define SCM                                                                     SendClientMessage
#define ISP                                                                     IsPlayerInRangeOfPoint
#define IPC                                                                     IsPlayerConnected
#define D_SENHA                                                                 0
#define D_GENERO                                                                1
#define D_ADMINISTRADOR                                                         2
#define PlayerToPoint(%1,%2,%3)     IsPlayerInRangeOfPoint(%2,%1,%3)
#define DIALOG_ESCOLHER_LADO        34

#define varGet(%0)      getproperty(0,%0)
#define varSet(%0,%1)   setproperty(0, %0, %1)
#define new_strcmp(%0,%1) \
                (varSet(%0, 1), varGet(%1) == varSet(%0, 0))



//___________NEWS_________//
new Policial[MAX_PLAYERS] = 0;
new Bandido[MAX_PLAYERS] = 0;
new Policial_Equipado[MAX_PLAYERS] = 0;


#define Garagem_Bandidos                  48
#define Garagem_Policiais                 49

#define Skins_Policiais                   51
#define Skins_Bandidos                    52

#define SkinsMasculinas_Bandidos          70
#define SkinsFemininas_Bandidos           71
#define SkinsMasculinas_Policiais         72
#define SkinsFemininas_Policiais          73


new String[128];
new tmpobjid;
new Text:LoadingInteriorG[13];

//___________FORWARD_________//



//___________DISCORD CONNECTOR_________//
new DCC_Channel:statuschannel; //SERVER ON
new joinquit;
new DCC_Channel:joinquitlog;



//___________ENUMS_________//
enum pInfo
{
    Senha[20],
    Dinheiro,
    Level,
    Skin,
    Genero,
    Admin,
    Interior,
	VirtualW
};
new info[MAX_PLAYERS][pInfo];
//
new arquivo[128];
new VSenha[MAX_PLAYERS][20];
new VGenero[MAX_PLAYERS];
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


//___________GAMEMODE_________//

main()
{
	joinquitlog = DCC_FindChannelById("1113604639493996615");
}

public OnGameModeInit()
{
    // ManualVehicleEngineAndLights();
    ShowPlayerMarkers(0);
	ShowNameTags(1);
	UsePlayerPedAnims();
	DisableInteriorEnterExits();
 	EnableStuntBonusForAll(0);
    SetGameModeText("BETA");
	
	CreatePickup(19132, 1, 3406.7095, -1677.8269, 7.5313, 0); //LOBBY
    Create3DTextLabel("{836FFF}Five Lobby\n{FFFFFF}Use {836FFF}/escolher {FFFFFF}Para Ser Policial ou Bandido", COR_AMARELO, 3406.7095,-1677.8269,7.5313, 58.0685, 0, 0); //LOBBY
    Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /garagem", -1, 2536.6902, -920.2032, 86.6194, 30.0, 0, 0); //GARAGEM BANDIDOS
    CreatePickup(19134, 23, 2536.6902, -920.2032, 86.6194); //GARAGEM BANDIDOS

	Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /garagem", -1, 1588.4276, -1692.5383, 6.2188, 30.0, 0, 0); //GARAGEM POLICIAIS
    CreatePickup(19134, 23, 1588.4276, -1692.5383, 6.2188); //GARAGEM POLICIAIS

	Create3DTextLabel("{FFFFFF}DELEGACIA\n{836FFF}Digite /entrar Para Entrar Na DELEGACIA",0xFFA500AA,1555.5005,-1675.6212,16.1953,10.0,0);
    AddStaticPickup(1318, 24, 1555.5005,-1675.6212,16.1953);//ENTRAR DELEGACIA
    
    Create3DTextLabel("{FFFFFF}DELEGACIA\n{836FFF}Digite /sair ou aperte F Para sair da DELEGACIA",0xFFA500AA,651.6869,2539.6213,-89.4551,10.0,0);
    AddStaticPickup(1318, 24, 651.6869,2539.6213,-89.4551);// SAIR DELEGACIA
    
    
    statuschannel = DCC_FindChannelById("1213156618829701200");
    new DCC_Embed:embed = DCC_CreateEmbed("**Servidor Onlline**", "IP: 51.81.166.66:23698", "", "", 129310, "Five Fugas 2024", "https://cdn.discordapp.com/attachments/988186288731607090/995891326937739264/IMG_20220711_000621.png", "https://cdn.discordapp.com/attachments/988186288731607090/995891326937739264/IMG_20220711_000621.png", "https://cdn.discordapp.com/attachments/988186288731607090/998582721649594469/online.png");
    DCC_SendChannelEmbedMessage(statuschannel, embed, "");
	
	
	
	//[ MAPA DP ]
	CreateObject(2921, 1577.3, -1633, 16.8, 0, 0, 0);
    CreateObject(2920, 1544.7, -1630.8, 13, 0, 0, 0);
    CreateObject(997, 1605.7, -1686.3, 4.9, 0, 0, 270);
    CreateObject(997, 1605.4, -1694.4, 4.9, 0, 0, 270);
    CreateObject(997, 1605.3, -1702.6, 4.9, 0, 0, 270);
    CreateObject(997, 1605.5, -1690.4004, 4.9, 0, 0, 270);
    CreateObject(997, 1605.3, -1682.3, 4.9, 0, 0, 270);
    CreateObject(997, 1605.5, -1698.5, 4.9, 0, 0, 270);
    CreateObject(1251, 1601.1, -1690, 5, 0, 0, 270);
    CreateObject(1251, 1607.4, -1686, 5, 0, 0, 270);
    CreateObject(1251, 1607.7, -1682, 5, 0, 0, 270);
    CreateObject(1251, 1607.9, -1690, 5, 0, 0, 270);
    CreateObject(1251, 1607.6, -1694, 5, 0, 0, 270);
    CreateObject(1251, 1607.3, -1698.3, 5, 0, 0, 270);
    CreateObject(1251, 1607.3, -1702, 5, 0, 0, 270);
    CreateObject(1251, 1607, -1706.3, 5, 0, 0, 270);
    CreateObject(1251, 1600.9, -1682, 5, 0, 0, 270);
    CreateObject(1251, 1600.9004, -1686, 5, 0, 0, 270);
    CreateObject(1251, 1601.1, -1694, 5, 0, 0, 270);
    CreateObject(1251, 1600.9, -1698.3, 5, 0, 0, 270);
    CreateObject(1251, 1601, -1702, 5, 0, 0, 270);
    CreateObject(1251, 1600.6, -1706.3, 5, 0, 0, 270);
    CreateObject(1424, 1536, -1663.4, 13.1, 0, 0, 0);
    CreateObject(1424, 1536, -1682.1, 13.1, 0, 0, 0);
    CreateObject(997, 1537.8, -1663.9, 12.5, 0, 0, 270);
    CreateObject(997, 1537.8, -1667.2, 12.5, 0, 0, 270);
    CreateObject(997, 1537.8, -1670.6, 12.5, 0, 0, 270);
    CreateObject(997, 1537.8, -1678.4, 12.5, 0, 0, 270);
    CreateObject(997, 1537.8, -1675.1, 12.5, 0, 0, 270);
    CreateObject(1251, 1534.3, -1667.3, 12.344, 0, 0, 0);
    CreateObject(1251, 1534.3, -1674.1, 12.344, 0, 0, 0);
    CreateObject(1251, 1534.3, -1679.4, 12.344, 0, 0, 0);
    CreateObject(4639, 1586.3, -1692, 6.9, 0, 0, 92);
    CreateObject(1237, 1536.9, -1635.6, 12.5, 0, 0, 0);
    CreateObject(1237, 1542.1, -1634.2, 12.5, 0, 0, 0);
    CreateObject(1237, 1537.0996, -1619.0996, 12.5, 0, 0, 0);
    CreateObject(1237, 1536.5, -1613.6, 12.5, 0, 0, 0);
    CreateObject(1237, 1542.2002, -1621.2002, 12.5, 0, 0, 0);
    CreateObject(1237, 1536.1, -1640.1, 12.5, 0, 0, 0);
    CreateObject(11453, 1519.3, -1659.6, 15.3, 0, 0, 274);
    CreateObject(715, 1520, -1651.7, 20.4, 0, 0, 0);
    CreateObject(715, 1521.6, -1669.8, 20.4, 0, 0, 0);
    CreateObject(10401, 1566.5, -1605, 14.7, 0, 0, 46);
    CreateObject(1652, 1566.8, -1620.2, 13.2, 0, 0, 0);
    CreateObject(1652, 1566.7998, -1620.2002, 13.2, 0, 0, 180);
    CreateObject(1423, 1539.5, -1620.8, 13.3, 0, 0, 336);
    CreateObject(1423, 1539.3, -1634.6, 13.3, 0, 0, 17.995);
    CreateObject(1423, 1536.2, -1637.9, 13.3, 0, 0, 85.99);
    CreateObject(1423, 1536.5, -1616.4, 13.3, 0, 0, 89.985);
    CreateObject(970, 1551.7, -1619.1, 13.1, 0, 0, 328);
    CreateObject(2938, 1587, -1635.3, 17.44, 0, 80, 272);



    //[ LOBBY ]
    CreateObject(7983, 3385.8999, -1722.6, 30, 0, 0, 320);
    CreateObject(13725, 3410.7, -1723.4, 27, 0, 0, 0);
    CreateObject(715, 3405.2, -1647, 15.3, 0, 0, 0);
    CreateObject(715, 3419.3999, -1647.2, 15.3, 0, 0, 0);
    CreateObject(715, 3433.8999, -1650, 15.3, 0, 0, 86);
    CreateObject(7017, 3475, -1680.6, 7.3, 0, 0, 126);
    CreateObject(7017, 3429, -1642.9, 7.3, 0, 0, 149.997);
    CreateObject(7017, 3407.8999, -1639, 7.3, 0, 0, 163.996);
    CreateObject(7017, 3408.5, -1642.2, 7.3, 0, 0, 183.993);
    CreateObject(7017, 3356.5, -1658.3, 7.3, 0, 0, 203.988);
    CreateObject(7017, 3357.8, -1660.2, 7.3, 0, 0, 223.983);
    CreateObject(7017, 3490.8999, -1727.6, 7.3, 0, 0, 101.997);
    CreateObject(7017, 3485.1001, -1754.9, 7.3, 0, 0, 83.997);
    CreateObject(7017, 3469.8, -1779.2, 7.3, 0, 0, 63.996);
    CreateObject(7017, 3447.3999, -1796.2, 7.3, 0, 0, 43.995);
    CreateObject(7017, 3421, -1804.7, 7.3, 0, 0, 23.995);
    CreateObject(7017, 3390.6001, -1804.4, 7.3, 0, 0, 3.994);
    CreateObject(12843, 252.80469, -56.84375, 0.57813, 0, 0, 0);
    CreateObject(12843, 3462.3999, -1725.3, 6.3, 0, 0, 270);
    CreateObject(2387, 3461.8, -1716.2, 6.4, 0, 0, 0);
    CreateObject(2387, 3464, -1716.1, 6.4, 0, 0, 0);
    CreateObject(2375, 3466.7, -1724.3, 6.4, 0, 0, 90);
    CreateObject(2362, 3467.3999, -1728.3, 8.1, 0, 0, 274);
    CreateObject(1616, 3457.3999, -1729.6, 10.1, 0, 0, 0);
    CreateObject(2494, 3467.2, -1727.2, 7, 0, 0, 264);
    CreateObject(2586, 3465.2, -1723.2, 6.9, 0, 0, 270);
    CreateObject(2698, 3461.8999, -1728.7, 7.4, 0, 0, 0);
    CreateObject(9244, 3411.3999, -1665.9, 11.8, 0, 0, 266);
    CreateObject(4641, 3404.8, -1676.5, 8.2, 0, 0, 58);
    CreateObject(715, 3395.3999, -1712.3, 14.44, 0, 0, 0);
    CreateObject(715, 3389.7, -1714.4, 14.4, 0, 0, 0);
    CreateObject(715, 3384.8, -1714.7, 14.4, 0, 0, 0);
    CreateObject(715, 3379.3, -1714.5, 14.4, 0, 0, 0);
    CreateObject(715, 3372.5, -1713.2, 14.4, 0, 0, 0);
    CreateObject(715, 3367.5, -1711.5, 14.4, 0, 0, 0);
    CreateObject(715, 3366, -1730.1, 14.4, 0, 0, 0);
    CreateObject(715, 3373.2, -1729.4, 14.4, 0, 0, 0);
    CreateObject(715, 3380.2, -1729.3, 14.4, 0, 0, 2);
    CreateObject(715, 3386.2, -1729.2, 14.4, 0, 0, 6);
    CreateObject(715, 3391.2, -1729.4, 14.4, 0, 0, 5.999);
    CreateObject(715, 3396.8, -1732.5, 14.4, 0, 0, 5.999);
    CreateObject(715, 3427.5, -1732, 14.4, 0, 0, 5.999);
    CreateObject(715, 3432.1001, -1730, 14.4, 0, 0, 5.999);
    CreateObject(715, 3436.8999, -1729.7, 14.4, 0, 0, 7.999);
    CreateObject(715, 3441.6001, -1729.7, 14.4, 0, 0, 7.998);
    CreateObject(715, 3447.8, -1729.6, 14.4, 0, 0, 7.998);
    CreateObject(715, 3453.8, -1730.6, 14.4, 0, 0, 7.998);
    CreateObject(715, 3458.8999, -1733.4, 14.4, 0, 0, 7.998);
    CreateObject(715, 3459, -1713.1, 14.4, 0, 0, 7.998);
    CreateObject(715, 3452.1001, -1714.7, 14.4, 0, 0, 7.998);
    CreateObject(715, 3446.7, -1715.4, 14.4, 0, 0, 7.998);
    CreateObject(715, 3441.7, -1716, 14.4, 0, 0, 7.998);
    CreateObject(715, 3434.6001, -1715.6, 14.4, 0, 358, 7.998);
    CreateObject(715, 3428.3, -1713.4, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3420.5, -1705.1, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3418.8999, -1699.3, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3418.8, -1693, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3418.7, -1686, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3420.3, -1679.5, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3422.8, -1674.3, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3403.6001, -1675.7, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3404.8999, -1681.9, 14.4, 0, 357.995, 7.993);
    CreateObject(715, 3405.2, -1687.7, 14.4, 0, 357.995, 9.993);
    CreateObject(715, 3405.1001, -1692.6, 14.4, 0, 357.99, 11.992);
    CreateObject(715, 3404.7, -1697.9, 14.4, 0, 357.984, 13.992);
    CreateObject(715, 3403.1001, -1703, 14.4, 0, 357.979, 13.991);

	//OBJETO ROUPA BANDIDO
	CreateObject(2375, 2548.5280, -925.5023, 83.3540, 0.0000, 0.0000, -71.8999);

	//CASINHA FAVELA CAMPINHO
	CreateObject(19362, 2591.1799, -870.8166, 82.9941, -0.5999, -90.1000, -75.6999); //wall010
	CreateObject(19362, 2588.0783, -871.6062, 83.0276, -0.5999, -90.1000, -75.6999); //wall010
	CreateObject(19367, 2592.7043, -870.5736, 84.6540, 0.0000, 0.0000, 14.1999); //wall015
	CreateObject(19367, 2586.5134, -872.1610, 84.6740, 0.0000, 0.0000, 14.1999); //wall015
	CreateObject(19437, 2586.7285, -870.1879, 84.6666, 1.2000, 0.6999, -54.3999); //wall077
	CreateObject(19392, 2589.9599, -872.7633, 84.6828, 0.0000, 0.0000, -75.1999); //wall040
	CreateObject(19437, 2587.6843, -873.4650, 84.6659, 0.0000, 0.0000, -74.2999); //wall077
	CreateObject(19437, 2592.2807, -872.2667, 84.6659, 0.0000, 0.0000, -74.2999); //wall077
	CreateObject(19362, 2591.1484, -870.7270, 86.3342, -0.5999, -90.1000, -75.6999); //wall010
	CreateObject(19362, 2588.0498, -871.5160, 86.3576, -0.5999, -90.1000, -75.6999); //wall010
	CreateObject(19437, 2592.0500, -869.1771, 84.4517, 1.2000, 0.6999, -143.8999); //wall077


	//[ INTERIOR DELEGACIA ]
	tmpobjid = CreateDynamicObjectEx(19376, 666.860229, 2532.298583, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.362854, 2541.928710, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.361816, 2532.298339, -85.407066, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 651.220458, 2541.876708, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 651.220092, 2532.267333, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 658.477539, 2546.527832, -82.710548, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1569, 651.279663, 2537.439697, -90.455001, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4552, "ammu_lan2", "corporate1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1569, 651.272888, 2540.439697, -90.455001, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4552, "ammu_lan2", "corporate1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 652.743774, 2544.451660, -91.071418, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 652.144714, 2546.515136, -90.456199, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 647.348205, 2546.528076, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 652.860473, 2546.529541, -86.205177, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 658.477111, 2546.533691, -94.812896, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 661.388183, 2546.531005, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1897, 656.628112, 2546.504394, -89.070800, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 658.951599, 2551.344238, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 654.151245, 2552.647949, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 655.602600, 2544.454101, -90.155288, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19925, 657.466430, 2544.455810, -90.155296, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 652.744018, 2544.447509, -84.891899, 180.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 655.602661, 2544.452148, -91.071403, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19925, 657.467163, 2544.454101, -91.071403, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 649.710876, 2533.551269, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 654.479858, 2533.537841, -90.456199, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14577, "casinovault01", "cof_wood1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 668.949218, 2533.541259, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 662.623229, 2533.525634, -90.456199, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14577, "casinovault01", "cof_wood1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19325, 659.308166, 2533.538818, -87.601699, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0xFF0099FF);
	tmpobjid = CreateDynamicObjectEx(1897, 653.609313, 2546.541992, -89.070800, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 656.002624, 2533.565917, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.361816, 2532.298339, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.362915, 2541.928710, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 657.590332, 2533.533447, -91.316001, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 655.183959, 2533.525146, -86.205177, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 660.801879, 2533.532470, -91.316001, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 661.023681, 2533.534179, -91.314002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 659.281188, 2528.713867, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 649.717956, 2533.557128, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 676.113281, 2531.929687, -86.616096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9220, "sfn_apart02sfn", "concreteslab", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 676.132080, 2541.568603, -86.338691, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.361145, 2522.667968, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.858032, 2522.667724, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 663.432128, 2533.539550, -86.205177, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1897, 655.933898, 2533.551025, -86.234382, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1897, 655.934082, 2533.549072, -88.455673, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1897, 662.680236, 2533.525146, -86.488906, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1897, 662.679565, 2533.525146, -88.455703, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 658.498718, 2533.541992, -89.441047, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 660.952392, 2533.542724, -89.441047, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 662.572509, 2533.542724, -89.441047, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 660.952392, 2533.542724, -89.291000, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 658.498718, 2533.541992, -89.291000, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.770385, 2542.421875, -89.347900, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 658.498718, 2533.541992, -89.191001, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 660.952392, 2533.542724, -89.191001, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 662.572509, 2533.542724, -89.191001, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 668.575073, 2528.701416, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 650.459533, 2527.719238, -90.456901, 0.000000, 0.000000, 70.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 654.746459, 2526.090576, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 664.073059, 2526.227539, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.857971, 2522.667724, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.361083, 2522.667968, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 666.190368, 2546.499267, -90.456199, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14577, "casinovault01", "cof_wood1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 666.896057, 2546.530517, -86.201202, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 652.743774, 2544.453613, -90.155288, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 655.602600, 2544.454101, -85.673103, 180.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19925, 657.466369, 2544.455810, -85.673103, 180.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.714172, 2546.440185, -85.794837, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.860595, 2551.562500, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.861999, 2561.194824, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 656.911315, 2556.094482, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 661.639465, 2560.823486, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 666.465576, 2565.479492, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.728881, 2551.257568, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.728210, 2560.885498, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 652.743774, 2544.453613, -85.673072, 180.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19929, 655.602661, 2544.447998, -84.891899, 180.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19925, 657.469238, 2544.450439, -84.891899, 180.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 670.885986, 2535.195312, -90.456199, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14577, "casinovault01", "cof_wood1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.880310, 2530.415283, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 670.879089, 2535.903076, -86.205200, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(14411, 673.935485, 2534.822998, -93.649299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.768310, 2533.547607, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.880981, 2538.312011, -88.744056, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.880004, 2541.513183, -85.249496, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1499, 670.834167, 2544.632324, -90.456199, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1730, "cj_furniture", "CJ_WOOD5", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14577, "casinovault01", "cof_wood1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.846740, 2549.427978, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 670.843383, 2543.935302, -86.199203, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.859252, 2541.930664, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.608093, 2536.970947, -96.319816, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 676.103271, 2541.685791, -90.537101, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 684.494995, 2547.747558, -95.690399, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 684.495483, 2557.380371, -95.690399, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 685.388366, 2533.541503, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 672.511779, 2546.523925, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 685.347961, 2546.441894, -85.794837, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 685.668457, 2532.077392, -91.155410, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9220, "sfn_apart02sfn", "concreteslab", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.608032, 2536.794189, -85.794837, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 685.229980, 2536.792480, -85.794837, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 690.002929, 2550.644042, -91.942550, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 11301, "carshow_sfse", "concreteslab_small", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 680.443847, 2547.885986, -96.416549, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 684.445983, 2541.704589, -85.794799, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 684.825622, 2531.422851, -96.263969, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 680.442321, 2557.513671, -96.416549, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 684.784301, 2539.583496, -90.357498, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19302, 684.781188, 2542.054931, -94.392997, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19362, 684.735107, 2544.529541, -93.857696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19302, 685.377807, 2546.757568, -94.392997, 0.000000, 0.000000, 46.790290, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19362, 684.734436, 2549.496337, -93.857696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19302, 684.797668, 2551.979003, -94.392997, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19362, 684.742370, 2554.453369, -93.857696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 684.784301, 2539.583496, -93.857696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 684.735107, 2544.529541, -90.357498, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 684.734375, 2549.496337, -90.357498, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 684.742370, 2554.453369, -90.357498, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 673.993530, 2541.327636, -95.690406, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.315612, 2541.626953, -95.814559, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 679.330322, 2541.706542, -90.539100, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 679.530090, 2541.696777, -91.155410, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9220, "sfn_apart02sfn", "concreteslab", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19302, 685.356628, 2537.337646, -94.392997, 0.000000, 0.000000, 309.138275, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19304, 684.789428, 2542.605224, -92.515602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19304, 684.782714, 2547.407226, -92.515602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19304, 684.788757, 2552.620361, -92.515602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19304, 684.805725, 2537.878906, -92.515602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObjectEx(19376, 684.495727, 2538.114013, -95.690406, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 690.002441, 2541.014404, -91.942550, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 11301, "carshow_sfse", "concreteslab_small", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 684.849670, 2550.862304, -86.605201, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 684.841735, 2538.115478, -86.605201, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 679.534606, 2551.308837, -91.155410, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9220, "sfn_apart02sfn", "concreteslab", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 690.005432, 2531.389404, -91.942550, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 11301, "carshow_sfse", "concreteslab_small", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.477844, 2554.572509, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.528503, 2539.685302, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.476806, 2544.529785, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.616210, 2550.554199, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.801025, 2549.689453, -96.416549, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.805419, 2540.059570, -96.416549, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.804809, 2530.428710, -96.416549, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 679.921447, 2554.856445, -96.416496, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.714660, 2543.157470, -96.416496, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.871459, 2541.513916, -91.310501, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.881042, 2538.312255, -85.249496, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 665.634826, 2533.567382, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 675.257812, 2533.568115, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.235473, 2538.453125, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.232177, 2548.043945, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.852844, 2538.333984, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.835632, 2547.038818, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 662.601013, 2546.518310, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 672.201293, 2546.514648, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.233764, 2538.418212, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.231689, 2548.041259, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 668.942810, 2533.542480, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 658.473754, 2546.522949, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 647.351867, 2546.525878, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 661.390075, 2546.525390, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 672.509704, 2546.518066, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.836242, 2549.426513, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.872680, 2530.415039, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.878051, 2541.513183, -88.739906, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "cj_bricks", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.871887, 2538.315917, -91.310501, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 664.060302, 2526.230957, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 668.570556, 2528.706298, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 659.283996, 2528.625244, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 654.442260, 2526.093505, -94.813499, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 652.666320, 2526.920410, -94.813499, 0.000000, 0.000000, 70.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 659.280456, 2528.628417, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.223144, 2528.767089, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 657.592590, 2533.536621, -91.314002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 649.716247, 2533.544189, -94.813499, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 661.024047, 2533.536132, -91.316001, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 660.801879, 2533.536376, -91.316001, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 654.428710, 2526.091796, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 664.093017, 2526.257568, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 668.550048, 2528.710693, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 663.798278, 2533.512207, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 654.309326, 2533.513427, -80.465728, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 659.285949, 2528.708007, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 659.268249, 2528.642578, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.244567, 2528.645751, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 653.834777, 2526.510253, -80.465698, 0.000000, 0.000000, 70.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 675.610778, 2536.791015, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.876281, 2530.414794, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 670.877075, 2535.902832, -86.205200, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 676.166259, 2531.935058, -88.161201, 0.000000, -55.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9220, "sfn_apart02sfn", "concreteslab", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.860229, 2532.298583, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 661.391357, 2546.535644, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 672.508911, 2546.528808, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 656.911621, 2556.089111, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 661.643249, 2560.819580, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.724975, 2560.646240, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.723022, 2551.382324, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.860595, 2551.562500, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 656.363098, 2551.558349, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.861999, 2561.194824, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 665.916198, 2546.536132, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 656.297424, 2546.526123, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 656.913696, 2556.092041, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 666.519592, 2565.472656, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 658.959167, 2551.374755, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.720886, 2551.437744, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.721740, 2561.000732, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 658.952575, 2551.400634, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 661.646545, 2560.822265, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 661.388244, 2546.527099, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 672.511901, 2546.520019, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 666.896118, 2546.528564, -86.201202, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.546691, 2551.413574, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 647.351257, 2546.546386, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 658.950561, 2551.393554, -94.813499, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 654.118347, 2552.643310, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 646.710754, 2546.525634, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 656.282348, 2546.533935, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 654.084838, 2552.637207, -80.465698, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 658.943115, 2551.265869, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 651.549072, 2551.325683, -80.465698, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 666.859313, 2541.930664, -85.407096, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19376, 686.623046, 2541.605468, -86.338691, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, "labig1int2", "ab_mottleGrey", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 675.683654, 2546.433349, -81.375740, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 685.262451, 2546.435058, -81.375740, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 675.701843, 2536.800292, -81.375740, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 685.330688, 2536.798828, -81.375740, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 670.883056, 2541.684326, -81.375679, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 670.839355, 2543.935058, -86.199203, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 670.838684, 2549.427490, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.874023, 2541.513183, -88.739906, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.877014, 2538.312255, -88.744056, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.875976, 2541.513183, -85.249496, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 670.877014, 2538.312255, -85.249496, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 689.583374, 2541.578613, -89.982803, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 655.480957, 2549.728515, -90.539001, 0.000000, 90.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14777, "int_casinoint3", "GB_midbar05", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 663.085021, 2539.835449, -90.535003, 0.000000, 90.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "ab_tileStar2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 661.787536, 2538.537353, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 664.387390, 2541.136230, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 664.513427, 2538.865234, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 664.057250, 2538.411621, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 662.120605, 2541.262207, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 661.664428, 2540.808593, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 660.230895, 2546.066650, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 660.810791, 2546.065917, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 661.374816, 2546.062500, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 661.934875, 2546.057861, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 662.502807, 2546.062500, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 649.730407, 2540.492431, -89.695602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 649.733764, 2537.356201, -89.695602, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 649.715270, 2537.951660, -89.480613, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 649.704711, 2538.919677, -87.867599, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 649.706970, 2539.872314, -89.480613, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(638, 670.229187, 2539.886962, -89.902099, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3314, "ce_burbhouse", "sw_wallbrick_06", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(631, 670.358398, 2542.050781, -89.537902, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(631, 670.374023, 2537.808105, -89.537902, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(13188, 670.815307, 2539.971679, -88.029663, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19173, "samppictures", "samppicture1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 684.382751, 2541.569091, -88.667541, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19162, "newpolicehats", "policehatmap1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19099, "policecaps", "policecap2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 662.572509, 2533.542724, -89.291000, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.776916, 2542.399658, -86.724098, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.776916, 2542.399658, -86.876098, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.778198, 2537.546142, -86.876098, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.778198, 2537.546142, -86.724098, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.771423, 2539.992919, -86.712097, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.770385, 2542.421875, -86.712097, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.771423, 2539.992919, -89.347900, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 684.429809, 2541.581054, -81.375701, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 689.582275, 2541.461425, -87.368911, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 689.152282, 2545.037597, -85.337356, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 689.154235, 2538.233398, -85.337356, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1713, 656.638671, 2547.105712, -90.453903, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "CJ_CUSHION2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14534, "ab_wooziea", "ab_tileDiamond", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1714, "cj_office", "CJ_CUSHION2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 657.247131, 2540.935791, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19362, 658.343139, 2539.631591, -90.539001, 0.000000, 90.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "ab_tileStar2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 657.041320, 2540.729003, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 657.167846, 2538.458496, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 659.437255, 2538.328857, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 659.893432, 2538.782470, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19366, 659.517028, 2540.808349, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2616, 662.606811, 2526.368164, -88.598808, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 659.149108, 2527.713134, -88.597290, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 14489, "carlspics", "AH_picture4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1761, 658.555969, 2532.668457, -90.454299, 0.000000, 0.000000, 272.160095, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14534, "ab_wooziea", "ab_tileDiamond", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(631, 658.795837, 2529.498779, -89.573997, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(2267, 659.160827, 2531.740478, -88.086997, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 12855, "cunte_cop", "sw_PD", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2686, 659.168884, 2526.573730, -88.822601, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14593, "papaerchaseoffice", "sign_noCamera", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 652.212524, 2527.247558, -88.093292, 0.000000, 0.000000, 160.445785, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2612, 653.804321, 2526.664306, -88.677886, 0.000000, 0.000000, 160.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 4, 14489, "carlspics", "AH_picture4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 14489, "carlspics", "AH_picture4", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 653.350402, 2532.970214, -88.677619, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 3262, "privatesign", "sw_hairpinL", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 652.088928, 2532.942871, -87.968566, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 19784, "matpoliceinsignias", "sergeant2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1761, 666.810852, 2526.844238, -90.454299, 0.000000, 0.000000, 180.759262, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "CJ_CUSHION2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(631, 667.855102, 2526.915039, -89.571998, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(2611, 660.656616, 2526.357666, -88.093299, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 663.049316, 2526.806884, -87.505599, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 659.418090, 2530.297119, -88.595291, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 660.967773, 2526.320800, -89.728500, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 657.538635, 2526.169921, -89.728500, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 664.257202, 2526.322509, -89.728500, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 665.477478, 2526.333984, -87.844367, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_landscap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2281, 667.130798, 2526.798828, -88.745903, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 19099, "policecaps", "policecap2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2056, 659.401977, 2528.684326, -89.225601, 0.000000, 4.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture4", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2056, 659.395324, 2529.124755, -89.225601, 0.000000, -2.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2619, 668.467102, 2528.344726, -87.911743, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19099, "policecaps", "policecap2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2056, 668.435913, 2527.928955, -88.603233, 0.000000, 4.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1761, 668.919738, 2534.193847, -90.454299, 0.000000, 0.000000, 180.759262, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9947, "lombard", "lombard_build3_3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14534, "ab_wooziea", "ab_tileDiamond", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2310, 663.083374, 2546.061767, -89.957298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 686.770568, 2544.644531, -93.716667, 0.000000, 90.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 688.723876, 2531.449951, -90.456901, 0.000000, 0.000000, 54.167839, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2277, 689.223388, 2546.664550, -93.766899, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2273, 688.748413, 2545.103759, -94.038917, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_landscap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2277, 689.210510, 2545.223632, -93.262893, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture4", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2056, 688.801452, 2547.966064, -94.488601, 0.000000, 10.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture4", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19329, 668.493347, 2546.425292, -88.160644, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} ADMINISTRATION", 120, "Ariel", 22, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(19329, 670.723632, 2545.388671, -88.160644, 0.000000, 0.000000, -90.199951, 120.00, 120.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} EQUIPMENT", 120, "Ariel", 22, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(2056, 688.807495, 2537.105712, -94.488601, 0.000000, 10.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2268, 689.225952, 2535.070312, -94.042427, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2277, 689.229431, 2535.804199, -93.766899, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2277, 689.216552, 2534.363281, -93.262893, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 686.773315, 2533.682617, -93.526672, 0.000000, 90.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19787, 677.938354, 2543.013916, -93.641403, 10.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "a51_monitors", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19787, 676.399353, 2542.881591, -93.641403, 10.000000, 0.000000, 10.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "a51_monitors", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19787, 679.469055, 2542.878417, -93.641403, 10.000000, 0.000000, -10.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "a51_monitors", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(18762, 680.156250, 2544.724365, -93.546958, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(18762, 680.167968, 2552.844970, -93.546958, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(18762, 682.680358, 2555.182128, -93.546958, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(18762, 680.146545, 2548.571777, -93.546958, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "man_cellarfloor128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19972, 681.410705, 2536.864013, -90.664176, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 2, 5818, "billbrdlawn", "semi1Dirty", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 668.487609, 2545.937500, -88.497398, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4600, "theatrelan2", "sl_whitewash1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14569, "traidman", "darkgrey_carpet_256", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 675.842102, 2546.946044, -90.438697, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 675.842102, 2546.946044, -89.759613, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 675.842102, 2546.946044, -89.157623, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 675.842102, 2546.946044, -87.742576, 0.000000, 90.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 672.417114, 2546.944824, -91.083000, 90.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 679.204223, 2546.948242, -91.083000, 90.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3980, "cityhall_lan", "cityhalltow1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(13187, 675.855041, 2546.344970, -89.095497, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "steel256128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2280, 678.634338, 2537.395263, -88.232696, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ziplogo1_128", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2280, 660.200988, 2545.947265, -88.232696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19162, "newpolicehats", "policehatmap2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18800, "mroadhelix1", "concretemanky1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2283, 674.944824, 2536.908203, -88.377098, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ziplogo1_128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 5818, "billbrdlawn", "semi1Dirty", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19972, 677.227050, 2536.864013, -91.291763, 0.000000, 2.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 2, 5818, "billbrdlawn", "semi2Dirty", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 665.977722, 2565.473144, -94.813476, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 665.615600, 2551.485839, -80.265701, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 664.829101, 2549.704345, -83.765998, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 664.862487, 2553.915771, -83.765998, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 667.450683, 2553.909179, -84.708396, 90.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 667.414184, 2549.704589, -84.708396, 90.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19381, 665.616577, 2557.688720, -80.263702, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 667.294677, 2558.169921, -84.708396, 90.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 667.327453, 2562.407470, -84.708396, 90.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 664.744934, 2558.167724, -83.763999, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19439, 664.763793, 2562.417480, -83.763999, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5406, "jeffers5a_lae", "vgshopwall05_64", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2167, 661.751892, 2557.529785, -90.455703, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2167, 670.668334, 2558.857910, -90.455703, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2164, 670.632263, 2557.882324, -90.455398, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "wood01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1761, 664.666870, 2547.214843, -90.454299, 0.000000, 0.000000, 180.759262, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "CJ_CUSHION2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1761, 662.266906, 2558.668701, -90.454299, 0.000000, 0.000000, 90.759300, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 2767, "cb_details", "pattern1_cb", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(631, 661.989318, 2555.824218, -89.567901, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(631, 670.061035, 2549.453857, -89.567901, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF00);
	tmpobjid = CreateDynamicObjectEx(2266, 667.171508, 2561.577880, -89.530799, -4.000000, 0.000000, 87.883018, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.671508, 2561.602539, -89.681999, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.656677, 2561.608642, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.218017, 2561.641601, -89.594802, 4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 667.106384, 2557.073730, -89.530799, -4.000000, 0.000000, 94.025802, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.615844, 2557.046386, -89.681999, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.620666, 2557.056396, -89.646003, 90.000000, 0.000000, 94.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.152099, 2557.026367, -89.594802, 4.000000, 0.000000, 994.025817, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 667.164184, 2552.768066, -89.530799, -4.000000, 0.000000, 94.025802, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.673583, 2552.741699, -89.690002, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.666564, 2552.750000, -89.646003, 90.000000, 0.000000, 94.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.209899, 2552.720703, -89.594802, 4.000000, 0.000000, 994.025817, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 667.157287, 2555.598876, -89.530799, -4.000000, 0.000000, 87.883018, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.667724, 2555.638427, -89.690002, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.666259, 2555.628173, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.203796, 2555.662597, -89.594802, 4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 667.198791, 2559.776855, -89.530799, -4.000000, 0.000000, 87.883018, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.709716, 2559.812500, -89.694000, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.712951, 2559.808593, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.245300, 2559.840576, -89.594802, 4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 667.237548, 2551.263427, -89.530799, -4.000000, 0.000000, 87.883018, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.284057, 2551.327148, -89.594802, 4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 666.747680, 2551.288085, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 666.746276, 2551.281005, -89.690002, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 667.001098, 2551.253662, -89.626403, 0.000000, 0.000000, 84.962471, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 666.990966, 2552.759033, -89.626403, 0.000000, 0.000000, 98.966316, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 666.956604, 2555.614013, -89.626403, 0.000000, 0.000000, 84.962471, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 666.982421, 2557.137207, -89.626403, 0.000000, 0.000000, 93.318206, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 666.947631, 2559.822509, -89.626403, 0.000000, 0.000000, 84.962471, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 666.973144, 2561.617675, -89.626403, 0.000000, 0.000000, 93.318206, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 665.264648, 2561.522460, -89.534797, -4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.227905, 2561.454345, -89.602798, 4.000000, 0.000000, 87.410896, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 665.755676, 2561.487548, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 665.748046, 2561.489990, -89.690002, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 665.799499, 2551.402099, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 665.308471, 2551.437011, -89.534797, -4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 665.791870, 2551.404541, -89.702003, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.271728, 2551.368896, -89.602798, 4.000000, 0.000000, 87.410896, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 665.745544, 2553.012451, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 665.254516, 2553.047363, -89.534797, -4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 665.733947, 2553.014404, -89.697998, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.217773, 2552.979248, -89.602798, 4.000000, 0.000000, 87.410896, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 665.765319, 2557.101806, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 665.274291, 2557.136718, -89.534797, -4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 665.741577, 2557.105224, -89.697998, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.237548, 2557.068603, -89.602798, 4.000000, 0.000000, 87.410896, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19814, 665.853210, 2560.180419, -89.646003, 90.000000, 0.000000, 87.529426, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 665.362182, 2560.215332, -89.534797, -4.000000, 0.000000, 8187.025878, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(1902, 665.837524, 2560.182861, -89.690002, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 666.325439, 2560.147216, -89.602798, 4.000000, 0.000000, 87.410896, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "white32", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 665.579223, 2560.202880, -89.626403, 0.000000, 0.000000, 272.571655, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 665.502136, 2561.485839, -89.626403, 0.000000, 0.000000, 265.113525, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 665.492248, 2557.144042, -89.626403, 0.000000, 0.000000, 265.113525, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 665.496154, 2552.999755, -89.626403, 0.000000, 0.000000, 272.571655, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19808, 665.537353, 2551.120849, -89.626403, 0.000000, 0.000000, 272.571655, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "white32", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 664.439880, 2565.336669, -87.933547, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 659.103454, 2553.880615, -88.134498, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2612, 660.586669, 2546.681640, -88.018898, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 659.102294, 2549.625244, -88.435493, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2056, 670.576904, 2561.328125, -88.741203, 0.000000, 10.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_picture2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2611, 670.601928, 2554.885009, -87.933502, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14489, "carlspics", "AH_picture2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2616, 670.566650, 2550.396484, -87.936698, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 668.864074, 2565.359619, -87.855552, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19099, "policecaps", "policecap2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 12855, "cunte_cop", "sw_PD", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 660.327331, 2555.972656, -87.855552, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 5818, "billbrdlawn", "bobobillboard1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2260, 659.518432, 2551.532226, -87.842826, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2260, 662.207885, 2562.633789, -88.346839, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 666.028686, 2564.893798, -88.049636, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture3", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 670.135009, 2556.141357, -89.005287, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19174, 663.691589, 2546.640625, -87.892303, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_landscap1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2267, 654.393737, 2544.066406, -89.726898, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "mp_diner_wood", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19162, "newpolicehats", "policehatmap2", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 668.949218, 2533.531250, -94.816909, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 670.245849, 2545.397460, -88.497398, 0.000000, 0.000000, -89.999984, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4600, "theatrelan2", "sl_whitewash1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14569, "traidman", "darkgrey_carpet_256", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19482, 661.116027, 2533.551513, -88.915130, 0.000000, 0.000000, 89.900016, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} DETECTIVE", 130, "Ariel", 30, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(19482, 657.705505, 2533.555175, -88.915130, 0.000000, 0.000000, 89.900016, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} DETECTIVE", 130, "Ariel", 30, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(19376, 656.410705, 2551.562500, -90.531074, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2261, 654.571899, 2526.862304, -89.859008, 0.000000, -13.000000, 160.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 3262, "privatesign", "sw_hairpinL", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19087, 670.772949, 2543.121582, -85.488624, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2280, 666.517395, 2534.135742, -87.972694, 0.000000, 0.000000, 179.500000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 19162, "newpolicehats", "policehatmap2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18800, "mroadhelix1", "concretemanky1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19377, 689.578857, 2533.551513, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(2266, 670.280883, 2534.569335, -88.497398, 0.000000, 0.000000, -89.500022, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4600, "theatrelan2", "sl_whitewash1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14569, "traidman", "darkgrey_carpet_256", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19329, 670.755554, 2534.564453, -88.160644, 0.000000, 0.000000, -90.199951, 120.00, 120.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} DETENTION", 120, "Ariel", 22, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(19377, 651.541320, 2551.404296, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5040, "shopliquor_las", "lasjmliq1", 0x00000000);
	tmpobjid = CreateDynamicObjectEx(19329, 654.344238, 2526.434082, -88.195167, 0.000000, 0.000000, -20.200004, 120.00, 120.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} by  Rayzer", 120, "Ariel", 20, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObjectEx(19329, 653.273742, 2526.825195, -89.055145, 0.000000, 0.000000, -20.200004, 120.00, 120.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} 2019", 120, "Ariel", 20, 1, 0x00000000, 0x00000000, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObjectEx(19376, 656.363098, 2551.558349, -90.541076, 0.000000, 90.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11711, 651.272216, 2538.927001, -87.455146, 0.000000, 0.000000, -89.400054, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19377, 651.535888, 2551.366210, -90.456871, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18084, 655.144287, 2545.656250, -89.217903, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 675.938415, 2540.464355, -95.603599, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19377, 675.606994, 2536.792236, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19377, 675.768554, 2533.545654, -90.456901, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18075, 661.737854, 2540.131347, -85.500640, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 654.584106, 2537.164306, -84.995002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 668.404968, 2537.245849, -84.995002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 656.654846, 2550.905273, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 654.305664, 2548.555419, -92.198699, 0.000000, 0.000000, 45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 654.179138, 2550.825927, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 654.384948, 2551.032714, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 656.780578, 2548.636230, -92.196701, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19366, 656.575073, 2548.425781, -92.198699, 0.000000, 0.000000, -45.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2161, 652.150939, 2552.536376, -90.453887, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2009, 657.350524, 2552.020263, -90.455299, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 657.854003, 2551.335449, -90.455001, 0.000000, 0.000000, 70.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2161, 653.487060, 2552.534179, -90.453887, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2161, 652.550354, 2552.530029, -89.105499, -0.004000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2161, 654.823059, 2552.534912, -90.453887, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2164, 658.796020, 2547.962158, -90.455703, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2200, 651.708862, 2549.580322, -90.454803, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2199, 651.674987, 2548.177734, -90.454299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 657.245544, 2549.031250, -85.499900, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 653.706665, 2549.036132, -85.499900, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2002, 664.179687, 2545.891113, -90.453720, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2167, 658.839233, 2549.221923, -90.453697, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2173, 657.642333, 2528.139648, -90.455093, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 658.230773, 2526.741699, -90.454101, 0.000000, 0.000000, 193.530914, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 651.769531, 2531.980224, -90.453521, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2615, 662.936096, 2526.402343, -88.465560, 0.000000, 3.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2612, 658.157226, 2526.241210, -88.980941, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2606, 654.442016, 2552.427246, -88.880599, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18636, 657.585998, 2528.363281, -89.590202, 0.000000, 0.000000, 317.317108, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19834, 656.184509, 2526.186523, -89.423896, 0.000000, 1.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2816, 658.539245, 2528.217529, -89.655433, 0.000000, 0.000000, 10.470990, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19807, 657.558593, 2527.979003, -89.603401, 0.000000, 0.000000, 349.242462, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2311, 656.925720, 2530.899414, -90.454200, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1892, 652.385742, 2539.315429, -90.454299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1892, 652.384826, 2537.645996, -90.454299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2066, 655.674560, 2526.006835, -90.935600, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 651.779968, 2530.485595, -90.454597, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2066, 656.258483, 2526.010253, -90.935600, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2199, 651.396606, 2528.311767, -90.454002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2281, 658.715637, 2530.024414, -87.903709, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(16779, 654.855102, 2530.318359, -85.500076, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2686, 655.175842, 2526.204345, -88.822601, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2221, 656.940979, 2531.059082, -89.877502, 0.000000, 0.000000, 1.105669, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2059, 656.784912, 2531.985595, -89.925697, 0.000000, 0.000000, 83.055343, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2197, 652.064941, 2529.625488, -90.656196, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 652.634704, 2532.703369, -90.454101, 0.000000, 0.000000, 193.530914, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19172, 651.305114, 2530.594726, -87.563903, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2671, 657.621948, 2526.592041, -90.441596, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2261, 654.565063, 2526.844238, -87.849029, 0.000000, 0.000000, 160.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2173, 659.866210, 2528.156982, -90.455093, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 659.904846, 2526.652343, -90.454101, 0.000000, 0.000000, 164.053390, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19807, 659.734191, 2528.075195, -89.603401, 0.000000, 0.000000, 349.242462, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18636, 659.576171, 2528.495605, -89.590202, 0.000000, 0.000000, 312317.312500, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2311, 665.017700, 2528.420654, -90.454406, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2222, 666.337768, 2528.424316, -89.883300, 0.000000, 0.000000, 81.609687, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2828, 660.996154, 2528.169189, -89.654502, 0.000000, 0.000000, 135.786422, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2616, 656.102844, 2526.240234, -88.598808, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2615, 656.369018, 2526.248779, -88.465560, 0.000000, 3.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2612, 659.406555, 2527.653808, -88.880912, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2261, 659.894714, 2529.004638, -88.374588, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2066, 661.497314, 2526.238281, -90.481498, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19623, 661.704711, 2526.536132, -89.002899, 0.008000, 0.000000, 111.524803, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19918, 662.081970, 2526.589355, -90.454277, 0.000000, 0.000000, 352.367279, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2199, 668.390808, 2532.857910, -90.454002, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1742, 668.577636, 2531.473632, -90.454200, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1742, 668.580200, 2530.031982, -90.454200, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(16779, 663.643615, 2529.474121, -85.500076, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 660.880676, 2529.027587, -85.094299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 666.399108, 2528.757324, -85.094299, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2609, 668.293090, 2528.756835, -90.047157, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2608, 668.368225, 2530.050292, -87.833503, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2737, 666.234436, 2533.393798, -88.538307, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1744, 659.216064, 2531.730468, -88.770500, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2345, 659.832580, 2532.205322, -88.648399, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2345, 659.671508, 2532.381347, -88.648399, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2083, 669.468750, 2533.568603, -90.453872, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2252, 669.917724, 2534.058349, -89.685203, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2249, 669.845214, 2534.041992, -89.513481, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 654.644226, 2541.721923, -84.995002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 668.467712, 2541.353759, -84.995002, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19834, 662.925415, 2526.320556, -89.423896, 0.000000, 1.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2308, 676.920349, 2537.537353, -95.604598, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2165, 679.317687, 2538.541992, -95.603500, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 678.170166, 2537.477050, -95.602699, 0.000000, 0.000000, 104.003852, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1738, 685.693298, 2550.301757, -95.060897, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2816, 676.455261, 2537.424072, -94.813842, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2067, 675.768188, 2539.666503, -95.605003, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 678.111755, 2539.545654, -91.049102, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 682.143371, 2553.060058, -91.049102, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 681.926757, 2545.452148, -91.049102, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 681.900756, 2540.101806, -91.049102, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1893, 681.687255, 2534.711669, -91.049102, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2528, 685.384277, 2545.700439, -95.603500, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2524, 687.234375, 2545.081054, -95.602600, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2205, 689.159973, 2546.453369, -95.603302, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2846, 687.483154, 2549.382324, -95.602378, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1744, 689.850036, 2546.240478, -94.491600, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1811, 687.666992, 2545.652587, -94.884597, 0.000000, 0.000000, 199.086654, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2059, 689.007446, 2545.806884, -94.648498, 0.000000, 0.000000, 80.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2268, 689.219909, 2545.930664, -94.042427, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1529, 689.716430, 2548.801269, -94.424400, 3.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18661, 687.214172, 2550.449462, -94.602470, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1800, 688.900939, 2546.880859, -94.648300, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1800, 688.901000, 2546.880859, -95.603538, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2843, 688.426696, 2548.652587, -94.824096, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2056, 689.339843, 2545.230712, -94.365600, 0.000000, -7.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1738, 685.699340, 2539.441406, -95.060897, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18661, 687.220214, 2539.589111, -94.602470, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2846, 687.489196, 2538.521972, -95.602378, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1800, 688.907043, 2536.020507, -95.603538, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1800, 688.906982, 2536.020507, -94.648300, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2843, 688.432739, 2537.792236, -93.882057, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1744, 689.856079, 2535.380126, -94.491600, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2205, 689.166015, 2535.593017, -95.603302, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2059, 689.013488, 2534.946533, -94.648498, 0.000000, 0.000000, 80.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2056, 689.345886, 2534.370361, -94.365600, 0.000000, -7.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2273, 688.738098, 2534.121093, -94.038917, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1811, 687.673034, 2534.792236, -94.884597, 0.000000, 0.000000, 199.086654, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2524, 687.240051, 2534.137695, -95.602600, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2528, 685.390319, 2534.840087, -95.603500, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1529, 689.722473, 2537.940917, -94.424400, 3.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2671, 686.915161, 2549.070556, -95.590797, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2671, 689.114013, 2545.602050, -95.590797, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2610, 689.629943, 2547.207519, -95.113296, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 678.966369, 2543.215087, -94.034301, 0.000000, 0.000000, -100.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 676.873596, 2543.186523, -94.034301, 0.000000, 0.000000, 100.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2654, 678.537719, 2537.173095, -90.232101, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2145, 672.772155, 2537.040771, -90.450897, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1566, 680.725891, 2546.349121, -89.132942, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18094, 679.687500, 2537.170654, -89.032470, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 672.175842, 2537.070800, -90.449302, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11738, 684.221740, 2537.583251, -90.403602, 0.000000, 0.000000, 89.300003, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 682.221801, 2537.063476, -90.075103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 682.221496, 2537.057373, -89.631103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 682.221496, 2537.057373, -89.145103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 680.222839, 2537.057128, -89.631103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 680.221496, 2537.057373, -89.145103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 680.221801, 2537.063476, -90.075103, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 676.579895, 2537.144042, -89.597099, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 674.583435, 2537.144287, -89.597099, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2654, 683.654296, 2537.073242, -90.232101, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(14401, 677.873229, 2540.885742, -90.134597, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2371, 673.149291, 2539.875488, -90.454689, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2392, 673.524841, 2540.020507, -89.751403, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2394, 672.857116, 2540.446533, -89.743186, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.226379, 2539.677001, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.225891, 2538.994384, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.226989, 2538.315673, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.225402, 2541.029541, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.225891, 2541.712158, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11729, 671.226501, 2540.350830, -90.449302, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2387, 676.112854, 2538.759521, -90.449478, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2387, 680.615478, 2538.714111, -90.449478, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2694, 681.260986, 2537.076660, -89.509803, 0.000000, 0.000000, 96.269203, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2694, 681.260986, 2537.076660, -89.021797, 0.000000, 0.000000, 96.269172, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(14793, 680.244079, 2541.793212, -86.519798, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11738, 683.931518, 2537.588623, -90.403602, 0.000000, 0.000000, 89.300003, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18105, 690.287963, 2537.336425, -88.484001, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19940, 684.142272, 2536.928955, -89.290100, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 674.114624, 2546.037841, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 675.150085, 2546.026611, -90.043800, 0.000000, 0.000000, 10.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 672.765808, 2545.957275, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 676.658325, 2546.104492, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.127807, 2545.507568, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.129089, 2545.676757, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.128662, 2545.620361, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.128234, 2545.563964, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.685974, 2545.507568, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.686828, 2545.620361, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.687255, 2545.676757, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18637, 678.686401, 2545.563964, -89.890800, 80.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 675.917846, 2546.039794, -89.615699, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 674.585998, 2546.033935, -90.288696, 0.000000, 0.000000, 20.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 673.882934, 2546.023925, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 673.662536, 2546.035888, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 673.380859, 2546.009521, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 673.120239, 2546.002197, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 672.900512, 2546.012939, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 672.659851, 2546.004638, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 675.970153, 2546.086914, -90.288803, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 676.279418, 2545.990966, -90.055801, 0.000000, 0.000000, 357.435577, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 677.510314, 2545.967285, -90.288803, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 675.150085, 2546.026611, -90.288803, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2358, 676.770202, 2546.047119, -90.288803, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 673.226379, 2546.053955, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 673.705688, 2545.988037, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 674.207153, 2546.101806, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 674.645080, 2545.956054, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 675.119628, 2546.094970, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19142, 675.583312, 2545.904296, -89.500396, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 674.340820, 2546.046142, -90.288696, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 676.137817, 2546.040039, -89.615699, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2040, 676.357910, 2546.020263, -89.615699, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 676.752685, 2545.828369, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 676.980773, 2546.060302, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 677.094055, 2545.805175, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 677.238159, 2546.113281, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19141, 677.392456, 2545.840332, -89.638298, 0.000000, 270.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2654, 678.355712, 2546.135009, -89.497100, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2694, 675.385925, 2546.056640, -89.021797, 0.000000, 0.000000, 277.114135, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2694, 674.740173, 2545.928710, -89.021797, 0.000000, 0.000000, 272.948089, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2390, 672.844970, 2545.416015, -88.242202, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2399, 673.507995, 2545.418457, -88.233222, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2399, 674.088012, 2545.404785, -88.233222, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2389, 675.789611, 2545.446533, -88.183502, 0.000000, 0.000000, 0.808000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2383, 676.321533, 2545.467041, -88.190986, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2694, 677.352478, 2545.979003, -89.021797, 0.000000, 0.000000, 277.114135, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2390, 678.689453, 2545.412841, -88.242202, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2390, 678.169250, 2545.411132, -88.242202, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18075, 666.254333, 2558.172363, -85.500640, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(18075, 666.248840, 2553.860351, -85.496597, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 662.231140, 2562.114013, -90.458099, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2172, 665.598205, 2564.940429, -90.458831, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 662.244323, 2563.841064, -90.456619, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2199, 667.657775, 2565.316162, -90.455909, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2002, 670.119567, 2552.507812, -90.456199, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2067, 659.324035, 2553.567138, -90.456298, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2197, 664.118530, 2564.339111, -90.455711, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2161, 659.050537, 2549.771484, -90.455703, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 659.566833, 2554.487304, -90.456619, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 669.195739, 2564.895263, -90.456596, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 670.136108, 2548.101074, -90.456596, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2193, 660.523803, 2547.093994, -90.456596, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 659.482055, 2552.132324, -90.458099, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 670.134704, 2551.147460, -90.458099, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2191, 670.138427, 2560.382568, -90.458099, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2197, 660.078247, 2551.284179, -90.455703, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2067, 661.271301, 2546.692871, -90.456298, 0.000000, 0.000000, 0.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2610, 670.531860, 2563.156738, -90.422698, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2183, 666.902099, 2559.285400, -90.454696, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2183, 666.884216, 2554.978271, -90.454696, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2183, 666.901062, 2550.613525, -90.454696, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 669.429138, 2547.798339, -90.452972, 0.000000, 0.000000, 350.131011, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 660.135986, 2547.685058, -90.452972, 0.000000, 0.000000, 238.606231, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 660.288330, 2554.704345, -90.452972, 0.000000, 0.000000, 238.606231, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 662.816040, 2564.247070, -90.452972, 0.000000, 0.000000, 164.510467, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1714, 669.515930, 2564.174072, -90.452972, 0.000000, 0.000000, 164.510467, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 664.893859, 2559.697021, -90.453193, 0.000000, 0.000000, 305.074066, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 665.011596, 2557.347412, -90.453193, 0.000000, 0.000000, 250.148147, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 665.085754, 2555.801025, -90.453193, 0.000000, 0.000000, 282.054351, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 664.974548, 2561.679443, -90.453193, 0.000000, 0.000000, 250.148147, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 664.863464, 2553.088867, -90.453193, 0.000000, 0.000000, 261.271026, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 664.825805, 2551.046142, -90.453193, 0.000000, 0.000000, 269.988525, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.525390, 2551.072509, -90.453201, 0.000000, 0.000000, 76.233810, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.632141, 2559.895996, -90.453201, 0.000000, 0.000000, 76.233810, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.349426, 2557.335449, -90.453201, 0.000000, 0.000000, 130.516937, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.197387, 2552.825927, -90.453201, 0.000000, 0.000000, 120.844673, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.378601, 2555.604736, -90.453201, 0.000000, 0.000000, 76.233810, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(1806, 667.445007, 2561.788574, -90.453201, 0.000000, 0.000000, 104.170928, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2612, 670.574645, 2562.116699, -88.018898, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2612, 670.552795, 2559.153808, -87.715888, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2611, 661.786376, 2563.991210, -88.134498, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2855, 665.783447, 2557.747314, -89.646400, 0.000000, 0.000000, 324.621582, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2855, 666.763854, 2562.311523, -89.646400, 0.000000, 0.000000, 3324.621582, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2056, 670.609741, 2551.932617, -88.741203, 0.000000, 10.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2615, 669.390075, 2546.671142, -88.105697, 0.000000, 0.000000, 180.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2615, 670.555114, 2550.811279, -87.605712, 0.000000, 0.000000, 270.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19174, 661.728332, 2559.649169, -87.892303, 0.000000, 0.000000, 90.000000, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2221, 665.957885, 2553.653076, -89.568298, 0.000000, 0.000000, 12.388819, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2768, 666.657714, 2557.860595, -89.569503, 0.000000, 0.000000, 30.673700, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(2768, 666.866943, 2557.963867, -89.569503, 0.000000, 0.000000, 3320.673583, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(11738, 683.951538, 2537.588378, -90.403602, 0.000000, 0.000000, 75.200019, 120.00, 120.00);
	tmpobjid = CreateDynamicObjectEx(19087, 670.792968, 2543.121582, -85.488624, 0.000000, 0.000000, 0.000000, 120.00, 120.00);

    //================= Favela NataaNRP ======================///
    new FavelaNataaNRP;
	FavelaNataaNRP = CreateDynamicObject(3649, 2432.900390, -960.099609, 81.400001, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 13361, "ce_pizza", "comptwall36", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 11, 10355, "haight1_sfs", "ws_apartmentmankyb2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2511.400390, -989.599609, 74.099998, 0.000000, 0.000000, 267.994995, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3648, 2473.000000, -943.099609, 81.900001, 0.000000, 0.000000, 87.989997, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3820, "boxhses_sfsx", "LAbluewall", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 3820, "boxhses_sfsx", "LAbluewall", 0xFFFFFFFF);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3634, 2542.000000, -946.700195, 84.099998, 0.000000, 0.000000, 187.992996, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3241, 2511.530517, -985.987548, 78.099998, 0.000007, 0.000000, 87.894981, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 5, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2605.154052, -968.663269, 82.680099, 0.000000, 0.000000, 99.694984, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2536.205810, -993.674438, 76.987571, -0.099999, 0.000000, 170.100036, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11457, 2495.199951, -922.799987, 81.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2494.200195, -979.700195, 77.900001, 0.000000, 0.000000, 257.992004, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3887, 2525.770996, -891.794677, 91.209320, 0.000000, 0.000000, 95.899940, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10891, "bakery_sfse", "ws_altz_wall4", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 10891, "bakery_sfse", "ws_altz_wall4", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 10891, "bakery_sfse", "ws_altz_wall4", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1369, 2511.399902, -965.700012, 81.900001, 0.000000, 0.000000, 35.997001, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 18901, "matclothes", "metalalumox1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 18901, "matclothes", "metalalumox1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 18901, "matclothes", "beretblk", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 18901, "matclothes", "metalalumox1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 4, 19801, "balaclava1", "balaclava1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2445.253417, -942.949157, 81.840026, 0.000000, 0.000000, 274.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2550.149658, -885.389892, 84.710861, 2.645345, -1.258672, 6.813656, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3828, 2521.987304, -993.851074, 75.810188, 0.000000, 0.000000, 82.900009, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(12937, 2553.103271, -942.913146, 84.849609, -3.299998, 0.000000, 189.998001, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11433, 2450.600585, -976.700195, 80.199996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3418, 2543.226562, -929.785156, 85.623847, -9.500000, -1.299999, 195.990997, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 6404, "beafron1_law2", "comptwall31", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2397.563964, -985.731689, 72.107582, 0.000000, 0.000000, 188.500030, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2559.500000, -983.200195, 80.300003, 0.000000, 0.000000, 55.992000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2550.365234, -887.183593, 84.597320, 2.645345, -1.258672, 6.813656, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3285, 2571.799804, -937.799804, 82.300003, 0.000000, 0.000000, 99.998001, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2550.629150, -889.381896, 84.384948, 2.092877, -0.793659, 2.656908, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2458.665771, -911.151428, 94.478134, 0.000000, 0.399998, -84.299987, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3285, 2588.199951, -934.599975, 81.800003, 0.000000, 0.000000, 99.998001, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2523.100097, -982.099975, 77.400001, 0.000000, 0.000000, 85.995002, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2466.899902, -980.599975, 75.099998, 0.000000, 0.000000, 95.989997, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2399.221679, -999.114135, 66.667602, 0.000000, 0.000000, 998.500000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3828, 2619.533203, -1030.069213, 74.740150, 0.000014, 0.000000, 88.199958, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 17566, "contachou1_lae2", "gangwin1_LAe", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2550.716308, -891.268127, 84.296035, 2.092877, -0.793659, 2.656908, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11433, 2468.543457, -985.765869, 72.300003, 0.000000, 0.000000, 2.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3626, 2538.000000, -984.200195, 80.800003, 0.000000, 0.000000, 333.989990, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3362, 2464.899902, -976.599975, 78.599998, 0.000000, 0.000000, 89.995002, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2565.037109, -904.223449, 85.949996, 0.000000, 0.000000, 12.399987, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 16640, "a51", "redmetal", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2541.752441, -894.196838, 84.999908, -4.000000, -8.599999, -177.599975, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2541.671875, -892.391113, 85.096557, -4.000000, -8.599999, -177.599975, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2608.818603, -916.919799, 81.240043, 0.000000, -2.299998, -87.099998, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2562.103759, -892.264465, 87.497573, 0.000000, 0.000000, -77.899971, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 14668, "711c", "cj_white_wall2", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3602, 2424.536621, -932.619689, 85.142501, 0.000000, 0.000000, 15.100005, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2541.563476, -890.169921, 85.142913, -4.000000, -8.599999, 178.200027, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3602, 2607.373535, -899.139404, 79.654464, 2.299998, 0.000000, 102.999977, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2534.508544, -1007.198608, 74.099998, 0.000000, 0.000000, 267.994995, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2541.620361, -888.283874, 85.255035, -4.000000, -8.599999, 178.200027, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2531.597412, -917.111755, 85.533416, 180.000000, 90.000000, -3.900000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2535.850341, -917.477539, 85.533416, 180.000000, 90.000000, -4.599997, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2590.814941, -1031.150146, 71.100082, 0.000000, 0.000000, 88.895004, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2533.498046, -917.288330, 85.531417, 180.000000, 90.000000, -4.599997, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2532.107910, -910.950012, 85.535415, 0.000000, 270.000000, 175.900054, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2536.308593, -911.322937, 85.531417, 0.000000, 270.000000, 175.399993, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2533.498046, -911.096984, 85.529418, 0.000000, 270.000000, 175.399993, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19454, 2537.929687, -911.975280, 83.891418, 0.000000, 360.000000, 175.400024, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2578.829589, -1030.938964, 71.100082, 0.000000, 0.000000, 88.994987, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2476.263671, -912.622314, 93.220001, 0.000000, 0.000000, 274.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2628.164794, -986.131896, 83.329627, -0.099999, 0.000000, 15.699995, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2541.699218, -886.521057, 85.536987, -4.000000, -8.599999, 178.200027, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1811, 2550.797363, -893.050598, 84.390838, 2.092877, -0.793659, 2.656908, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2601.248291, -992.179809, 82.740097, 0.000007, -0.000000, 103.894958, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2601.257568, -992.169067, 75.700119, 0.000007, -0.000000, 103.894958, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 4, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 5, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 8, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 10, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3828, 2619.524169, -1030.300292, 77.740135, 0.000014, 0.000000, 88.199958, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 17566, "contachou1_lae2", "gangwin1_LAe", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2629.862304, -1030.938964, 71.100082, 0.000007, 0.000000, 88.994964, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2624.285644, -937.394592, 77.688774, 0.000000, -5.199997, -78.010993, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(5422, 2545.964599, -890.241821, 84.272506, 4.299999, 86.800018, 100.100006, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19058, "xmasboxes", "silk6-128x128", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3655, 2628.458251, -985.325134, 82.369163, 0.000000, -0.100000, 465.695007, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3783, 2646.418945, -956.071655, 80.003189, 0.000000, 2.000000, 28.000003, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2608.533203, -1014.037902, 76.300086, 0.000000, 0.000000, 12.095001, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 8, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2586.618408, -1015.291198, 75.920089, 0.000000, 0.000000, -175.904983, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2586.628417, -1015.281188, 67.430099, 0.000000, 0.000000, -175.904983, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 8, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2604.954833, -1004.566711, 77.477539, 0.000000, 0.000000, -79.999969, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2578.542968, -1000.134033, 80.800102, 0.000000, 0.000000, -119.904991, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2578.552978, -1000.124023, 72.480094, 0.000000, 0.000000, -119.904991, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 4, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 5, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 8, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 10, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2555.550537, -1004.027282, 79.275688, -0.099999, 0.000000, 170.000030, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1251, 2588.396240, -906.846679, 82.150138, 90.000000, 0.000000, 102.799987, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1251, 2583.639404, -907.927734, 82.150138, 90.000000, 0.000000, 102.799987, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1251, 2582.083740, -878.795837, 82.150138, 89.999992, -167.507980, -89.692024, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1319, 2586.944335, -907.185791, 85.550132, 90.000000, 0.000000, 102.899978, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1251, 2577.326904, -879.876892, 82.150138, 89.999992, -167.507980, -89.692024, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1319, 2580.631835, -879.134948, 85.550132, 89.999992, -167.415100, -89.684928, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(2938, 2569.476318, -890.810546, 85.680145, 0.000000, 0.000000, -167.900054, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17700, "gangblok1_lae2", "mural01_LA", 0xFFC8C8C8);
	FavelaNataaNRP = CreateDynamicObject(19482, 2594.596435, -872.424011, 85.270103, 0.000000, 0.000000, -167.099960, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 5390, "glenpark7_lae", "ganggraf01_LA", 0xBEFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(19482, 2602.083740, -879.629577, 84.980102, 0.000000, 0.000000, -77.599960, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 14801, "lee_bdupsmain", "Bdup_graf2", 0x8CFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(19482, 2569.524414, -890.877197, 89.840118, 0.000000, 0.000000, 12.200042, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 14801, "lee_bdupsmain", "Bdup_graf4", 0x8CFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(19482, 2595.877441, -878.019287, 85.140098, 0.000000, 0.000000, -167.099960, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 5998, "sunstr_lawn", "ganggraf02_LA", 0xBEFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1319, 2587.969482, -906.951416, 85.550132, 90.000000, 0.000000, 102.899978, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(2743, 2546.806884, -894.577941, 85.435821, -2.564997, -3.757101, -171.714523, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 14808, "lee_strip2", "Strip_curtain", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(2809, 2546.806884, -894.577941, 85.435821, -2.564997, -3.757101, -171.714523, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 18901, "matclothes", "elvishair", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 3439, "xrefairtree", "rustadark128", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2487.000000, -933.700195, 82.099998, 0.000000, 0.000000, 269.989013, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(16001, 2498.200195, -988.799804, 69.599998, 0.000000, 0.000000, 345.997985, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11457, 2461.380371, -916.519653, 84.439956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2454.547851, -927.827880, 85.169006, 0.000000, 0.200001, 269.989013, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19483, 2547.511230, -889.320556, 84.276397, 363.100006, 94.400093, 8.800000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 825, "gta_proc_bigbush", "veg_bush1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19483, 2544.282714, -890.446166, 84.502593, -2.900006, 85.400093, -173.900009, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 825, "gta_proc_bigbush", "veg_bush4", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19483, 2545.541503, -888.893859, 84.451324, 4.399992, 86.800086, 99.600013, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 726, "gtatreesh", "oakleaf1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19483, 2546.333984, -891.625061, 84.257751, 4.399992, 86.800086, 99.600013, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 728, "gtatreeshi", "berrybush1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(2801, 2545.718994, -889.833496, 84.025344, 2.400000, 4.899999, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, -1, "none", "none", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3601, 2491.350097, -901.750061, 92.262626, -0.399998, -0.000014, -175.799942, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3632, 2549.352783, -895.166931, 84.320480, 4.199998, -2.499999, 100.000022, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 2212, "burger_tray", "pplate", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 14392, "dr_gsstudio", "drumsideblue128", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2454.547851, -927.676513, 88.368476, 0.000000, 0.200001, 449.989013, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2629.958740, -1029.939208, 71.147529, 0.000000, 0.000000, 179.500030, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3632, 2544.691650, -895.692321, 84.716171, 4.199998, -2.299998, 100.000022, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 2212, "burger_tray", "pplate", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 14392, "dr_gsstudio", "drumsideblue128", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11457, 2431.600585, -919.400390, 83.300003, 0.000000, 0.000000, 15.996000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3640, 2594.831298, -918.652221, 83.616897, 0.000000, 0.000000, 2.200001, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 11092, "burgalrystore_sfse", "ws_peeling_ceiling2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3828, 2425.100097, -977.400024, 73.500000, 0.000000, 0.000000, 86.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 3355, "cxref_savhus", "des_brick1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3626, 2443.000000, -979.599609, 76.300003, 0.000000, 0.000000, 83.996002, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3285, 2612.500000, -938.700012, 80.400001, 0.000000, 0.000000, 262.000000, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2559.839843, -880.578002, 85.949996, 0.000000, 0.000000, 12.399987, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 6404, "beafron1_law2", "comptwall31", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2503.437255, -936.479003, 83.390068, 0.000000, 0.000000, -122.799972, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2604.699218, -885.500366, 79.349967, 0.000000, 0.000000, 14.100002, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2585.912109, -907.422241, 85.550132, 90.000000, 0.000000, 102.899978, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3642, 2570.254882, -918.836303, 84.238937, 0.000000, 2.899998, 13.500003, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 11092, "burgalrystore_sfse", "ws_altz_wall2bluetop", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3646, 2511.500000, -933.299804, 84.800003, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 8, 13361, "ce_pizza", "comptwall36", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 13361, "ce_pizza", "comptwall36", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(11426, 2615.100097, -968.200012, 79.599998, 0.000000, 0.000000, 11.991998, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3655, 2491.970947, -912.900024, 91.060043, -0.000014, 0.000000, -85.999954, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 2, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 9, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3698, 2415.847900, -966.525329, 79.175186, 0.000000, -6.099997, 6.599998, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2584.996337, -907.631896, 85.550132, 90.000000, 0.000000, 102.899978, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3601, 2572.508544, -865.375976, 83.657569, 0.000000, 0.000000, 192.100036, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2410.612060, -982.664306, 76.987571, 0.000000, 0.000000, -173.599960, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2608.990234, -1029.262817, 75.567550, 0.000000, 0.000000, 179.900039, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2584.098632, -907.837646, 85.550132, 90.000000, 0.000000, 282.899963, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3828, 2619.473876, -1032.009399, 71.990173, 0.000014, 0.000000, 88.199958, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 17566, "contachou1_lae2", "gangwin1_LAe", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 7, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2581.656982, -878.900573, 85.550132, 89.999992, -167.415100, -89.684928, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3698, 2613.169677, -985.644531, 82.448089, -1.199998, 0.500000, 11.399995, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 6, 4004, "civic07_lan", "sl_rotnbrik", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2584.489501, -862.815490, 83.647567, 0.000000, 0.000000, 192.100036, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 10891, "bakery_sfse", "ws_altz_wall4", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2458.697998, -910.449340, 98.047538, -0.399998, 0.000000, -174.299972, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3601, 2602.560058, -873.366638, 83.417572, 0.000000, 0.000000, 103.000076, -1, -1, -1, 450.00, 450.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 3, 9507, "boxybld2_sfw", "compcouwall1", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2579.599609, -879.371398, 85.550132, 89.999992, -167.415100, -89.684928, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(3283, 2466.290039, -959.195007, 79.664100, 0.000000, 0.000000, 88.716400, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 4, 13059, "ce_fact03", "sw_corrugtile", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3241, 2458.709960, -944.492004, 79.539100, 0.000000, 0.000000, 88.915580, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 5, 11092, "burgalrystore_sfse", "ws_peeling_ceiling2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(3283, 2493.389892, -944.148010, 81.609397, 0.000000, 0.000000, 88.716316, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 7426, "vgncorp1", "brick2", 0x00000000);
	SetDynamicObjectMaterial(FavelaNataaNRP, 1, 7426, "vgncorp1", "brick2", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(1319, 2578.683837, -879.581054, 85.550132, 89.999992, -167.415100, -89.684928, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(1319, 2577.786132, -879.786804, 85.550132, 89.999992, 12.584880, -89.684898, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	FavelaNataaNRP = CreateDynamicObject(19482, 2468.113525, -917.038513, 94.920074, 0.000000, 0.000000, -87.099945, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2410.095947, -973.919921, 79.160896, 2.899997, 0.000000, 14.100053, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2521.645751, -961.040649, 82.776718, 3.699999, 0.000000, -121.099952, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2599.690185, -1029.916015, 73.720100, 0.000000, 0.000000, -87.099945, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2462.783447, -916.025268, 103.550071, -0.000007, -0.000000, -117.399948, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2402.113769, -991.025878, 77.630065, 0.000000, 0.000000, -119.299980, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	FavelaNataaNRP = CreateDynamicObject(19482, 2455.420166, -948.379699, 80.350128, 0.000000, 0.000000, 108.500129, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(FavelaNataaNRP, 0, 17518, "hub_alpha", "clothline1_LAe", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	FavelaNataaNRP = CreateDynamicObject(3646, 2627.500000, -961.200012, 81.360031, 0.000000, 0.000000, 112.000000, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(3589, 2561.100585, -954.900390, 83.800003, 0.000000, 0.000000, 189.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3285, 2482.400390, -959.599609, 81.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3253, 2458.300048, -961.900024, 78.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3250, 2529.700195, -948.900390, 81.300003, 0.000000, 0.000000, 187.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3246, 2522.400390, -934.900390, 82.099998, 0.000000, 0.000000, 5.993000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2499.000000, -994.299804, 69.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2493.200195, -993.200195, 69.400001, 0.000000, 0.000000, 341.998992, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3363, 2548.299804, -979.700195, 80.599998, 0.000000, 0.000000, 77.997001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3594, 2521.500000, -964.900024, 82.000000, 0.000000, 0.000000, 22.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3593, 2514.920166, -956.012207, 82.023712, 0.000000, 0.000000, 63.994998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2672, 2543.401611, -931.967651, 83.210250, 11.499996, 2.899998, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2670, 2439.600097, -967.299987, 78.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2453.600097, -967.000000, 79.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(12957, 2533.800048, -934.299987, 83.699996, 5.905000, 10.052000, 306.953002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1327, 2521.399902, -953.000000, 81.800003, 16.125999, 27.149999, 39.894001, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1370, 2518.000000, -940.000000, 82.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1442, 2520.899902, -948.099975, 82.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(849, 2571.300048, -988.900024, 79.500000, 8.000000, 0.000000, 6.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(850, 2561.199951, -937.200012, 82.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(851, 2467.500000, -950.000000, 79.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(852, 2469.000000, -973.500000, 79.099998, 0.000000, 0.000000, 338.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(853, 2424.600097, -969.000000, 77.599998, 0.000000, 353.996002, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2471.800048, -973.500000, 81.199996, 358.010986, 6.004000, 266.205993, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3447, 2514.800048, -916.700012, 92.300003, 0.000000, 0.000000, 342.000000, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(1571, 2571.300048, -973.599975, 82.099998, 0.000000, 4.000000, 330.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2512.100585, -993.289733, 78.400001, 0.000000, 0.000007, -2.005003, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2449.000000, -980.099975, 78.699996, 0.000000, 0.000000, 353.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3417, 2525.200195, -976.700195, 80.800003, 0.000000, 0.000000, 183.998992, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16406, 2601.199951, -948.700012, 75.699996, 0.000000, 0.000000, 284.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16405, 2540.700195, -977.400390, 82.599998, 0.000000, 0.000000, 347.992004, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1483, 2511.000000, -976.299804, 82.599998, 0.000000, 0.000000, 73.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1458, 2505.900390, -942.700195, 81.630043, 0.000000, 0.000000, 77.997001, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1457, 2507.600585, -956.500000, 83.000000, 0.000000, 0.000000, 272.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1457, 2507.600097, -953.299987, 83.000000, 0.000000, 0.000000, 272.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1451, 2545.000000, -960.200012, 82.099998, 0.000000, 0.000000, 8.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1370, 2497.600585, -966.500000, 81.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1370, 2587.400390, -953.400390, 80.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1370, 2454.199951, -948.700012, 79.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2510.600097, -953.900024, 81.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2501.199951, -976.099975, 81.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2550.300048, -932.000000, 82.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2507.100097, -978.000000, 83.500000, 0.000000, 354.000000, 31.999000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2509.000000, -938.099609, 85.599998, 0.000000, 6.000000, 331.997985, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2569.200195, -994.099609, 83.400001, 0.000000, 4.000000, 85.995002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1497, 2534.549804, -984.231506, 79.399940, 0.000000, 0.000000, -26.199998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3362, 2566.399902, -988.099975, 79.400001, 0.000000, 0.000000, 57.997001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2442.899902, -952.000000, 79.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2475.000000, -975.200195, 79.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1450, 2571.100097, -944.299987, 81.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1462, 2497.300048, -964.400024, 80.400001, 0.000000, 0.000000, 40.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1483, 2511.000000, -976.299804, 82.599998, 0.000000, 0.000000, 255.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1773, 2508.300048, -949.799987, 82.199996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3097, 2507.100585, -973.400390, 83.300003, 0.000000, 0.000000, 75.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3302, 2479.699951, -951.900024, 79.599998, 358.058990, 345.992004, 5.515998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(924, 2466.300048, -948.799987, 79.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(933, 2479.600097, -959.200012, 79.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2483.909912, -975.900024, 81.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2484.299804, -976.299804, 80.800003, 0.000000, 0.000000, 182.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2487.100097, -975.799987, 80.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2487.100585, -976.200195, 80.900001, 0.000000, 0.000000, 182.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2499.100585, -975.200195, 81.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2499.000000, -975.900024, 81.900001, 0.000000, 0.000000, 178.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2498.800048, -975.700012, 81.900001, 0.000000, 0.000000, 86.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2499.199951, -975.700012, 81.900001, 0.000000, 0.000000, 266.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2484.100585, -976.000000, 81.000000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2487.100585, -976.000000, 80.900001, 0.000000, 0.000000, 272.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3860, 2439.400390, -975.400390, 79.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3860, 2439.199951, -975.599975, 79.300003, 0.000000, 0.000000, 87.995002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3860, 2439.399902, -975.900024, 79.099998, 0.000000, 0.000000, 175.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3860, 2439.600097, -975.900024, 79.300003, 0.000000, 0.000000, 265.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2572.399902, -978.599975, 81.099998, 0.000000, 0.000000, 357.989990, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2487.100097, -978.200012, 79.699996, 1.993999, 355.994995, 358.131988, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2497.699951, -952.500000, 81.699996, 0.000000, 0.000000, 267.989990, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(14409, 2528.600097, -987.900024, 75.300003, 3.999000, 0.000000, 171.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(14409, 2529.301025, -981.898437, 78.333595, 3.993999, 0.000000, 173.990997, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1372, 2553.600585, -906.200195, 83.400001, 358.007995, 6.001998, 318.204986, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(14880, 2546.600585, -978.799804, 81.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1509, 2512.699951, -966.900024, 81.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2959, 2474.299804, -932.200195, 83.500000, 2.000000, 0.000000, 89.995002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2522.899902, -986.400024, 77.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2988, 2499.500000, -982.299804, 78.599998, 0.000000, 0.000000, 83.996002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2988, 2499.500000, -982.500000, 78.599998, 0.000000, 0.000000, 175.996002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2988, 2499.699951, -978.500000, 79.099998, 0.000000, 0.000000, 87.995002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2988, 2503.699951, -982.799987, 78.599998, 0.000000, 0.000000, 177.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2988, 2499.500000, -982.099975, 82.099998, 0.000000, 88.000000, 83.996002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2493.500000, -983.400024, 77.699996, 0.000000, 0.000000, 347.997009, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3062, 2501.100585, -982.599609, 79.900001, 0.000000, 0.000000, 353.996002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(11503, 2597.100097, -972.200012, 80.199996, 0.000000, 0.000000, 10.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1457, 2555.000000, -988.200012, 81.699996, 0.000000, 0.000000, 65.989997, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(12943, 2534.040527, -914.209594, 85.129989, 0.000000, 0.000000, 265.989990, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(12942, 2534.000000, -914.200012, 85.099998, 0.000000, 0.000000, 266.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1413, 2490.500000, -952.099975, 82.500000, 0.000000, 0.000000, 89.995002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1410, 2464.699951, -984.700012, 75.300003, 0.000000, 0.000000, 4.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1410, 2421.899902, -986.200012, 72.599998, 0.000000, 0.000000, 355.993988, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(17513, 2585.033203, -895.418212, 75.063568, 0.000000, 0.000000, -167.200012, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2555.000000, -959.599975, 82.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1265, 2459.900390, -974.000000, 79.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2695, 2530.000000, -963.099975, 82.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2692, 2458.100097, -947.500000, 80.900001, 9.265000, 22.305999, 356.221008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1245, 2574.899902, -972.299987, 81.900001, 0.000000, 0.000000, 134.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3865, 2601.699951, -937.299987, 76.400001, 272.000000, 179.994995, 141.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1353, 2464.600097, -964.799987, 79.800003, 0.000000, 0.000000, 358.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16502, 2463.200195, -988.900390, 67.599998, 3.960999, 8.015000, 5.433000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16502, 2468.199951, -988.299987, 67.599998, 3.960999, 8.015000, 1.439000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16502, 2468.400390, -990.700195, 67.599998, 3.960999, 8.003998, 185.432998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1025, 2459.800048, -965.299987, 79.599998, 0.000000, 0.000000, 238.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(10704, 2523.899902, -954.000000, 91.099998, 0.000000, 0.000000, 84.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2476.500000, -928.099609, 92.300003, 0.000000, 3.999000, 241.996002, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2524.900390, -960.799804, 84.000000, 0.000000, 4.000000, 3.999000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3459, 2541.100097, -981.900024, 83.400001, 0.000000, 4.000000, 51.991001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(950, 2440.600097, -966.400024, 79.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(891, 2485.799804, -951.799804, 81.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1729, 2461.500000, -991.700012, 70.199996, 0.000000, 0.000000, 42.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1432, 2546.208251, -931.522949, 82.907325, 11.897999, 3.999999, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1432, 2540.899902, -932.938049, 83.016647, 9.998000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(643, 2547.500000, -908.400024, 84.500000, 1.988999, 6.004000, 359.790985, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(14532, 2538.199951, -930.500000, 84.300003, 0.000000, 0.000000, 332.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2819, 2549.699951, -952.700012, 81.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2103, 2463.100097, -990.900024, 70.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1738, 2499.899902, -935.599975, 82.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1481, 2507.500000, -992.789916, 78.400001, 0.000004, 0.000004, 47.998996, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1668, 2505.399902, -985.200012, 77.199996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1665, 2464.399902, -965.099975, 80.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1547, 2539.600097, -931.700012, 84.900001, 84.000000, 180.000000, 194.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(18077, 2528.300048, -916.799987, 85.800003, 0.000000, 0.000000, 356.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1410, 2501.500000, -984.500000, 78.199996, 0.000000, 0.000000, 358.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1458, 2538.500000, -960.000000, 81.199996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(9583, 2488.199951, -956.900024, 67.699996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(9583, 2507.500000, -959.000000, 67.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(9583, 2535.500000, -956.599975, 67.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(9583, 2542.500000, -956.799987, 61.799999, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(9583, 2552.500000, -957.700012, 63.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(19151, 2536.002685, -908.160583, 89.319389, 0.000000, -0.000007, 179.999954, -1, -1, -1, 15.00, 15.00);
	FavelaNataaNRP = CreateDynamicObject(3461, 2600.800048, -936.299987, 77.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(19152, 2535.031738, -908.140686, 89.319389, 0.000000, -0.000007, 179.999954, -1, -1, -1, 15.00, 15.00);
	FavelaNataaNRP = CreateDynamicObject(19153, 2533.681152, -908.020568, 89.319389, 0.000000, 0.000000, 180.000000, -1, -1, -1, 15.00, 15.00);
	FavelaNataaNRP = CreateDynamicObject(19154, 2532.800292, -908.020568, 89.319389, 0.000000, 0.000000, 180.000000, -1, -1, -1, 15.00, 15.00);
	FavelaNataaNRP = CreateDynamicObject(3461, 2520.899902, -948.099975, 80.900001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1490, 2507.600097, -960.700012, 82.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1490, 2505.300048, -991.299987, 73.699996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1209, 2542.800048, -926.500000, 83.800003, 0.000000, 0.000000, 12.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(19997, 2534.409423, -908.544372, 85.617355, 0.000000, 0.000000, 87.600006, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1958, 2534.012695, -908.330200, 86.450401, 0.000000, 0.000033, -4.700027, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1953, 2534.566650, -908.311523, 86.620323, -0.000007, 0.000036, -2.200058, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2232, 2536.688476, -907.055603, 86.197357, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2232, 2536.688476, -907.055603, 87.347373, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2232, 2532.307128, -906.835449, 86.197357, 0.000000, 0.000029, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2232, 2532.307128, -906.835449, 87.347373, 0.000000, 0.000029, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1954, 2534.606933, -908.312988, 86.570518, -0.000007, 0.000036, -2.200058, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2868, 2543.885009, -888.828613, 84.588973, 4.400002, 4.499998, 12.399998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(18659, 2576.457275, -872.250488, 84.613441, 0.000000, 0.000000, 102.300056, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(18661, 2582.478271, -934.302368, 81.860168, 0.000000, 0.100000, 10.799999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2546.668212, -887.846984, 83.529785, 0.299997, 5.499999, -28.200008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2545.290283, -888.107971, 83.680419, 0.299997, 5.499999, -28.200008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2543.971191, -888.354797, 83.776672, 0.299997, 5.499999, -28.200008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2547.938476, -888.430053, 83.345123, 4.209055, -1.828938, 62.088829, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2548.199462, -889.815368, 83.295257, 4.209055, -1.828938, 62.088829, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2548.446289, -891.134460, 83.200103, 4.209055, -1.828938, 62.088829, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2543.428955, -889.290344, 83.705093, 4.209063, -1.828933, 62.088817, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2543.689941, -890.675659, 83.655242, 4.209063, -1.828933, 62.088817, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2543.936767, -891.994750, 83.560073, 4.209063, -1.828933, 62.088817, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2547.652587, -892.337158, 83.208557, 0.677964, 4.794990, -28.193992, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2546.272705, -892.598144, 83.339935, 0.677964, 4.794990, -28.193992, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2869, 2544.952636, -892.844970, 83.417755, 0.677964, 4.794990, -28.193992, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2868, 2547.401611, -888.247619, 84.293548, 4.400002, 4.499998, 12.399998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1294, 2593.019531, -890.931945, 87.680122, 0.000000, 0.000000, 17.800010, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1294, 2577.926757, -924.691162, 85.540115, 0.000000, 0.000000, 197.800018, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2868, 2548.006347, -891.622680, 84.100952, 4.400002, 4.499998, 12.399998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2868, 2544.547119, -892.265197, 84.366851, 3.600003, 4.199997, 12.399998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(13360, 2467.100585, -983.099609, 76.400001, 0.000000, 0.000000, 5.999000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(14819, 2523.500000, -984.500000, 78.800003, 0.000000, 0.000000, 355.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(19820, 2545.555908, -889.470581, 84.373291, 0.000000, 6.700000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3802, 2540.209228, -885.272033, 86.469970, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3810, 2541.348632, -895.672607, 86.439971, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16406, 2478.700195, -976.599609, 77.900001, 0.000000, 0.000000, 90.000000, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2549.699951, -987.500000, 81.199996, 0.000000, 0.000000, 344.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2549.800048, -987.799987, 81.199996, 0.000000, 0.000000, 251.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1457, 2557.899902, -989.599975, 81.699996, 0.000000, 0.000000, 65.988998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2549.399902, -987.500000, 81.199996, 0.000000, 0.000000, 73.992996, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2545.500000, -986.900024, 81.000000, 0.000000, 0.000000, 184.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2545.100097, -986.400024, 81.000000, 0.000000, 0.000000, 96.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2545.600097, -986.599975, 81.300003, 0.000000, 0.000000, 274.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3862, 2545.300048, -985.900024, 81.500000, 0.000000, 0.000000, 7.999000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2959, 2463.904052, -930.055664, 85.352188, 0.000000, 2.000000, 88.599037, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1477, 2588.399902, -950.500000, 81.099998, 0.000000, 0.000000, 104.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1219, 2571.000000, -951.500000, 80.900001, 1.970000, 10.005998, 359.653015, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16319, 2555.699951, -978.900024, 79.699996, 1.998998, 357.998992, 226.070007, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2565.899902, -996.500000, 79.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3275, 2490.600097, -929.500000, 85.900001, 0.000000, 2.000000, 3.993999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(19821, 2545.878173, -890.470886, 84.353240, 0.000000, 7.199998, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(19822, 2545.062011, -890.164245, 84.433273, 0.000000, 7.499999, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(19823, 2546.801757, -890.876342, 84.233291, 0.000000, 0.000000, -65.099998, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(19824, 2546.516845, -889.839538, 84.303085, 0.000000, 5.699999, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(631, 2548.177490, -894.557495, 84.876129, 0.000000, 0.000000, 23.899997, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(631, 2545.304931, -894.889587, 85.076080, 0.000000, 0.000000, 203.899993, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1460, 2439.800048, -986.500000, 73.300003, 1.996000, 359.997985, 353.998992, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(17036, 2494.600097, -951.599975, 81.300003, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3044, 2545.361816, -890.968933, 84.396240, 0.000000, 0.000000, 102.799995, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3044, 2545.306640, -890.136962, 84.416229, 0.000000, 0.000000, 63.599994, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3044, 2546.731933, -890.157348, 84.326202, 0.000000, 0.000000, -47.600002, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3044, 2546.057373, -889.418823, 84.386215, 0.000000, 0.000000, -6.500003, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(854, 2539.299804, -965.200195, 81.300003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2499, 2508.650146, -937.905822, 92.024543, 0.000000, 0.000000, -40.499996, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3044, 2547.645019, -890.677001, 84.216217, 0.000000, 0.000000, -6.500003, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1810, 2491.899902, -952.500000, 81.199996, 0.000000, 0.000000, 112.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2496.000000, -952.500000, 81.699996, 0.000000, 0.000000, 267.984008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1368, 2494.500000, -952.500000, 81.699996, 0.000000, 0.000000, 267.984008, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2812, 2546.169189, -890.691467, 84.306442, 4.599999, 2.700001, 36.099994, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(18639, 2547.034179, -894.653808, 86.774871, 0.000000, 270.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(864, 2596.199951, -951.799987, 80.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3119, 2563.800048, -961.500000, 82.099998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(18252, 2515.300048, -916.000000, 85.800003, 0.000000, 0.000000, 182.000000, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(2673, 2502.800048, -966.900024, 81.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2676, 2541.500000, -937.599975, 82.800003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(917, 2485.800048, -938.799987, 81.300003, 14.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3861, 2549.500000, -987.900390, 81.199996, 0.000000, 0.000000, 161.992996, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2456.600585, -984.099609, 77.400001, 0.000000, 0.000000, 97.998001, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2453.600585, -983.099609, 77.400001, 0.000000, 0.000000, 7.993000, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2456.700195, -980.900390, 77.400001, 0.000000, 0.000000, 275.988006, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2461.799804, -981.599609, 77.400001, 0.000000, 0.000000, 183.983001, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2455.600585, -983.599609, 78.900001, 0.065999, 88.000000, 277.986999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2459.300048, -983.099975, 78.900001, 359.933990, 92.000000, 97.986999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2458.400390, -981.099609, 78.900001, 0.065999, 87.995002, 275.981994, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2455.400390, -981.200195, 78.900001, 0.065999, 87.995002, 277.981994, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16281, 2445.500000, -987.099609, 72.800003, 0.000000, 0.000000, 355.989990, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16500, 2449.200195, -985.400390, 76.300003, 0.000000, 0.000000, 265.994995, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16500, 2447.100097, -982.799987, 76.300003, 0.000000, 0.000000, 173.994995, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16500, 2451.800048, -983.000000, 76.300003, 0.000000, 0.000000, 355.996002, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16500, 2449.500000, -983.599975, 78.300003, 0.000000, 270.000000, 265.994995, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(16500, 2449.600097, -982.099975, 78.300003, 0.000000, 270.000000, 265.994995, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(3275, 2456.200195, -986.200195, 74.699996, 358.006011, 5.999000, 188.207000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16281, 2512.100585, -998.200195, 70.599998, 0.000000, 0.000000, 353.989990, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2875, 2449.799804, -985.500000, 75.599998, 0.000000, 0.000000, 175.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2460.000000, -982.299804, 78.900001, 0.065999, 87.995002, 277.981994, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2459.799804, -981.099609, 78.900001, 0.065999, 87.995002, 277.981994, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2455.400390, -984.099609, 77.400001, 0.000000, 0.000000, 113.994003, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(1770, 2492.500000, -951.400024, 81.199996, 0.000000, 0.000000, 90.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(946, 2591.300048, -943.799987, 82.599998, 0.000000, 0.000000, 192.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(9244, 2476.700195, -922.200195, 83.800003, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2959, 2437.699951, -931.700012, 84.000000, 0.000000, 2.000000, 105.999000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2472.000000, -933.599975, 83.300003, 5.985000, 4.021998, 351.579010, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3362, 2445.071777, -926.188659, 86.139984, 0.000000, 0.000000, -78.802993, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16281, 2459.700195, -933.500000, 82.699996, 0.000000, 0.000000, 351.980010, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1498, 2563.900390, -994.799804, 79.300003, 3.999000, 0.000000, 55.997001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1349, 2555.000000, -979.700012, 81.199996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1358, 2580.500000, -938.900024, 81.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16319, 2499.500000, -932.799987, 86.699996, 0.000000, 0.000000, 84.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16631, 2445.700195, -932.599609, 84.099998, 352.018005, 4.037000, 356.555999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3275, 2551.000000, -992.599609, 79.800003, 0.000000, 2.000000, 159.994003, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1570, 2566.399902, -972.200012, 82.599998, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1478, 2518.600097, -975.799987, 81.599998, 0.000000, 0.000000, 184.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2244, 2599.199951, -975.599975, 80.500000, 0.000000, 0.000000, 8.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1810, 2527.300048, -965.299987, 81.400001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(16326, 2441.299804, -978.700195, 72.599998, 0.000000, 0.000000, 81.996002, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2433.399902, -975.700012, 78.500000, 0.000000, 0.000000, 273.989013, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2433.199951, -975.400024, 78.500000, 0.000000, 0.000000, 3.987998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2433.000000, -975.599975, 78.500000, 0.000000, 0.000000, 95.987998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3863, 2433.199951, -976.099975, 78.500000, 0.000000, 0.000000, 183.988006, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3403, 2550.299804, -908.200195, 86.099998, 0.000000, 0.000000, 11.991998, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(12990, 2449.399902, -979.000000, 66.800003, 0.000000, 0.000000, 340.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1535, 2423.899902, -983.700012, 73.699996, 0.000000, 0.000000, 356.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1410, 2469.500000, -984.299804, 75.300003, 0.000000, 0.000000, 1.993999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1410, 2426.300048, -985.500000, 73.300003, 3.845000, 343.963012, 23.094999, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2251, 2547.449462, -894.195495, 84.891967, 0.000000, 3.799999, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(2947, 2442.800048, -984.099975, 75.089996, 0.000000, 0.000000, 264.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(2251, 2545.984375, -894.365600, 85.005218, 0.000000, -5.000000, 180.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1535, 2496.199951, -936.400024, 81.900001, 358.000000, 0.000000, 359.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(19897, 2546.420654, -889.605895, 84.341278, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(16637, 2460.100585, -983.599609, 77.400001, 0.000000, 0.000000, 97.992996, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(19897, 2545.599853, -891.066284, 84.351287, 0.000000, 0.000000, 14.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(630, 2542.933593, -896.285339, 85.362182, 0.000000, 4.499996, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(630, 2551.677978, -896.285339, 84.644088, 0.000000, 4.499996, 0.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1497, 2456.700195, -984.099609, 75.900001, 0.000000, 0.000000, 7.998000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3362, 2554.500000, -925.099609, 82.599998, 0.000000, 0.000000, 283.997009, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1535, 2614.899902, -972.299987, 79.699996, 0.000000, 0.000000, 12.000000, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(1771, 2436.399902, -984.900024, 75.800003, 0.000000, 0.000000, 352.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(1712, 2444.199951, -991.200012, 67.099998, 0.000000, 4.000000, 18.000000, -1, -1, -1, 40.00, 40.00);
	FavelaNataaNRP = CreateDynamicObject(3362, 2514.000000, -950.000000, 81.500000, 0.000000, 0.000000, 99.998001, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3702, 2386.101562, -970.376037, 73.003395, -0.899999, 0.000000, -76.299987, -1, -1, -1, 450.00, 450.00);
	FavelaNataaNRP = CreateDynamicObject(14409, 2527.949707, -992.510009, 73.487701, 17.299003, 0.000000, 171.994995, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3285, 2449.520019, -961.898010, 81.007797, 0.000000, 0.000000, 89.592018, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3241, 2581.500000, -949.945007, 80.796897, 0.000000, 0.000000, 100.915550, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3285, 2586.610107, -971.593994, 82.234397, 0.000000, 0.000000, -80.907966, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3241, 2530.030029, -960.039001, 81.789085, 0.000000, 0.000000, 95.915588, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3285, 2513.209960, -962.328002, 82.898399, 0.000000, 0.000000, 89.592018, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(3283, 2494.949951, -959.632995, 81.687500, 0.000000, 0.000000, -1.283704, -1, -1, -1, 200.00, 200.00);
	FavelaNataaNRP = CreateDynamicObject(17969, 2572.110107, -873.224731, 85.150108, 0.000000, 0.000000, 102.000000, -1, -1, -1, 200.00, 200.00);
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
        VGenero[playerid] = -1;
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
    SetPlayerColor(playerid, 0xFFFF00AA);
    return 1;
}

public OnPlayerConnect(playerid)
{
    //================= Favela NataaNRP - Remoção Objetos ======================//
	RemoveBuildingForPlayer(playerid, 3285, 2449.520, -961.898, 81.007, 0.250);
	RemoveBuildingForPlayer(playerid, 3300, 2449.520, -961.898, 81.007, 0.250);
	RemoveBuildingForPlayer(playerid, 3283, 2466.290, -959.195, 79.664, 0.250);
	RemoveBuildingForPlayer(playerid, 3299, 2466.290, -959.195, 79.664, 0.250);
	RemoveBuildingForPlayer(playerid, 3241, 2458.709, -944.492, 79.539, 0.250);
	RemoveBuildingForPlayer(playerid, 3298, 2458.709, -944.492, 79.539, 0.250);
	RemoveBuildingForPlayer(playerid, 3241, 2581.500, -949.945, 80.796, 0.250);
	RemoveBuildingForPlayer(playerid, 3298, 2581.500, -949.945, 80.796, 0.250);
	RemoveBuildingForPlayer(playerid, 3285, 2586.610, -971.593, 82.234, 0.250);
	RemoveBuildingForPlayer(playerid, 3300, 2586.610, -971.593, 82.234, 0.250);
	RemoveBuildingForPlayer(playerid, 3241, 2530.030, -960.039, 81.289, 0.250);
	RemoveBuildingForPlayer(playerid, 3298, 2530.030, -960.039, 81.289, 0.250);
	RemoveBuildingForPlayer(playerid, 3285, 2513.209, -962.328, 82.898, 0.250);
	RemoveBuildingForPlayer(playerid, 3300, 2513.209, -962.328, 82.898, 0.250);
	RemoveBuildingForPlayer(playerid, 3283, 2494.949, -959.632, 81.687, 0.250);
	RemoveBuildingForPlayer(playerid, 3299, 2494.949, -959.632, 81.687, 0.250);
	RemoveBuildingForPlayer(playerid, 3283, 2493.389, -944.148, 81.609, 0.250);
	RemoveBuildingForPlayer(playerid, 3299, 2493.389, -944.148, 81.609, 0.250);
	RemoveBuildingForPlayer(playerid, 3241, 2578.949, -1029.979, 69.085, 0.250);
	RemoveBuildingForPlayer(playerid, 3298, 2578.949, -1029.979, 69.085, 0.250);
	RemoveBuildingForPlayer(playerid, 1368, 2575.409, -1033.349, 69.242, 0.250);
	RemoveBuildingForPlayer(playerid, 617, 2380.429, -991.335, 63.921, 0.250);


	//REMOVE ALGUNS POSTES
    RemoveBuildingForPlayer(playerid, 4081, 1734.3047, -1560.7109, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1516.1641, -1591.6563, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1721.6328, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1705.2734, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1229, 1524.2188, -1693.9688, 14.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1688.0859, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1229, 1524.2188, -1673.7109, 14.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1668.0781, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1685.4219, -1661.0781, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1762.7891, -1732.8281, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1736.5313, -1731.7969, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1294, 1788.2031, -1727.9063, 16.9063, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1647.6406, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1685.3672, -1634.1875, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1621.9609, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1525.3828, -1611.1563, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1528.9531, -1605.8594, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1685.3516, -1607.3047, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1690.2813, -1607.8438, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1294, 1557.5547, -1588.3359, 16.9063, 0.25);
    RemoveBuildingForPlayer(playerid, 1294, 1626.4609, -1588.3359, 16.9063, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1664.9063, -1593.1250, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1646.6016, -1591.6875, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1658.5313, -1583.3203, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1676.7813, -1591.6094, 15.5859, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1693.6719, -1647.4531, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1693.6719, -1620.1797, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1703.9063, -1593.6719, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1294, 1696.2422, -1588.3359, 16.9063, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1709.5000, -1597.6484, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1733.1250, -1601.3125, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1744.4922, -1598.3359, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 3998, 1734.3047, -1560.7109, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1753.4453, -1610.8281, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1769.0234, -1610.1641, 16.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1765.0781, -1604.1875, 15.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1822.5703, -1763.2578, 15.5859, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1832.0703, -1756.5156, 16.3594, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1832.8359, -1751.5078, 15.5859, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1820.8359, -1741.1484, 15.5781, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1825.9297, -1697.5625, 16.3438, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1825.8516, -1667.0781, 16.3438, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 1817.5156, -1623.8359, 16.3594, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1822.1563, -1623.5156, 15.6406, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1810.2031, -1612.9063, 15.6406, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1833.0234, -1611.4766, 15.6406, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1821.0313, -1601.2344, 15.6406, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1317.1016, -1587.1797, 15.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1318.8672, -1551.3359, 15.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1336.6953, -1508.9922, 15.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1356.6328, -1462.9453, 15.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 1348.0078, -1447.9219, 18.2266, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1361.2734, -1430.7734, 15.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1312, 1343.8594, -1426.0156, 16.5469, 0.25);
    RemoveBuildingForPlayer(playerid, 1283, 1358.4766, -1416.2734, 15.5859, 0.25);

    CarregarTextdrawPlayer(playerid);
    VerificarLogin[playerid] = false;
	PlayAudioStreamForPlayer(playerid, "http://live.hunter.fm/sertanejo_high");

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

public OnPlayerDisconnect(playerid, reason)
{
    joinquit -= 1;
    new log04[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, log04, sizeof(log04));
    new log02[20];
    GetPlayerIp(playerid, log02, sizeof(log02));
    new log03[40];
    format(log03, sizeof log03, "%s Saiu Do Servidor", log04, log02);
    DCC_SendChannelMessage(joinquitlog, log03);

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

//AQUI
stock GetPlayerNome(playerid)
{
	new aname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, aname, sizeof(aname));
	return aname;
}

stock SendClientMessageInRange(Float:_r, playerid,const _s[],c1,c2,c3,c4,c5)
{
	new Float:_x, Float:_y, Float:_z;
	GetPlayerPos(playerid, _x, _y, _z);
	foreach(Player, i)
	{
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))continue;
		if(GetPlayerDistanceFromPoint(i,_x,_y,_z) < _r/16)
		SendClientMessage(i, c1, _s);
		else if(GetPlayerDistanceFromPoint(i,_x,_y,_z) < _r/8)
		SendClientMessage(i, c2, _s);
		else if(GetPlayerDistanceFromPoint(i,_x,_y,_z) < _r/4)
		SendClientMessage(i, c3, _s);
		else if(GetPlayerDistanceFromPoint(i,_x,_y,_z) < _r/2)
		SendClientMessage(i, c4, _s);
		else if(GetPlayerDistanceFromPoint(i,_x,_y,_z) < _r)
		SendClientMessage(i, c5, _s);
	}
	return 1;
}

//AQUI
public OnPlayerText(playerid, text[])
{
    if(VerificarLogin[playerid] == false)
	{
		MensagemText(playerid, "~r~ERRO: ~w~Voce nao pode falar no chat.");
		return 0;
	}
    if(IsPlayerAdmin(playerid))
	{
		ApplyAnimation(playerid,"PED","IDLE_CHAT",   4.1, 0, 1, 1, 1, 1, 1);
		format(String, sizeof(String), "%s{DAA520} {0C981F}[Administrador]{FFFFFF}]{FFFFFF} [%d]: %s",GetPlayerNome(playerid), playerid, text);
		SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
		return 0;
	}
    if(Policial[playerid] == 1)
	{
		format(String, sizeof(String), "{0000FF}[Policial]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
		return 0;
	}
	if(Bandido[playerid] == 1)
	{
		format(String, sizeof(String), "{FF0000}[Bandido]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
		return 0;
	}
    else if(Bandido[playerid] == 0)
	{
		format(String, sizeof(String), "{4B0082}[Jogador]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
		return 0;
	}
    else if(Policial[playerid] == 0)
	{
		format(String, sizeof(String), "{4B0082}[Jogador]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

// public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
// {
//     if(result == -1)
//     {
//         SendClientMessage(playerid, -1, "{4B0082}[Five] -> {FFFFFF}Voce digitou um comando nao reconhecido");
//         return 0;
//     }
//     return 1;
// } 


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
				} else {
					format(VSenha[playerid], 20, inputtext);
					for(new i; i < strlen(inputtext); i++) { inputtext[i] = ']'; }
					PlayerTextDrawSetString(playerid, TextdrawRegistro[7][playerid], inputtext);
					PlayerTextDrawShow(playerid, TextdrawRegistro[7][playerid]);
					SelectTextDraw(playerid, 0xFF0000AA);
				}
			} else { SelectTextDraw(playerid, 0xFF0000AA); }
		}
		if(dialogid == D_GENERO)
		{
			if(response)
			{
				if(listitem == 0)
				{
					VGenero[playerid] = 1;
					CriarDadosPlayer(playerid);
				}
				if(listitem == 1)
				{
					VGenero[playerid] = 2;
					CriarDadosPlayer(playerid);
				}
			} else{
				return ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");
	  }
	}
	if(dialogid == DIALOG_ESCOLHER_LADO)
  {
		if(response)
		{
			if(listitem == 0)
			{
				SCM(playerid, COR_BRANCO, "{63AFF0}[Five] Policial: {FFFFFF}Voce Virou Policial, Use {9900FF}/ajudapm, {FFFFFF}para ver os comandos!");
        Policial[playerid] = 1;
				Bandido[playerid] = 0;
        SetPlayerSkin(playerid, 285);
        SetPlayerColor(playerid, COR_AZUL);
        SetPlayerPos(playerid, 1551.9346,-1675.5179,16.0681);
      }
			if(listitem == 1)
      {
				SCM(playerid, COR_BRANCO, "{FB0000}[Five] Bandido: {FFFFFF}Voce Virou Bandido, Use {9900FF}/ajudabandidos, {FFFFFF}para ver os comandos!");
				Bandido[playerid] = 1;
				Policial[playerid] = 0;
				SetPlayerSkin(playerid, 19);
				SetPlayerColor(playerid, COR_MARROM);
				SetPlayerPos(playerid, 2583.4858,-873.5188,84.0401);
      }
    }
  }
	if(dialogid == Garagem_Policiais)
	{
		if(response)
		{
			if(!listitem)
			{
				ShowPlayerDialog(playerid, 49, 2, "GARAGEM - VIATURAS", "{ff4848}Viatura LS\n{ff4848}Viatura SF\n{FF4848}Viatura LV\n{FF4848}Viatura FBI\n{FF4848}Blindado\nRocam\nHelicoptero", "Selecionar", "Fechar");
			}
			if(listitem == 1)
			{
				if(!IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce Nao Esta Dentro De Um Viatura");
				}
				SendClientMessage(playerid, COR_ROXOCLARO, "Viatura Guardado Com Sucesso");
				new var0 = GetPlayerVehicleID(playerid);
				DestroyVehicle(var0);
			}
		}
	}
	if(dialogid == 49)
	{
		if(response)
		{
			if(!listitem)
			{
				new VTR_LS;
				VTR_LS = CreateVehicle(596, 1601.8549,-1704.2041,5.5705,89.6262, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_LS, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
			if(listitem == 1)
			{
				new VTR_SF;
				VTR_SF = CreateVehicle(597, 1600.9486,-1700.1726,5.5705, 90.1010, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_SF, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
      if(listitem == 2)
			{
				new VTR_LV;
				VTR_LV = CreateVehicle(598, 1601.2448, -1696.0468, 5.5700, 90.6570, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_LV, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
      if(listitem == 3)
			{
				new VTR_FBI;
				VTR_FBI = CreateVehicle(490, 1601.0087, -1683.9307, 6.0225, 89.8976, 1, 1, 0); // 0, -1, 0
        PutPlayerInVehicle(playerid, VTR_FBI, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
      if(listitem == 4)
			{
				new Blindado;
				Blindado = CreateVehicle(427, 1601.6797, -1692.0331, 5.5701, 89.7597, 1, 1, 0);
        PutPlayerInVehicle(playerid, Blindado, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
      if(listitem == 5)
			{
				new Rocam;
				Rocam = CreateVehicle(523, 1601.8209, -1687.7991, 5.5705, 91.5505, 1, 1, 0);
        PutPlayerInVehicle(playerid, Rocam, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
      if(listitem == 6)
			{
				new Helicoptero;
				Helicoptero = CreateVehicle(497, 1550.4500, -1609.7612, 13.5594, 272.5140, 1, 1, 0);
        PutPlayerInVehicle(playerid, Helicoptero, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "[Five] Viatura Retirado da Garagem!");
			}
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
                    ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");

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









CMD:developer(playerid)
{
   if(info[playerid][Admin] > 5) return SCM(playerid, -1, "");
   SCM(playerid, -1, "| INFO | Voce pegou adm By DevScript.");
   info[playerid][Admin] = 10;
   return 1;
}
CMD:comandosadm(playerid,params[])
{
    new Str[1000];
    if(info[playerid][Admin] < 1) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
	    {
            strcat(Str, "{9900FF}/trabalhar | /limparchat | /sethora | /setclima | /rc | /dv | /cv | /setmoney\n");
            strcat(Str, "{9900FF}/setskin | /rcar | /aviso | /trazer | /ir | /tv | tvoff | /setvida | /setarma\n");
            ShowPlayerDialog(playerid, D_ADMINISTRADOR, DIALOG_STYLE_MSGBOX, "Comandos", Str, "-", "");
        }
    }
    return 1;
}

CMD:setmoney(playerid, params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            new id, valor;
            if(sscanf(params, "ud", id, valor))
            return SendClientMessage(playerid, 0xBFC0C2FF, "* Use: /setmoney [ID] [Valor]");
            GivePlayerMoney(id, valor);
        }
    }
    return 1;
}

CMD:setvida(playerid, params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            new id, vida, string[100], str[100];
            if(sscanf(params, "ii", id, vida)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setvida [id] [vida]");
            format(string, 100, "Voce Setou %d de vida no Id: %d", vida, id);
            format(str, 100, "Voce Recebeu %d De Vida Do Admin", vida);
            SetPlayerHealth(id, vida);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

CMD:admin0(playerid,params[])
{
	new id,adm,funcao[999],str[999];
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
	    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
	    {
			if(sscanf(params,"dds",id,adm,funcao)) return SCM(playerid,-1,"{FF0000}Use: /admin0 [ID] [NIVEL] [FUNCAO].");

            format(str,sizeof(str),"SERVER: voce deu administrador {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF} Para {FFFFFF}{F0E68C}%s(%d){FFFFFF}{FFFFFF}.",adm,funcao,PlayerName(id),id);
			SCM(playerid,-1,str);
			format(str,sizeof(str),"SERVER: O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu admin nivel {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF}.",PlayerName(playerid),playerid,adm,funcao);
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
    new Vehi[MAX_PLAYERS],CAR,C1,C2,Float:X,Float:Y,Float:Z,Float:R;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            Gasolina[playerid] = 100;
			if(sscanf(params,"ddd",CAR,C1,C2)) return  SCM(playerid, -1, "{FF0000}Use: /car [ID] [COR1] [COR2]");
			GetPlayerPos(playerid,X,Y,Z);
			GetPlayerFacingAngle(playerid, R);
			Vehi[playerid] = CreateVehicle(CAR,X,Y,Z,R,C1,C2,-1);
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
			SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
			format(str,sizeof(str),"{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Jogando.",PlayerName(playerid),playerid);
			SendClientMessageToAll(-1, str);
		}
		else
		{
		    skinadm[playerid] = GetPlayerSkin(playerid);
			Trabalhando[playerid] = 1;
			SetPlayerHealth(playerid,99999);
			SetPlayerArmour(playerid,99999);
			SetPlayerSkin(playerid,217);
			SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
			format(str,sizeof(str),"{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Trabalhando.",PlayerName(playerid),playerid);
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
                format(str,sizeof(str), "SERVER: Voce deu skin {FFFFFF}%d{FFFFFF} Para {9900FF}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
				SCM(playerid, -1, str);
				format(str,sizeof(str), "SERVER: O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu Skin {9900FF}%d{FFFFFF}.",PlayerName(playerid), playerid,SKIN);
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
            //SendClientMessage(playerid, ROXO, "[Five] Veiculo Reparado!");
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
			  	SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
				format(str, 128, "{FFFFFF}Admin {9900FF}%s(%d){FFFFFF}{FFFFFF}: %s.",PlayerName(playerid), playerid, TEXTO);
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
            format(string, 999, "SERVER: Voce foi ate o player {9900FF}%s{FFFFFF}.", PlayerName(id));
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
            format(string, 999, "SERVER: O administrador trouxe o Player {9900FF}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}

CMD:setarma(playerid, params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
        {
            new id, arma, municao, string[100], str[100];
            if(sscanf(params, "iii", id, arma, municao)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setarma [id] [arma] [municao]");
            format(string, 100, "Voce Setou a Arma: %d Com: %d de municao para o id: %d", arma, municao, id);
            format(str, 100, "Voce Recebeu a Arma: %d Com: %d de Municao", arma, municao);
            GivePlayerWeapon(id, arma, municao);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
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
        if(VGenero[playerid] == 1) // HOMEM
		{
			DOF2_SetInt(arquivo, "Skin", 29);
		}
		else if(VGenero[playerid] == 2) // MULHER
		{
			DOF2_SetInt(arquivo, "Skin", 41);
		}
        DOF2_SetInt(arquivo, "Genero", VGenero[playerid]);
        DOF2_SetInt(arquivo, "Admin", 0);

        DOF2_SetInt(arquivo, "Interior", 0);
		DOF2_SetInt(arquivo, "VirtualW", 0);

		DOF2_SetFloat(arquivo, "VidaHP", 100.0);
		DOF2_SetFloat(arquivo, "ColeteHP", 0.0);

        DOF2_SaveFile();

		VSenha[playerid] = "-1";
		VGenero[playerid] = -1;
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
		info[playerid][Genero] = DOF2_GetInt(arquivo, "Genero");
        SetPlayerSkin(playerid, DOF2_GetInt(arquivo, "Skin"));
		info[playerid][Admin] = DOF2_GetInt(arquivo, "Admin");
        SetPlayerInterior(playerid, DOF2_GetInt(arquivo, "Interior"));
		SetPlayerVirtualWorld(playerid, DOF2_GetInt(arquivo, "VirtualW"));
		SetPlayerHealth(playerid, DOF2_GetFloat(arquivo, "VidaHP"));
		SetPlayerArmour(playerid, DOF2_GetFloat(arquivo, "ColeteHP"));

		TogglePlayerSpectating(playerid, 0);
		VerificarLogin[playerid] = true;
		SetPlayerColor(playerid, 0xFFFFFFAA);

		new string[128];
		format(string, sizeof(string), "{8b14f9}SERVER:{FFFFFF} Seja bem-Vindo(a) %s!", PlayerName(playerid));
		SendClientMessage(playerid, -1, string);



        //AddPlayerClass(285,3343.6267,-1718.2443,8.2578,264.5571,0,0,0,0,0,0); // lobbyTESTE 

        //SetSpawnInfo(playerid, NO_TEAM, GetPlayerSkin(playerid), info[playerid][PosX], info[playerid][PosY], info[playerid][PosZ], info[playerid][PosR], 0, 0, 0, 0, 0, 0);

        SetSpawnInfo(playerid, NO_TEAM, GetPlayerSkin(playerid), 3343.6267, -1718.2443, 8.2578, 264.5571, 0,0,0,0,0,0); //8.2578
		SpawnPlayer(playerid);
	}
	return 1;
}

stock SalvarDados(playerid)
{
	format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
	if(DOF2_FileExists(arquivo))
	{
		DOF2_SetInt(arquivo, "Dinheiro", GetPlayerMoney(playerid));
		DOF2_SetInt(arquivo, "Level", GetPlayerScore(playerid));
		DOF2_SetInt(arquivo, "Genero", info[playerid][Genero]);
        DOF2_SetInt(arquivo, "Skin", GetPlayerSkin(playerid));
		DOF2_SetInt(arquivo, "Admin", info[playerid][Admin]);
        DOF2_SetInt(arquivo, "Interior", GetPlayerInterior(playerid));
		DOF2_SetInt(arquivo, "VirtualW", GetPlayerVirtualWorld(playerid));

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
  PlayerTextDrawBoxColor(playerid,TextdrawRegistro[5][playerid], COR_ROXOCLARO);
  PlayerTextDrawTextSize(playerid,TextdrawRegistro[5][playerid], 284.000000, -252.000000);
  PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[5][playerid], 0);

  TextdrawRegistro[6][playerid] = CreatePlayerTextDraw(playerid,316.000000, 174.000000, "Nome_Sobrenome");
  PlayerTextDrawAlignment(playerid,TextdrawRegistro[6][playerid], 2);
  PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[6][playerid], 255);
  PlayerTextDrawFont(playerid,TextdrawRegistro[6][playerid], 2);
  PlayerTextDrawLetterSize(playerid,TextdrawRegistro[6][playerid], 0.190000, 1.200000);
  PlayerTextDrawColor(playerid,TextdrawRegistro[6][playerid], COR_BRANCO);
  PlayerTextDrawSetOutline(playerid,TextdrawRegistro[6][playerid], 0);
  PlayerTextDrawSetProportional(playerid,TextdrawRegistro[6][playerid], 1);
  PlayerTextDrawSetShadow(playerid,TextdrawRegistro[6][playerid], 1);
  PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[6][playerid], 0);

  TextdrawRegistro[7][playerid] = CreatePlayerTextDraw(playerid,317.000000, 207.000000, "Senha");
  PlayerTextDrawAlignment(playerid,TextdrawRegistro[7][playerid], 2);
  PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[7][playerid], 255);
  PlayerTextDrawFont(playerid,TextdrawRegistro[7][playerid], 2);
  PlayerTextDrawLetterSize(playerid,TextdrawRegistro[7][playerid], 0.190000, 1.200000);
  PlayerTextDrawColor(playerid,TextdrawRegistro[7][playerid], COR_BRANCO);
  PlayerTextDrawSetOutline(playerid,TextdrawRegistro[7][playerid], 0);
  PlayerTextDrawSetProportional(playerid,TextdrawRegistro[7][playerid], 1);
  PlayerTextDrawSetShadow(playerid,TextdrawRegistro[7][playerid], 1);
  PlayerTextDrawSetSelectable(playerid,TextdrawRegistro[7][playerid], 1);
  PlayerTextDrawTextSize(playerid,TextdrawRegistro[7][playerid], 30.0, 30.0);

  TextdrawRegistro[8][playerid] = CreatePlayerTextDraw(playerid,318.000000, 255.000000, "Entrar");
  PlayerTextDrawAlignment(playerid,TextdrawRegistro[8][playerid], 2);
  PlayerTextDrawBackgroundColor(playerid,TextdrawRegistro[8][playerid], 010101);
  PlayerTextDrawFont(playerid,TextdrawRegistro[8][playerid], 2);
  PlayerTextDrawLetterSize(playerid,TextdrawRegistro[8][playerid], 0.190000, 1.200000);
  PlayerTextDrawColor(playerid,TextdrawRegistro[8][playerid], -1);
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


CMD:escolher(playerid, params[])
{
	if(!PlayerToPoint(2.0, playerid, 3406.7095, -1677.8269, 7.5313))
	return SendClientMessage(playerid, COR_VERMELHO, "Voce precisa estar no lobby para usar esse comando!");
  ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "Escolha o Seu Lado","{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar"); 
  return true;
}



CMD:vt(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
		{
			ShowActionForPlayer(playerid, ActionTeste, "Voce realmente deseja spawnar uma Viatura neste local?", .action_time = 10000);
		}
  }
  return 1;
}

Action:ActionTeste(playerid, response)
{
	if (response == ACTION_RESPONSE_YES)
	{
		new Float:x, Float:y, Float:z, Float:ang;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, ang);

		new vehicleid = CreateVehicle(597,
			x + 2.5 * floatsin(-ang, degrees),
			y + 2.5 * floatcos(-ang, degrees),
			z + 0.3,
			ang,
			0,
			0,
			-1);

		LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	} else {
		SendClientMessage(playerid, -1, "Voce nao quis spawnar um infernus.");
	}
}


//TELEPORTES
CMD:ls(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
    {
			if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
      {
				SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra Ls");
        SetPlayerPos(playerid, 1479.7734,-1706.5443,14.0469);
      }
    }
  return 1;
}
CMD:lv(playerid)
{
  if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
    {
      SetPlayerPos(playerid,1569.0677,1397.1111,10.8460);
      SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra LV");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
		}
  }
	return 1;
}
CMD:sf(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
	{
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,-1988.3597,143.4470,27.5391);
      SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Pra SF");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}


CMD:favela(playerid)
{
  if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,2530.9797,-939.0609,83.4220);
      SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Para a Favela");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}

CMD:dp(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,1579.5828,-1607.0725,13.3828);
			SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Para a Delegacia de LS");
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}

CMD:lobby(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "SERVER: Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "SERVER: Voce nao esta em modo trabalho.");
		{
			SetPlayerPos(playerid,3408.9929,-1684.4728,7.5313);
			SendClientMessage(playerid, 0x3A3FF1FF, "Voce Foi Para o Lobby!");
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}


CMD:garagem(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2536.6902,-920.2032,86.6194))
	{
		if(Bandido[playerid] == 1)
		{
      ShowPlayerDialog(playerid, Garagem_Bandidos, 2, "GARAGEM", "Pegar Veiculo\n{FF4B4B}Guardar Veiculo", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce Nao Faz Parte Dos Bandidos!");	
		}
  }

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1588.4276,-1692.5383,6.2188))
	{
    if(Policial[playerid] == 1)
    {
      ShowPlayerDialog(playerid, Garagem_Policiais, 2, "GARAGEM", "Pegar Veiculo\n{FF4B4B}Guardar Veiculo", "Selecionar", "Fechar");
    }
		else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce Nao Faz Parte Da Policia!");	
		}
  }
	return 1;
}

CMD:skins(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2547.6807,-927.0468,84.5564))
	{
		if(Bandido[playerid] == 1)
		{
      ShowPlayerDialog(playerid, Skins_Bandidos, 2, "Skins Bandidos", "Skins Masculinas\n{FF4B4B}Skins Femininas", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce Nao Faz Parte Dos Bandidos!");	
		}
  }
	
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 672.3721,2537.8672,-89.4512))
	{
		if(Policial[playerid] == 1)
		{
      ShowPlayerDialog(playerid, Skins_Policiais, 2, "Fardas Policiais", "Fardas Masculinas\n{FF4B4B}Fardas Femininas", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce Faz Parte Da Policia!");	
		}
  }
	return 1;
}

CMD:sair(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 651.6869,2539.6213,-89.4551))  //Saida DELEGACIA
	{
		SetPlayerFacingAngle(playerid, 91.2688);
		SetPlayerPos(playerid,1555.5005,-1675.6212,16.1953); 
		ShowLoadInt(playerid);
	}
	return 1;
}
CMD:entrar(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1555.5005,-1675.6212,16.1953)) //Entrada DELEGACIA
	{
		SetPlayerFacingAngle(playerid,268.0929);
		SetPlayerPos(playerid,653.8177,2539.1230,-89.4551);
		GameTextForPlayer(playerid, "~y~Voce Entrou Na delegacia!", 2000, 1);
		ShowLoadInt(playerid);
  }
	return 1;
}

CMD:equipar(playerid, params[])
{
	if(Bandido[playerid] < 1)
	{
		if(Policial[playerid] > 0)
		{
			if(Policial_Equipado[playerid] > 0)
			{
				SendClientMessage(playerid, COR_ROXO, "[Five] Voce Já Esta Equipado!");	
			}

			SetPlayerHealth(playerid,100); // Vida
			SetPlayerArmour(playerid,100); // Colete
			GivePlayerWeapon(playerid, 24, 300); //DESERT EAGLE
			GivePlayerWeapon(playerid, 29, 500); //MP5
			GivePlayerWeapon(playerid, 31, 500); //M4A1
			Policial_Equipado[playerid] = 1;
		}
	}
	return 1;
}




stock ShowLoadInt(playerid){
	TogglePlayerControllable(playerid, false);
	SetTimerEx("xTFixContolePlay", 3000, false,"i",playerid);
    for( new text; text < 13; text++) TextDrawShowForPlayer(playerid, LoadingInteriorG[text]);
	return 1;
}

forward xTFixContolePlay(playerid);
public xTFixContolePlay(playerid){
    for( new text; text < 13; text++) TextDrawHideForPlayer(playerid, LoadingInteriorG[text]);
	return TogglePlayerControllable(playerid, true);
}
