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


#define Garagem_Bandido                   48
#define Garagem_Policial                  49

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
new DCC_Channel:statuschannel; 
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

	Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /skins", -1, 2547.4292, -926.9975, 84.5811, 30.0, 0, 0); //SKINS BANDIDOS
  CreatePickup(19134, 23, 2547.4292, -926.9975, 84.5811); //SKINS BANDIDOS

	Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /garagem", -1, 1588.4276, -1692.5383, 6.2188, 30.0, 0, 0); //GARAGEM POLICIAIS
  CreatePickup(19134, 23, 1588.4276, -1692.5383, 6.2188); //GARAGEM POLICIAIS

	Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /guardarv", -1, 1585.6941,-1677.2054,5.8978, 30.0, 0, 0); //GARAGEM POLICIAIS
  CreatePickup(19134, 23, 1585.6941,-1677.2054,5.8978); //GARAGEM POLICIAIS

	Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /guardarv", -1, 2534.2649, -911.4888, 86.6154, 30.0, 0, 0); //GARAGEM POLICIAIS
  CreatePickup(19134, 23, 2534.2649, -911.4888, 86.6154); //GARAGEM POLICIAIS

	Create3DTextLabel("{FFFFFF}DELEGACIA\n{836FFF}Digite /entrar para entrar na DELEGACIA",0xFFA500AA,1555.5005,-1675.6212,16.1953,10.0,0);
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

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
		new string[256];
		format(string,256,"{FFFFFF}Comando Invalido", cmdtext);
		SendClientMessage(playerid, -1, string);
	}
  return 1;
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


	if(dialogid == Garagem_Policial)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new VTR_LS;
				VTR_LS = CreateVehicle(596, 1601.8549,-1704.2041,5.5705,89.6262, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_LS, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
			if(listitem == 1)
			{
				new VTR_SF;
				VTR_SF = CreateVehicle(597, 1600.9486,-1700.1726,5.5705, 90.1010, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_SF, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 2)
			{
				new VTR_LV;
				VTR_LV = CreateVehicle(598, 1601.2448, -1696.0468, 5.5700, 90.6570, 1, 1, 0);
        PutPlayerInVehicle(playerid, VTR_LV, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 3)
			{
				new VTR_FBI;
				VTR_FBI = CreateVehicle(490, 1601.0087, -1683.9307, 6.0225, 89.8976, 1, 1, 0); // 0, -1, 0
        PutPlayerInVehicle(playerid, VTR_FBI, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 4)
			{
				new Blindado;
				Blindado = CreateVehicle(427, 1601.6797, -1692.0331, 5.5701, 89.7597, 1, 1, 0);
        PutPlayerInVehicle(playerid, Blindado, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 5)
			{
				new Rocam;
				Rocam = CreateVehicle(523, 1601.8209, -1687.7991, 5.5705, 91.5505, 1, 1, 0);
        PutPlayerInVehicle(playerid, Rocam, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 6)
			{
				new Helicoptero;
				Helicoptero = CreateVehicle(497, 1550.4500, -1609.7612, 13.5594, 272.5140, 1, 1, 0);
        PutPlayerInVehicle(playerid, Helicoptero, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
		}
		return true;
	}


	if(dialogid == Garagem_Bandido)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new CarSultan;
				CarSultan = CreateVehicle(560, 2533.8132,-913.4097,86.3253,176.4708,0, -1, 0);
        PutPlayerInVehicle(playerid, CarSultan, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
			if(listitem == 1)
			{
				new CarElegy;
				CarElegy = CreateVehicle(562, 2533.8132,-913.4097,86.3253, 176.4708, 0, -1, 0);
        PutPlayerInVehicle(playerid, CarElegy, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 2)
			{
				new CarCheetah;
				CarCheetah = CreateVehicle(415, 2533.8132,-913.4097,86.3253, 176.4708, 0, -1, 0);
        PutPlayerInVehicle(playerid, CarCheetah, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 3)
			{
				new MotoPCJ;
				MotoPCJ = CreateVehicle(461, 2533.8132,-913.4097,86.3253, 176.4708, 0, -1, 0);
        PutPlayerInVehicle(playerid, MotoPCJ, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
      if(listitem == 4)
			{
				new VanBurrito;
				VanBurrito = CreateVehicle(482, 2533.8132,-913.4097,86.3253, 176.4708, 0, -1, 0);
        PutPlayerInVehicle(playerid, VanBurrito, 0);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
			}
		}
	}


	if(dialogid == Skins_Bandidos)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, SkinsMasculinas_Bandidos, DIALOG_STYLE_LIST, "Skins Masculinas", "{1E90FF}Skin 01\n{1E90FF}Skin 02\n{1E90FF}Skin 03\n{1E90FF}Skin 04\n{1E90FF}Skin 05", "Selecionar", "Fechar");
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, SkinsFemininas_Bandidos, DIALOG_STYLE_LIST, "Skins Femininas", "{FF69B4}Skin 01\n{FF69B4}Skin 02\n{FF69B4}Skin 03\n{FF69B4}Skin 04\n{FF69B4}Skin 05", "Selecionar", "Fechar");
			}
		}
	}
	if(dialogid == SkinsMasculinas_Bandidos)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerSkin(playerid, 115);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 01 Selecionada!");
			}
			if(listitem == 1)
			{
				SetPlayerSkin(playerid, 293);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 02 Selecionada!");
			}
            if(listitem == 2)
			{
				SetPlayerSkin(playerid, 123);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 03 Selecionada!");
			}
            if(listitem == 3)
			{
				SetPlayerSkin(playerid, 230);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 04 Selecionada!");
			}
            if(listitem == 4)
			{
				SetPlayerSkin(playerid, 292);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 05 Selecionada!");
			}
		}
	}
	if(dialogid == SkinsFemininas_Bandidos)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerSkin(playerid, 298);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 01 Selecionada!");
			}
			if(listitem == 1)
			{
				SetPlayerSkin(playerid, 193);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 02 Selecionada!");
			}
            if(listitem == 2)
			{
				SetPlayerSkin(playerid, 169);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 03 Selecionada!");
			}
            if(listitem == 3)
			{
				SetPlayerSkin(playerid, 55);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 04 Selecionada!");
			}
            if(listitem == 4)
			{
				SetPlayerSkin(playerid, 12);
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 05 Selecionada!");
			}
		}
	}
	return false;
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
	if (!DOF2_FileExists (arquivo))
	{
		DOF2_CreateFile (arquivo) ; // caso o nome dele não esteja na pasta administradores.
	}
	if(info[playerid][Admin] > 5) return SCM(playerid, -1, "");

  DOF2_SetInt (arquivo, "Admin" , 10 ) ; // irá setar na linha Admin o valor do nível desejado. 
  DOF2_SaveFile(); // salva e fecha o arquivo. 
	info[playerid][Admin] = 10;
	SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Correct!");
  return 1;
}
CMD:comandosadm(playerid,params[])
{
    new Str[1000];
    if(info[playerid][Admin] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
	{
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, valor;
            if(sscanf(params, "ud", id, valor))
            return SendClientMessage(playerid, 0xBFC0C2FF, "{9900FF}[Five] {FFFFFF}* Use: /setmoney [ID] [Valor]");
            GivePlayerMoney(id, valor);
        }
    }
    return 1;
}

CMD:setvida(playerid, params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, vida, string[100], str[100];
            if(sscanf(params, "ii", id, vida)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setvida [id] [vida]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce setou %d de vida no ID: %d", vida, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce recebeu %d de vida do Admin", vida);
            SetPlayerHealth(id, vida);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

CMD:daradmin(playerid,params[])
{
	new id,adm,funcao[999],str[999];
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
	{
	    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
	    {
			if(sscanf(params,"dds",id,adm,funcao)) return SCM(playerid,-1,"{9900FF}[Five] {FFFFFF}Use: /admin0 [ID] [NIVEL] [FUNCAO].");

            format(str,sizeof(str),"{9900FF}[Five] {FFFFFF}Voce deu administrador {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF} Para {FFFFFF}{F0E68C}%s(%d){FFFFFF}{FFFFFF}.",adm,funcao,PlayerName(id),id);
			SCM(playerid,-1,str);
			format(str,sizeof(str),"{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu admin nivel {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF}.",PlayerName(playerid),playerid,adm,funcao);
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
	{
	    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
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
            SendClientMessageToAll(-1, "{9900FF}Five: {FFFFFF}Chat limpo!");
        }
    }
    return 1;
}
CMD:sethora(playerid,params[])
{
    new hora;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
	{
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
	    {
            if(sscanf(params,"d",hora)) return SCM(playerid,-1,"{9900FF}[Five] {FFFFFF}Use: /sethora [HORA].");
			SetWorldTime(hora);
        }
    }
    return 1;
}

CMD:setclima(playerid,params[])
{
    new clima;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
           	if(sscanf(params,"d",clima)) return SCM(playerid,-1,"{9900FF}[Five] {FFFFFF}Use: /setclima [CLIMA].");
 			SetWeather(clima);
        }
    }
    return 1;
}
CMD:car(playerid,params[])
{
    new Vehi[MAX_PLAYERS],CAR,C1,C2,Float:X,Float:Y,Float:Z,Float:R;
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            Gasolina[playerid] = 100;
			if(sscanf(params,"ddd",CAR,C1,C2)) return  SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /car [ID] [COR1] [COR2]");
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "dd",ID,SKIN)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setskin [ID] [SKIN]");
			{
                format(str,sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu skin {FFFFFF}%d{FFFFFF} Para {9900FF}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
				SCM(playerid, -1, str);
				format(str,sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu Skin {9900FF}%d{FFFFFF}.",PlayerName(playerid), playerid,SKIN);
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            DestroyVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:fix(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "s",TEXTO)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /aviso [TEXTO]");
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
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if(EstaTv[playerid] == 0)
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params,"i",id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use /tv [ID]");
    	    if(id == playerid) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Voce nao pode assistir!");
    	    if(!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
    	    SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Para parar de assistir use /tvoff.");
    		TogglePlayerSpectating(playerid, 1);
    		PlayerSpectatePlayer(playerid, id);
    		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
    	    EstaTv[playerid] = 1;
      }
  	  }else {
  		SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce ja esta tv em alguem, Use: /tvoff");
    }
    return 1;
}
CMD:tvoff(playerid,params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if(EstaTv[playerid] == 1){
    if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
 	{
		TogglePlayerSpectating(playerid, 0);
		PlayerSpectatePlayer(playerid, playerid);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(playerid));
	    EstaTv[playerid] = 0;
    }
    }else {
    	SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Voce nao esta tv em alguem.");
    }
   	return 1;
}
CMD:ir(playerid,params[])
{
    new id, Float:PedPos[3], string[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Use: /ir [ID].");
            if(!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            GetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "{9900FF}[Five] {FFFFFF}Voce foi ate o player {9900FF}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}
CMD:trazer(playerid,params[])
{
    new id, Float:PedPos[3], string[999];
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if(sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Use: /trazer [ID].");
            if(!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            GetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "{9900FF}[Five] {FFFFFF}O administrador trouxe o Player {9900FF}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}

CMD:setarma(playerid, params[])
{
    if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, arma, municao, string[100], str[100];
            if(sscanf(params, "iii", id, arma, municao)) return SendClientMessage(playerid, COR_AMARELO, "{9900FF}[Five] {FFFFFF}Use: /setarma [id] [arma] [municao]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce Setou a Arma: %d Com: %d de municao para o id: %d", arma, municao, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce Recebeu a Arma: %d Com: %d de Municao", arma, municao);
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
		format(string, sizeof(string), "{9900FF}[Five] {FFFFFF}Seja bem-Vindo(a) %s!", PlayerName(playerid));
		SendClientMessage(playerid, -1, string);

    //AddPlayerClass(285,3343.6267,-1718.2443,8.2578,264.5571,0,0,0,0,0,0); // lobbyTESTE 

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
	return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce precisa estar no lobby para usar esse comando!");
  ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "Escolha sua ORG/CORP","{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar"); 
  return true;
}



CMD:vt(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
		{
			ShowActionForPlayer(playerid, ActionTeste, "{9900FF}[Five] {FFFFFF}Voce realmente deseja spawnar uma Viatura neste local?", .action_time = 10000);
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
		SendClientMessage(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao quis spawnar um infernus.");
	}
}


//TELEPORTES
CMD:ls(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
			if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
      {
				SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LS.");
        SetPlayerPos(playerid, 1479.7734,-1706.5443,14.0469);
      }
    }
  return 1;
}
CMD:lv(playerid)
{
  if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
      SetPlayerPos(playerid,1569.0677,1397.1111,10.8460);
      SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LV.");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
		}
  }
	return 1;
}
CMD:sf(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
	{
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,-1988.3597,143.4470,27.5391);
      SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para SF.");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}


CMD:favela(playerid)
{
  if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,2530.9797,-939.0609,83.4220);
      SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Favela");
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}

CMD:dp(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
    {
			SetPlayerPos(playerid,1579.5828,-1607.0725,13.3828);
			SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Delegacia de LS.");
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
    }
  }
  return 1;
}

CMD:lobby(playerid)
{
	if(info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
  {
		if(Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
		{
			SetPlayerPos(playerid,3408.9929,-1684.4728,7.5313);
			SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para o Lobby!");
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
      ShowPlayerDialog(playerid, Garagem_Bandido, DIALOG_STYLE_LIST, "GARAGEM - VEICULOS", "{ff4848}Sultan\n{ff4848}Elegy\n{FF4848}Cheetah\n{FF4848}PCJ-600\n{FF4848}Burrito", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce não faz parte dos Bandidos!");	
		}
  }

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1588.4276,-1692.5383,6.2188))
	{
    if(Policial[playerid] == 1)
    {
      ShowPlayerDialog(playerid, Garagem_Policial, DIALOG_STYLE_LIST, "GARAGEM - VIATURAS", "{ff4848}Viatura LS\n{ff4848}Viatura SF\n{FF4848}Viatura LV\n{FF4848}Viatura FBI\n{FF4848}Blindado\nRocam\nHelicoptero", "Selecionar", "Fechar");
    }
		else{
			SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce não faz parte da Policia!");	
		}
  }
	return 1;
}


CMD:guardarv(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2534.2649,-911.4888,86.6154))
	{
		if(Bandido[playerid] == 1)
		{
			if(!IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce não está dentro de um veículo.");
				}
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
				new var0 = GetPlayerVehicleID(playerid);
				DestroyVehicle(var0);
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce não faz parte dos Bandidos!");	
		}
  }

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1585.6941,-1677.2054,5.8978))
	{
    if(Policial[playerid] == 1)
    {
      if(!IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce não está dentro de um veículo.");
				}
				SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
				new var0 = GetPlayerVehicleID(playerid);
				DestroyVehicle(var0);
    }
		else{
			SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce não faz parte da Policia!.");	
		}
  }
	return 1;
}


CMD:skins(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2547.4292,-926.9975,84.5811))
	{
		if(Bandido[playerid] == 1)
		{
      ShowPlayerDialog(playerid, Skins_Bandidos, DIALOG_STYLE_LIST, "Skins Bandidos", "{1E90FF}Skins Masculinas\n{FF69B4}Skins Femininas", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte dos Bandidos!");	
		}
  }
	
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 672.3721,2537.8672,-89.4512))
	{
		if(Policial[playerid] == 1)
		{
      ShowPlayerDialog(playerid, Skins_Policiais, DIALOG_STYLE_LIST, "Fardas Policiais", "Fardas Masculinas\n{FF4B4B}Fardas Femininas", "Selecionar", "Fechar");
    } else{
			SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!");	
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
