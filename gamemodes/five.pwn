//___________INCLUDES________________//
#include <a_samp>
#include <DOF2>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <float>
#include <foreach>
#include <discord-cmd>
#include <discord-connector>
// #include <td-actions>

//___________MYSQL________________//
#define HOST      "localhost"
#define USUARIO   "root"
#define DATABASE  "FIVE"
#define SENHA     "five2024"



//___________PRAGMAS________________//
// #pragma disablerecursion


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

//___________DEF'S_________//
#define LOGO_SERVER            "https://cdn.discordapp.com/attachments/990041379038179368/990042121161560104/IMG_20220620_001902.png?ex=65f4df93&is=65e26a93&hm=48dcf167c5e9fc53a1d9244496a94c842488e8ef2d17f1a6b5d3c069c39bf9fb&"
#define IMG_ONLINE_DS          "https://cdn.discordapp.com/attachments/844324415004606505/1213943358733680750/b.png?ex=65f74fda&is=65e4dada&hm=a47fa52952d3201fef95b954e208b0a4f3f1d7d6400120d842bb013a53a3b167&"
#define IP_SERVER              "🔎 **__IP__:** ```51.81.166.66:24459```"
#define NAME_SERVER            "Five Fugas 2024"

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
    Create3DTextLabel("{836FFF}Five Lobby\n{FFFFFF}Use {836FFF}/escolher {FFFFFF}Para Ser Policial ou Bandido", COR_AMARELO, 3406.7095, -1677.8269, 7.5313, 58.0685, 0, 0); //LOBBY
    Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /garagem", -1, 2536.6902, -920.2032, 86.6194, 30.0, 0, 0); //GARAGEM BANDIDOS
    CreatePickup(19134, 23, 2536.6902, -920.2032, 86.6194); //GARAGEM BANDIDOS

    Create3DTextLabel("{FFFFFF}Roupas\n{836FFF}Use: /skins", -1, 2547.4292, -926.9975, 84.5811, 30.0, 0, 0); //SKINS BANDIDOS
    CreatePickup(19132, 23, 2547.4292, -926.9975, 84.5811); //SKINS BANDIDOS

    Create3DTextLabel("{FFFFFF}Fardamento\n{836FFF}Use: /skins", -1, 1577.6028, 1606.5544, 1003.5000, 30.0, 0, 0); //SKINS POLICIA
    CreatePickup(19132, 23, 1577.6028, 1606.5544, 1003.5000); //SKINS POLICIA

    Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /garagem", -1, 1588.4276, -1692.5383, 6.2188, 30.0, 0, 0); //GARAGEM POLICIAIS
    CreatePickup(19134, 23, 1588.4276, -1692.5383, 6.2188); //GARAGEM POLICIAIS

    Create3DTextLabel("{FFFFFF}Garagem\n{836FFF}Use: /guardarv", -1, 1585.6941, -1677.2054, 5.8978, 30.0, 0, 0); //GARAGEM POLICIAIS
    CreatePickup(19134, 23, 1585.6941, -1677.2054, 5.8978); //GARAGEM POLICIAIS

    Create3DTextLabel("{FFFFFF}Garagem Helicoptero\n{836FFF}Use: /guardarv", -1, 1550.4474,-1609.7603,13.4933, 30.0, 0, 0); //GARAGEM HELI POLICIAIS
    CreatePickup(19134, 23, 1550.4474,-1609.7603,13.4933); //GARAGEM HELI POLICIAIS

    Create3DTextLabel("{FFFFFF}DELEGACIA\n{836FFF}Digite /entrar para entrar na DELEGACIA", 0xFFA500AA, 1555.5005, -1675.6212, 16.1953, 10.0, 0);
    AddStaticPickup(19133, 24, 1555.5005, -1675.6212, 16.1953); //ENTRAR DELEGACIA

    Create3DTextLabel("{FFFFFF}DELEGACIA\n{836FFF}Digite /sair ou aperte F Para sair da DELEGACIA", 0xFFA500AA, 1564.1604, 1597.5245, 1003.5000, 10.0, 0);
    AddStaticPickup(19133, 24, 1564.1604, 1597.5245, 1003.5000); // SAIR DELEGACIA

    Create3DTextLabel("{FFFFFF}MAGALU\n{836FFF}Digite /entrar para entrar na Magalu", 0xFFA500AA, 1128.4916, -1563.2698, 13.5489, 10.0, 0);
    AddStaticPickup(19133, 24, 1128.4916, -1563.2698, 13.5489); //ENTRAR MAGALU

    Create3DTextLabel("{FFFFFF}MAGALU\n{836FFF}Digite /sair ou aperte F Para sair da Magalu", 0xFFA500AA, 1127.9659, -1561.3444, -30.2015, 10.0, 0);
    AddStaticPickup(19133, 24, 1127.9659, -1561.3444, -30.2015); // SAIR MAGALU
    
    statuschannel = DCC_FindChannelById("1213156618829701200");
    // new DCC_Embed:embed = DCC_CreateEmbed("**Servidor Onlline**", "IP: 51.81.166.66:24459", "", "", 129310, "Five Fugas 2024", "https://cdn.discordapp.com/attachments/990041379038179368/990042121161560104/IMG_20220620_001902.png?ex=65f4df93&is=65e26a93&hm=48dcf167c5e9fc53a1d9244496a94c842488e8ef2d17f1a6b5d3c069c39bf9fb&", "https://cdn.discordapp.com/attachments/990041379038179368/990042121161560104/IMG_20220620_001902.png?ex=65f4df93&is=65e26a93&hm=48dcf167c5e9fc53a1d9244496a94c842488e8ef2d17f1a6b5d3c069c39bf9fb&", "https://cdn.discordapp.com/attachments/844324415004606505/1213943358733680750/b.png?ex=65f74fda&is=65e4dada&hm=a47fa52952d3201fef95b954e208b0a4f3f1d7d6400120d842bb013a53a3b167&");
    new DCC_Embed:embed = DCC_CreateEmbed("**Servidor Onlline**", IP_SERVER, "", "", 129310, NAME_SERVER, LOGO_SERVER, LOGO_SERVER, IMG_ONLINE_DS);
    DCC_SendChannelEmbedMessage(statuschannel, embed, "");



    // NEW MAP AGUA
    CreateObject(1337, 77.1, 102.7, 503, 0, 0, 0);
    CreateObject(4835, 1672.2002, -2981.3994, 5.1962, 0, 0, 0);
    CreateObject(6448, 1516.2002, -2926.5, 23.6333, 0, 0, 92);
    CreateObject(6449, 1295.5, -2880.7, 15, 0, 0, 92);
    CreateObject(6448, 1405.6, -2860.3999, 23.6, 0, 0, 272);
    CreateObject(6990, 1176.8, -2933.1001, 13.4, 0, 0, 182);
    CreateObject(7326, 1565.7002, -2982.5996, 1.3333, 0, 0, 90);
    CreateObject(8135, 1789.2, -3100.6001, 1, 0, 0, 180);
    CreateObject(3873, 1675.8, -2981.7, 18.6, 0, 0, 0);
    CreateObject(5426, 1851.2, -3114.8, 3.2, 0, 0, 0);
    CreateObject(6337, 1789.7, -2951.3999, 8.6, 0, 0, 149.996);
    CreateObject(1337, 74.5, 100.4, 504.79999, 0, 0, 0);
    CreateObject(1337, 74, 100, 505.20001, 0, 0, 0);
    CreateObject(12959, 1595.09998, -2955.80005, 1.3222, 0, 0, 0);
    CreateObject(13295, 1602.8, -3016.8, 7.8, 0, 0, 270);
    CreateObject(13725, 1563.0996, -2971.5996, 21.2, 0, 0, 83.996);
    CreateObject(16359, 1588.7, -2992.5, 1.3, 0, 0, 90);
    CreateObject(8409, 1763.4004, -3044.0996, 3.8, 0, 0, 0);
    CreateObject(12924, 1744.7002, -3006.0996, 1.333, 0, 0, 270);
    CreateObject(1423, 1800.8, -3060.8999, 1.8, 0, 0, 332);
    CreateObject(3941, 1620.1, -3017.6001, 4.4, 0, 0, 180);
    CreateObject(16359, 1607.2, -2992.6001, 1.3, 0, 0, 90);
    CreateObject(3174, 1611.9, -3014.3999, 1.3, 0, 0, 88);
    CreateObject(3315, 1708.2998, -2896.2002, 2, 0, 0, 270);
    CreateObject(792, 1689, -3035.3999, 1.3, 0, 0, 0);
    CreateObject(715, 1706.5, -3004.5, 9.4, 0, 0, 0);
    CreateObject(715, 1655.3, -3004.3, 9.4, 0, 0, 0);
    CreateObject(715, 1653.2002, -2958.0996, 9.4, 0, 0, 0);
    CreateObject(715, 1702.4, -2955, 9.4, 0, 0, 0);
    CreateObject(1454, 1616.1, -3001.8999, 2.1, 0, 0, 0);
    CreateObject(1454, 1616.1, -2998.6001, 2.1, 0, 0, 0);
    CreateObject(9361, 1807.7002, -3062.2002, 3.6, 0, 0, 227.995);
    CreateObject(4113, 1709.4004, -3050.8994, -35, 0, 0, 11.997);
    CreateObject(4113, 1725.7, -3019.6001, -35, 0, 0, 11.997);
    CreateObject(16310, 1619.3, -2994.8, 2.4, 0, 0, 0);
    CreateObject(1684, 1718.4, -3033.1001, 2.6, 0, 0, 4);
    CreateObject(1684, 1708.0996, -3035.2998, 2.6, 0, 0, 24);
    CreateObject(3504, 1712.6, -3031.8999, 2.4, 0, 0, 0);
    CreateObject(4113, 1760.6, -3008, -35, 0, 0, 277.997);
    CreateObject(4113, 1790.7, -3011.3999, -35, 0, 0, 281.992);
    CreateObject(922, 1776.2, -3023.5, 1.9, 0, 0, 0);
    CreateObject(922, 1776.4, -3022.3, 1.9, 0, 0, 0);
    CreateObject(922, 1776.8, -3020.8999, 1.9, 0, 0, 0);
    CreateObject(922, 1777.3, -3019.2, 1.9, 0, 0, 0);
    CreateObject(922, 1777.7, -3017.8, 1.9, 0, 0, 0);
    CreateObject(922, 1778.2, -3016.1001, 1.9, 0, 0, 0);
    CreateObject(922, 1778.2002, -3016.0996, 1.9, 0, 0, 0);
    CreateObject(922, 1778.7, -3014.3, 1.9, 0, 0, 0);
    CreateObject(922, 1778.5, -3012.6001, 1.9, 0, 0, 0);
    CreateObject(922, 1778.3, -3010.6001, 1.9, 0, 0, 0);
    CreateObject(922, 1778.1, -3008.8999, 1.9, 0, 0, 0);
    CreateObject(922, 1778.0996, -3008.8994, 1.9, 0, 0, 0);
    CreateObject(4113, 1651.6, -3060.3, -35, 0, 0, 5.992);
    CreateObject(1337, 140.8, 157.89999, 458.39999, 0, 0, 0);
    CreateObject(11008, 1653.0996, -3051.7002, 7.6, 0, 0, 90);
    CreateObject(4113, 1656.1, -3028.5, -35, 0, 0, 11.988);
    CreateObject(4113, 1610.5, -3058.3, -35, 0, 0, 9.988);
    CreateObject(4113, 1614.3, -3024.8, -35, 0, 0, 13.987);
    CreateObject(11244, 1626.8, -3030.8999, 4.1, 0, 0, 0);
    CreateObject(4113, 1614.4, -2993.5, -35, 0, 0, 13.986);
    CreateObject(11010, 1618.40002, -2956.30005, 6.4, 0, 0, 270);
    CreateObject(4113, 1626.8, -2954.2, -35, 0, 0, 19.986);
    CreateObject(4113, 1581.2002, -2954.8994, -35, 0, 0, 17.979);
    CreateObject(1439, 1600, -2938.2, 1, 0, 0, 0);
    CreateObject(1439, 1600.1, -2936.7, 1, 0, 0, 0);
    CreateObject(1439, 1599.9, -2939.2, 1, 0, 0, 0);
    CreateObject(1439, 1599.8, -2940.2, 1, 0, 0, 0);
    CreateObject(1439, 1599.7, -2941.2, 1, 0, 0, 0);
    CreateObject(1439, 1599.6, -2942.3999, 1, 0, 0, 0);
    CreateObject(1439, 1599.8, -2943.3999, 1, 0, 0, 0);
    CreateObject(1439, 1599.7, -2944.1001, 1, 0, 0, 0);
    CreateObject(1439, 1599.6, -2945.3, 1, 0, 0, 0);
    CreateObject(1439, 1599.5, -2946.5, 1, 0, 0, 0);
    CreateObject(1439, 1599.5, -2946.5, 1, 0, 0, 0);
    CreateObject(4113, 1706.1, -2925.7, -35, 0, 0, 9.986);
    CreateObject(4113, 1738.9, -2963.3999, -35, 0, 0, 93.986);
    CreateObject(4113, 1742, -2923.1001, -35, 0, 0, 89.986);
    CreateObject(4113, 1705.5, -2896.1001, -35, 0, 0, 15.981);
    CreateObject(5711, 1724.7, -2919.2, 5, 0, 0, 354);
    CreateObject(1684, 1695, -2909.7, 2.6, 0, 0, 0);
    CreateObject(1684, 1705.3, -2909.3999, 2.6, 0, 0, 0);
    CreateObject(1684, 1715.59998, -2909.1001, 2.6, 0, 0, 0);
    CreateObject(18236, 1746, -2943.7, 1, 0, 0, 262);
    CreateObject(18236, 1727.7, -2941.1223, 1, 0, 0, 261.996);
    CreateObject(1408, 1724.1, -2945.6001, 1.9, 0, 0, 0);
    CreateObject(1408, 1719.6, -2943.6001, 1.9, 0, 0, 312);
    CreateObject(1408, 1718, -2939, 1.9, 0, 0, 265.995);
    CreateObject(4113, 1770.6, -2932.3, -35, 0, 0, 85.984);
    CreateObject(10985, 1752.3, -2932.7, 2, 0, 0, 186);
    CreateObject(10985, 1757.5, -2915.7, 2, 0, 0, 360);
    CreateObject(1337, 153.60001, 159.39999, 516.5, 0, 0, 0);
    CreateObject(838, 1708.8, -2978, 4, 0, 0, 118);
    CreateObject(846, 1705.7, -2972.3, 1.8, 0, 0, 0);
    CreateObject(4113, 1664.1, -2911.5, -35, 0, 0, 107.981);
    CreateObject(4113, 1634.8, -2915.8, -35, 0, 0, 109.979);
    CreateObject(1337, 76.2, 101.6, 504.10001, 0, 0, 0);
    CreateObject(4113, 1819.9, -3048, -35, 0, 0, 187.992);
    CreateObject(4113, 1860.1, -3049.8, -35, 0, 0, 191.987);
    CreateObject(1607, 1527.7, -2999.3, 1, 40, 0, 26);
    CreateObject(1607, 1522.4, -2986.8, 1, 39.996, 0, 207.999);
    CreateObject(11495, 1553.40002, -2950.6001, 2.2, 0, 0, 110);
    CreateObject(11495, 1535.3, -2961.1001, 2.2, 0, 0, 129.995);
    CreateObject(13065, 1523.0166, -3052.02051, -33.50474, 0, 0, 0);
    CreateObject(1257, 1666.9, -2876, 2.3, 0, 0, 90);
    CreateObject(2661, 1705.6, -2911.5, 2.4, 0, 0, 0);
    CreateObject(3521, 1709.9, -2984.5, 2.8, 0, 0, 276);
    CreateObject(2745, 1714.1, -2983.3, 2.5, 0, 0, 54);
    CreateObject(1233, 1718.1, -2967, 2.8, 0, 0, 0);
    CreateObject(939, 1734.5, -2948, 3.5, 0, 0, 0);
    CreateObject(939, 1740.9, -2949.1001, 3.5, 0, 0, 0);
    CreateObject(3335, 1885.3, -2973.3999, 1.5, 0, 0, 56);
    CreateObject(1315, 1883.4, -2986.2, 4.7, 0, 0, 276);
    CreateObject(1413, 1876.4, -3083.2, 2.3, 0, 0, 0);
    CreateObject(1413, 1871.1, -3083, 2.3, 0, 0, 0);
    CreateObject(1413, 1865.7, -3082.8999, 2.3, 0, 0, 0);
    CreateObject(1413, 1860.4, -3082.5, 2.6, 0, 0, 0);
    CreateObject(1413, 1855, -3082.3, 2.6, 0, 0, 0);
    CreateObject(1413, 1849.6, -3082.3999, 2.6, 0, 0, 0);
    CreateObject(1413, 1845.3, -3082.7, 2.7, 0, 0, 0);
    CreateObject(7093, 1517.4, -2995.1001, 7, 0, 0, 100);
    CreateObject(1245, 1565.3, -2944.8, 1, 0, 0, 20);
    CreateObject(3816, 1674.9, -3110.5, 9.6777, 0, 0, 180);
    CreateObject(2942, 1811.3, -3064.8999, 1.7, 0, 0, 0);
    CreateObject(1594, 1815.5, -3065.1001, 1.5, 0, 0, 0);
    CreateObject(3620, 1810.7, -3003.3, 14.1, 0, 0, 86);
    CreateObject(3637, 1827.6, -3047.8, 9.1, 0, 0, 0);
    CreateObject(3643, 1839.2, -3047.8999, 6.9, 0, 0, 0);
    CreateObject(6934, 1810, -3045.7, 53.1, 0, 0, 0);
    CreateObject(3585, 1572.4, -3073.3, 10.9, 0, 0, 274);
    CreateObject(3585, 1209.3, -2902.2, 14.9, 0, 0, 310);
    CreateObject(1337, 1609.5, -2897, 0, 0, 0, 0);
    CreateObject(11244, 1636.6, -2911.1001, 4.1, 0, 0, 92);
    CreateObject(17040, 1660.3, -2907.8999, 1, 0, 0, 2);
    CreateObject(11495, 1554.4, -2992.8, 1.2, 0, 0, 73.99);
    CreateObject(11495, 1537, -2981.5, 1.2, 0, 0, 39.987);
    CreateObject(11495, 1530.1, -2962.7, 1.2, 0, 0, 359.985);
    CreateObject(870, 1525.9, -2991.5, 0, 0, 0, 0);
    CreateObject(870, 1525.2, -2995.3999, 0, 0, 0, 0);
    CreateObject(870, 1518.8, -2998.3, 0, 0, 0, 0);
    CreateObject(870, 1517.4, -2990.7, 0, 0, 0, 0);
    CreateObject(870, 1530.1, -2993.3999, 0, 0, 0, 0);
    CreateObject(870, 1529.5, -2997.8999, 0, 0, 0, 0);
    CreateObject(870, 1528.1, -2987.7, 0, 0, 0, 0);
    CreateObject(822, 1558.5, -2969.3, 3, 0, 0, 0);
    CreateObject(822, 1561.6, -2978, 3, 0, 0, 0);
    CreateObject(822, 1567.9, -2972.2, 3, 0, 0, 0);
    CreateObject(6232, 1904.5, -2940.8999, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.9, -2919.8999, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.3, -2898.8999, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.1, -2877.3, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.1, -2856.5, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.2, -2835.5, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.2, -2814.7, 9.7, 0, 0, 0);
    CreateObject(6232, 1901.4, -2793.8, 9.7, 0, 0, 0);
    CreateObject(3578, 1912.4, -2769.6001, 2, 0, 0, 292);
    CreateObject(3578, 1908.8, -2760.1001, 2, 0, 0, 291.995);
    CreateObject(3578, 1889.1, -2768, 2, 0, 0, 267.995);
    CreateObject(3578, 1889.4, -2757.6001, 2, 0, 0, 267.99);
    CreateObject(7605, 1910.9, -2982.3, 1.4, 0, 0, 178);
    CreateObject(8135, 1903.7, -3046.2, 1.3, 0, 0, 0);
    CreateObject(2623, 1808.5, -3059.69995, 2.8, 0, 0, 4);
    CreateObject(3502, 1804.6, -3069.8999, -0.2, 0, 0, 180);
    CreateObject(3502, 1804.6, -3078.8999, -0.2, 0, 0, 0);
    CreateObject(6877, 1830, -2981.6001, 1.4, 0, 0, 0);
    CreateObject(16409, 1815.9, -3115.2, 0.9, 0, 0, 180);
    CreateObject(738, 1909.8, -2993.5, 1.5, 0, 0, 0);
    CreateObject(738, 1911.6, -2968.3, 1.5, 0, 0, 0);
    CreateObject(16061, 1836.2, -2988.8999, 3.6, 358.5, 0, 270);
    CreateObject(16061, 1835, -2973.7, 3.6, 358.495, 0, 270);
    CreateObject(9254, 2020.4, -3070.7, 1.7777, 0, 0, 90);
    CreateObject(3850, 2042.1, -3074.1001, 4.6, 0, 0, 0);
    CreateObject(1337, 76.9, 102.5, 503, 0, 0, 0);
    CreateObject(2991, 1649.4, -2924.2, 1.7, 0, 0, 278);
    CreateObject(2991, 1649.4, -2921.1001, 1.7, 0, 0, 357.996);
    CreateObject(2991, 1650.1, -2928.2, 1.7, 0, 0, 285.996);
    CreateObject(3566, 1635.4, -2936.5, 3.6, 0, 0, 274);
    CreateObject(18370, 1901.6, -2866.7, 14, 0, 0, 270);
    CreateObject(17927, 1891.9, -2904.5, 2.77, 0, 0, 272);
    CreateObject(1337, 91.3, 112.7, 502.10001, 0, 0, 0);
    CreateObject(17927, 1888.9, -2815.8999, 2.8, 0, 0, 272);
    CreateObject(17927, 1907.3, -2722.3, 2.8, 0, 0, 92);
    CreateObject(17936, 2057, -3068, 25, 0, 0, 90);
    CreateObject(4601, 2037, -3101.2, -100, 0, 0, 270);
    CreateObject(4601, 2037, -3123.8, -100, 0, 0, 270);
    CreateObject(4601, 2037, -3146.3999, -100, 0, 0, 270);
    CreateObject(11483, 2038.9, -3069.2, 10, 0, 0, 234);
    CreateObject(1337, 139.89999, 158.89999, 458.39999, 0, 0, 0);
    CreateObject(7191, 2025.6, -3098.3999, 3.2, 0, 0, 90);
    CreateObject(7191, 2025.8, -3043.2, 3.2, 0, 0, 90);
    CreateObject(8041, 2004.6, -3073.5, 7, 0, 0, 180);
    CreateObject(3715, 1912.1, -3013.3, 10.7, 0, 0, 0);
    CreateObject(9241, 2132.5, -3069.8999, 12, 0, 0, 270);
    CreateObject(4601, 2077, -3123.7, -100, 0, 0, 270);
    CreateObject(17936, 2079.8999, -3068.8, 25, 0, 0, 2);
    CreateObject(3813, 2057, -3098.7, 11.1, 0, 0, 92);
    CreateObject(18275, 2075, -3069.8999, 12.5, 0, 0, 88);
    CreateObject(3921, 2085.1001, -3060.5, 10.8, 0, 0, 92);
    CreateObject(2572, 2089.5, -3061, 10.3, 0, 0, 0);
    CreateObject(1980, 2058.8999, -3103.3999, 11.9, 0, 0, 270);
    CreateObject(1980, 2059.5, -3036.2, 11.9, 0, 0, 270);
    CreateObject(18275, 2042.7, -3069.6001, 12.5, 0, 0, 89.995);
    CreateObject(8390, 1759.3, -3152.3999, 20.4, 0, 0, 180);
    CreateObject(1808, 2012.9, -3044.3, 1.4, 0, 0, 0);
    CreateObject(910, 2016.3, -3044.2, 2.7, 0, 0, 0);
    CreateObject(2690, 2060.1001, -3101.8, 10.6, 0, 0, 0);
    CreateObject(2176, 2061.6001, -3066.6001, 13.1, 0, 0, 0);
    CreateObject(2176, 2061.7, -3073.3, 13.1, 0, 0, 0);
    CreateObject(2071, 2043.4, -3049.5, 11.8, 0, 0, 328);
    CreateObject(1974, 2047.8, -3039.8999, 10.3, 0, 0, 0);
    CreateObject(2071, 2042.1, -3090.7, 11.8, 0, 0, 220);
    CreateObject(14439, 2066.3, -3057.8999, 25.7, 0, 0, 0);
    CreateObject(14439, 2067.8999, -3079.3, 25.7, 0, 0, 0);
    CreateObject(2179, 2041.6, -3086.5, 12, 0, 0, 0);
    CreateObject(2179, 2041.4, -3054.8, 12, 0, 0, 0);
    CreateObject(1980, 2098.1001, -3058.6001, 11.9, 0, 0, 270);
    CreateObject(1980, 2097.8999, -3082, 11.9, 0, 0, 270);
    CreateObject(1238, 1981.7, -3065.3, 1.7, 0, 0, 0);
    CreateObject(1238, 1979.4, -3067.6001, 1.7, 0, 0, 0);
    CreateObject(1238, 1966, -3064.7, 1.7, 0, 0, 0);
    CreateObject(1238, 1967.4, -3067.2, 1.7, 0, 0, 0);
    CreateObject(1226, 1898.9, -2980.8, 5.4, 0, 0, 0);
    CreateObject(1226, 1898.7, -2989.8, 5.4, 0, 0, 0);
    CreateObject(1226, 1921.5, -2988.3, 5.4, 0, 0, 178);
    CreateObject(1226, 1922.1, -2975.3, 5.4, 0, 0, 177.995);
    CreateObject(1226, 1910.1, -2962.1001, 5.4, 0, 0, 275.995);
    CreateObject(1226, 1909.6, -3001.3, 5.4, 0, 0, 83.993);
    CreateObject(1231, 1933, -3024.7, 4.1, 0, 0, 0);
    CreateObject(1231, 1954.7, -3031.1001, 4.1, 0, 0, 0);
    CreateObject(1231, 1905.7, -3042.7, 4.1, 0, 0, 0);
    CreateObject(1231, 1928.3, -3065.2, 4.1, 0, 0, 0);
    CreateObject(1440, 1844.3, -3145.8, 1.5, 0, 0, 0);
    CreateObject(1440, 1847.1, -3146, 1.5, 0, 0, 0);
    CreateObject(1440, 1850, -3146, 1.5, 0, 0, 0);
    CreateObject(1440, 1852.6, -3146, 1.5, 0, 0, 0);
    CreateObject(1440, 1823.4, -3144, 2.9, 0, 0, 0);
    CreateObject(1440, 1826.3, -3144, 2.9, 0, 0, 0);
    CreateObject(714, 1707.8, -3052, 0.4, 0, 0, 95.438);
    CreateObject(1408, 1894.8, -2942, 2.3, 0, 0, 92);
    CreateObject(1408, 1886.4, -2967, 2.1, 0, 0, 66);
    CreateObject(1408, 1895, -2947.5, 2.3, 0, 0, 92);
    CreateObject(1408, 1894, -2952.5996, 2.1, 0, 0, 65.995);
    CreateObject(1408, 1891.2998, -2957.2998, 2.1, 0, 0, 53.998);
    CreateObject(1408, 1888.5996, -2962, 2.1, 0, 0, 65.995);
    CreateObject(1408, 1880.2, -2974.5, 2.4, 0, 0, 353.995);
    CreateObject(1408, 1884.0996, -2972.0996, 2.2, 0, 0, 65.995);
    CreateObject(1408, 1869.4, -2972.5, 3.2, 0, 0, 339.99);
    CreateObject(1408, 1874.7, -2973.8, 2.8, 0, 0, 351.987);
    CreateObject(1408, 1886.7, -2999.3, 2.1, 0, 0, 281.995);
    CreateObject(1408, 1882.6, -2990.2, 2.3, 0, 0, 339.992);
    CreateObject(1408, 1877.2, -2989, 2.6, 0, 0, 357.988);
    CreateObject(1408, 1872.1, -2990.1001, 3, 0, 0, 29.984);
    CreateObject(1408, 1885.5996, -2994, 2.1, 0, 0, 281.992);
    CreateObject(1408, 1888.7, -3004.2, 2.1, 0, 0, 301.992);
    CreateObject(1408, 1892, -3008.3999, 2.1, 0, 0, 313.987);
    CreateObject(1408, 1901, -3015, 2.1, 0, 0, 327.984);
    CreateObject(1408, 1916.6, -2949, 2.1, 0, 0, 333.998);
    CreateObject(1408, 1921.4, -2951.3999, 2.1, 0, 0, 333.995);
    CreateObject(1408, 1926.2, -2953.8, 2.1, 0, 0, 333.995);
    CreateObject(1408, 1930.3, -2957.1001, 2.1, 0, 0, 307.995);
    CreateObject(1408, 1936.7, -2977.2, 2.1, 0, 0, 271.991);
    CreateObject(1408, 1933.0996, -2961.7002, 2.1, 0, 0, 293.989);
    CreateObject(1408, 1935.2998, -2966.5996, 2.1, 0, 0, 293.989);
    CreateObject(1408, 1936.5, -2971.7998, 2.1, 0, 0, 271.989);
    CreateObject(1408, 1936.9, -2982.6001, 2.1, 0, 0, 271.989);
    CreateObject(1408, 1936.4, -2993.3999, 2.1, 0, 0, 265.989);
    CreateObject(1408, 1936.7998, -2988, 2.1, 0, 0, 265.985);
    CreateObject(1408, 1935, -2998.5, 2.1, 0, 0, 243.985);
    CreateObject(1408, 1930.2, -3008.3, 2.1, 0, 0, 243.984);
    CreateObject(1408, 1932.5996, -3003.3994, 2.1, 0, 0, 243.984);
    CreateObject(1408, 1926.5, -3011.7, 2.1, 0, 0, 201.984);
    CreateObject(1408, 1922.3, -3014.8, 2.1, 0, 0, 231.984);
    CreateObject(1408, 1923.1, -3016.2, 1.8, 0, 0, 199.982);
    CreateObject(1408, 1948.8, -3011.8999, 1.9, 0, 0, 159.979);
    CreateObject(1408, 1928.0996, -3014.5, 1.9, 0, 0, 199.979);
    CreateObject(1408, 1933.2998, -3012.5996, 1.9, 0, 0, 199.979);
    CreateObject(1408, 1938.4004, -3011.5, 1.9, 0, 0, 183.977);
    CreateObject(1408, 1943.5996, -3011.2002, 1.9, 0, 0, 183.977);
    CreateObject(1408, 1963.2, -3018.8999, 1.9, 0, 0, 147.977);
    CreateObject(1408, 1953.7998, -3013.7002, 1.9, 0, 0, 159.977);
    CreateObject(1408, 1958.5996, -3016, 1.9, 0, 0, 147.975);
    CreateObject(1408, 1970.7, -3026.3, 1.9, 0, 0, 125.975);
    CreateObject(1408, 1967.2998, -3022.2002, 1.9, 0, 0, 133.973);
    CreateObject(1408, 1976.2, -3035.3999, 1.9, 0, 0, 119.975);
    CreateObject(1408, 1973.5996, -3030.7998, 1.9, 0, 0, 119.971);
    CreateObject(1408, 1978.4, -3040.2, 1.9, 0, 0, 109.971);
    CreateObject(1408, 1979.7, -3045.3999, 1.9, 0, 0, 97.968);
    CreateObject(1408, 1980.4, -3050.7, 1.9, 0, 0, 97.965);
    CreateObject(1408, 1981.1, -3055.8999, 1.9, 0, 0, 97.965);
    CreateObject(1408, 1981.8, -3061.1001, 1.9, 0, 0, 97.965);
    CreateObject(1408, 1984.8, -3064.3, 1.9, 0, 0, 169.965);
    CreateObject(1408, 1995.5, -3065.3999, 1.9, 0, 0, 185.964);
    CreateObject(1408, 1990.0996, -3065.2002, 1.9, 0, 0, 169.964);
    CreateObject(1408, 2000.8, -3064.6001, 1.9, 0, 0, 191.96);
    CreateObject(1408, 1896.0996, -3011.7998, 2.1, 0, 0, 327.98);
    CreateObject(1408, 1905.6, -3018, 2.1, 0, 0, 327.98);
    CreateObject(1408, 1889.7, -3042.2, 1.9, 0, 0, 75.98);
    CreateObject(1408, 1905.9004, -3021.0996, 1.9, 0, 0, 39.979);
    CreateObject(1408, 1902, -3024.8994, 1.9, 0, 0, 47.977);
    CreateObject(1408, 1898.4004, -3028.8994, 1.9, 0, 0, 47.977);
    CreateObject(1408, 1895, -3033.0996, 1.9, 0, 0, 53.976);
    CreateObject(1408, 1891.9004, -3037.3994, 1.9, 0, 0, 53.976);
    CreateObject(1408, 1888.4, -3047.3999, 1.9, 0, 0, 75.976);
    CreateObject(1408, 1887.2, -3052.5, 1.9, 0, 0, 75.976);
    CreateObject(1408, 1885.7, -3062.8999, 1.9, 0, 0, 67.976);
    CreateObject(1408, 1886.5996, -3057.7002, 1.9, 0, 0, 91.972);
    CreateObject(1408, 1882, -3065.3999, 1.9, 0, 0, 359.972);
    CreateObject(1684, 1696.8, -3038.8999, 2.6, 0, 0, 6);
    CreateObject(11480, 1742.1, -2958.8999, 3.2, 0, 0, 0);
    CreateObject(16096, 1906.5, -3060.8999, 3.2, 0, 0, 88);
    CreateObject(16096, 1912.3, -3061, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1918.3, -3061.3, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1924.3, -3061.3999, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1930.3, -3061.5, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1936.1, -3061.6001, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1942.1, -3061.7, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1948.1, -3062, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1953.9, -3062.1001, 3.2, 0, 0, 87.995);
    CreateObject(16096, 1959.9, -3062.3999, 3.2, 0, 0, 87.995);
    CreateObject(16359, 1960.7, -3050.2, 1.3, 0, 0, 196);
    CreateObject(16359, 1951, -3034.6001, 1.3, 0, 0, 227.996);
    CreateObject(16359, 1933.9, -3029.2, 1.3, 0, 0, 273.994);
    CreateObject(16359, 1917, -3035.5, 1.3, 0, 0, 309.994);
    CreateObject(16359, 1906.9, -3050.3, 1.3, 0, 0, 341.99);
    CreateObject(2974, 1963.8, -3059.8999, 1.3, 0, 0, 0);
    CreateObject(2974, 1963.7998, -3062.5, 1.3, 0, 0, 0);
    CreateObject(2974, 1958.8, -3040.5, 1.3, 0, 0, 302);
    CreateObject(2974, 1943.8, -3027.8, 1.3, 0, 0, 347.998);
    CreateObject(2974, 1923.5, -3028.6001, 1.3, 0, 0, 9.997);
    CreateObject(2974, 1909.1, -3040.8, 1.3, 0, 0, 65.992);
    CreateObject(2974, 1902.7, -3060.5, 1.3, 0, 0, 357.989);


    // MAPA CACHOEIRA LOGIN
    CreateDynamicObject(11423, 2877.86450, -352.23792, 11.10370, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18789, 2922.27100, -352.26639, 6.58340, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18789, 3072.18140, -352.26511, 6.58340, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11423, 2939.48633, -352.23792, 11.10370, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11423, 3001.12573, -352.23792, 11.10370, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11423, 3062.72852, -352.23792, 11.10370, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11423, 3124.36768, -352.23792, 11.10370, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11695, 3195.10718, -325.44171, -25.89870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11695, 3233.75317, -504.85562, -25.93870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11696, 3361.40308, -457.06796, 39.11480, 0.00000, 0.00000, 174.57069);
    CreateDynamicObject(18228, 3232.02856, -505.33881, -5.21306, 0.00000, 0.00000, 234.34300);
    CreateDynamicObject(18228, 3231.44653, -512.11053, -5.21306, 0.00000, 0.00000, 234.34300);
    CreateDynamicObject(18228, 3229.55347, -541.47046, -5.21306, 0.00000, 0.00000, 234.28300);
    CreateDynamicObject(18228, 3227.22876, -554.62494, -5.21306, 0.00000, 0.00000, 234.28300);
    CreateDynamicObject(18228, 3234.88184, -447.09824, -5.21306, 0.00000, 0.00000, 234.34300);
    CreateDynamicObject(18228, 3232.02856, -505.33881, -5.21306, 0.00000, 0.00000, 234.34300);
    CreateDynamicObject(18228, 3241.82739, -377.81235, -5.21306, 0.00000, 0.00000, 235.12300);
    CreateDynamicObject(18228, 3418.21436, -287.43201, 1.84610, 0.00000, 0.00000, 200.00000);
    CreateDynamicObject(19842, 3234.14233, -414.95490, 3.90700, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(19842, 3209.18628, -413.72681, 3.90700, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(19842, 3184.24487, -413.57919, 3.90700, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(19842, 3159.03857, -422.52859, 3.90700, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(19841, 3263.57959, -409.98596, 66.49767, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(19841, 3141.32520, -426.94052, -4.02105, -40.00000, 0.00000, 291.59311);
    CreateDynamicObject(3929, 3237.91382, -413.66299, 4.03330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3929, 3238.22681, -416.75909, 4.03330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3929, 3220.77197, -414.19626, 3.62726, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3233.33765, -418.05679, 4.54110, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3232.91162, -415.73819, 4.03330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3220.91089, -418.29333, 3.31195, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3218.99268, -416.79166, 3.92590, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3194.44727, -414.05981, 3.52320, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3197.68066, -416.93280, 4.03099, 0.00000, 0.00000, 358.73172);
    CreateDynamicObject(3929, 3197.29810, -414.36740, 4.03330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(837, 3196.42749, -414.07935, 4.40446, 0.00000, 0.00000, 93.63893);
    CreateDynamicObject(837, 3195.84839, -416.57449, 4.40446, 0.00000, 0.00000, 93.63893);
    CreateDynamicObject(868, 3148.28564, -421.54376, 4.54110, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(868, 3149.15845, -426.35751, 4.03330, 0.00000, 0.00000, -0.12000);
    CreateDynamicObject(837, 3221.64648, -416.46393, 4.40446, 0.00000, 0.00000, 93.63893);
    CreateDynamicObject(837, 3234.78076, -416.24808, 4.40446, 0.00000, 0.00000, 93.63893);
    CreateDynamicObject(868, 3149.39600, -424.15997, 4.54110, 0.00000, 0.00000, 0.12000);
    CreateDynamicObject(837, 3171.43359, -417.34821, 3.99842, 0.00000, 0.00000, 93.63893);
    CreateDynamicObject(837, 3148.61401, -424.46579, 4.83765, 0.00000, 0.00000, 94.31282);
    CreateDynamicObject(837, 3146.77710, -423.37057, 4.84198, 0.00000, 0.00000, 114.34173);
    CreateDynamicObject(880, 3130.17969, -429.08533, -0.30418, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(880, 3132.71851, -434.93927, -0.30418, 0.00000, 0.00000, -2.46000);
    CreateDynamicObject(880, 3134.18506, -431.75296, -0.30418, 0.00000, 0.00000, 58.68924);
    CreateDynamicObject(880, 3127.91968, -433.67618, -0.30418, 0.00000, 0.00000, 59.36061);
    CreateDynamicObject(3578, 3174.83276, -407.53311, 6.08130, 0.00000, 0.00000, 95.99560);
    CreateDynamicObject(3578, 3176.66772, -417.53561, 6.08130, 0.00000, 0.00000, 105.57220);
    CreateDynamicObject(3578, 3179.97510, -427.11679, 6.08130, 0.00000, 0.00000, 113.55930);
    CreateDynamicObject(3578, 3157.36890, -418.54059, 6.09920, 0.00000, 0.00000, 100.97830);
    CreateDynamicObject(3578, 3160.03076, -428.10779, 6.09920, 0.00000, 0.00000, 110.07200);
    CreateDynamicObject(970, 3159.38110, -427.70120, 7.45546, 0.00000, 0.00000, 290.92392);
    CreateDynamicObject(970, 3158.18726, -423.78763, 7.45546, 0.00000, 0.00000, 283.05865);
    CreateDynamicObject(970, 3157.25854, -419.75757, 7.45546, 0.00000, 0.00000, 282.69235);
    CreateDynamicObject(970, 3156.37573, -415.70981, 7.45546, 0.00000, 0.00000, 281.82251);
    CreateDynamicObject(970, 3155.82324, -411.61801, 7.45546, 0.00000, 0.00000, 273.63379);
    CreateDynamicObject(970, 3175.54150, -409.12589, 7.45546, 0.00000, 0.00000, 274.56128);
    CreateDynamicObject(970, 3176.14600, -413.19623, 7.45550, 0.00000, 0.00000, 282.36734);
    CreateDynamicObject(970, 3177.04834, -417.21655, 7.45546, 0.00000, 0.00000, 282.67487);
    CreateDynamicObject(970, 3178.21313, -421.16461, 7.45546, 0.00000, 0.00000, 290.37155);
    CreateDynamicObject(970, 3179.68213, -425.00760, 7.45546, 0.00000, 0.00000, 291.57303);
    CreateDynamicObject(868, 3235.25732, -414.63257, 3.41810, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(868, 3223.71118, -417.43011, 3.62519, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(868, 3227.36108, -415.61374, 3.41810, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(868, 3212.70776, -418.58524, 3.41810, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(868, 3213.57666, -414.71243, 3.51947, 0.00000, 0.00000, 77.58000);
    CreateDynamicObject(868, 3204.66040, -413.95712, 3.62653, 0.00000, 0.00000, 77.58000);
    CreateDynamicObject(868, 3206.06055, -417.78821, 3.82414, 0.00000, 0.00000, 137.60944);
    CreateDynamicObject(868, 3186.07568, -417.15381, 4.24382, 0.00000, 0.00000, 77.58000);
    CreateDynamicObject(868, 3178.52295, -417.84766, 4.59260, 0.00000, 0.00000, 142.95700);
    CreateDynamicObject(868, 3176.51270, -419.15201, 4.64777, 0.00000, 0.00000, 143.01704);
    CreateDynamicObject(868, 3176.18262, -415.09039, 4.64777, 0.00000, 0.00000, 142.95705);
    CreateDynamicObject(868, 3177.50708, -416.67059, 4.64777, 0.00000, 0.00000, 143.49702);
    CreateDynamicObject(868, 3156.79102, -422.52872, 4.64777, 0.00000, 0.00000, 142.95705);
    CreateDynamicObject(868, 3156.22607, -420.23853, 4.64777, 0.00000, 0.00000, 144.15706);
    CreateDynamicObject(868, 3156.79102, -422.52872, 4.64777, 0.00000, 0.00000, 142.95705);
    CreateDynamicObject(868, 3156.20581, -417.81717, 4.64777, 0.00000, 0.00000, 144.75706);
    CreateDynamicObject(979, 3228.85547, -477.17950, 7.66510, 0.00000, 0.00000, 357.88190);
    CreateDynamicObject(979, 3208.17554, -472.51108, 7.66510, 0.00000, 0.00000, 338.51959);
    CreateDynamicObject(979, 3243.28638, -475.90176, 7.66510, 0.00000, 0.00000, 2.00000);
    CreateDynamicObject(979, 3259.34546, -475.18393, 7.66510, 0.00000, 0.00000, 2.74258);
    CreateDynamicObject(978, 3221.39844, -465.25690, 7.66510, 0.00000, 0.00000, 167.00000);
    CreateDynamicObject(978, 3231.04590, -466.85580, 7.66510, 0.00000, 0.00000, 174.00000);
    CreateDynamicObject(978, 3243.58887, -468.25568, 7.66510, 0.00000, 0.00000, 177.00000);
    CreateDynamicObject(978, 3260.04590, -468.59869, 7.66510, 0.00000, 0.00000, 182.00000);
    CreateDynamicObject(18228, 3259.34497, -574.79932, -5.21310, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3258.49707, -562.73279, -5.21310, 0.00000, 0.00000, 280.00000);
    CreateDynamicObject(18228, 3260.11035, -503.63870, -5.21310, 0.00000, 0.00000, 280.00000);
    CreateDynamicObject(18228, 3260.89746, -521.85730, -5.21310, 0.00000, 0.00000, 280.00000);
    CreateDynamicObject(11695, 3403.12793, -529.43671, -25.61870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18228, 3306.13428, -579.35730, -5.21310, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3259.34497, -574.79932, -5.21310, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3300.31641, -577.88171, -5.21310, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3305.30054, -563.66278, -5.21310, 0.00000, 0.00000, 316.23999);
    CreateDynamicObject(11695, 3433.27539, -416.29318, -25.61870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11695, 3340.77173, -370.25385, -25.65870, 0.00000, 0.00000, -0.30000);
    CreateDynamicObject(979, 3358.73022, -556.67493, 33.09500, 0.00000, 0.00000, -10.00000);
    CreateDynamicObject(19951, 3349.36719, -550.38214, 30.38940, 0.00000, 0.00000, 116.00000);
    CreateDynamicObject(19951, 3350.24609, -552.34302, 30.38940, 0.00000, 0.00000, 116.00000);
    CreateDynamicObject(19951, 3351.35889, -554.28290, 30.38940, 0.00000, 0.00000, 130.00000);
    CreateDynamicObject(19951, 3353.30688, -555.77942, 30.38940, 0.00000, 0.00000, 152.00000);
    CreateDynamicObject(979, 3376.70581, -563.62500, 33.09500, 0.00000, 0.00000, -21.00000);
    CreateDynamicObject(979, 3395.45361, -567.38501, 33.09500, 0.00000, 0.00000, -6.00000);
    CreateDynamicObject(979, 3433.14551, -569.96350, 33.09500, 0.00000, 0.00000, -9.00000);
    CreateDynamicObject(979, 3447.96167, -568.79120, 33.09500, 0.00000, 0.00000, 10.00000);
    CreateDynamicObject(979, 3466.91602, -540.76099, 33.09500, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(979, 3462.50537, -522.28741, 33.09500, 0.00000, 0.00000, 103.00000);
    CreateDynamicObject(979, 3460.37842, -503.41919, 33.09500, 0.00000, 0.00000, 86.00000);
    CreateDynamicObject(19951, 3460.54102, -496.48639, 30.60010, 0.00000, 0.00000, -77.00000);
    CreateDynamicObject(19951, 3459.99976, -494.99347, 30.60010, 0.00000, 0.00000, -47.00000);
    CreateDynamicObject(19951, 3458.97339, -493.90854, 30.60010, 0.00000, 0.00000, -33.00000);
    CreateDynamicObject(19951, 3457.74927, -493.17245, 30.60010, 0.00000, 0.00000, -18.00000);
    CreateDynamicObject(19951, 3456.43872, -492.63986, 30.60010, 0.00000, 0.00000, -4.00000);
    CreateDynamicObject(11696, 3590.51270, -477.02689, 39.11480, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(11697, 3521.83423, -422.03384, 125.10030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11697, 3449.14063, -422.15298, 125.16030, 0.00000, 0.00000, -90.00000);
    CreateDynamicObject(11698, 3445.75146, -422.05258, 125.24030, 0.00000, 0.00000, -90.00000);
    CreateDynamicObject(11698, 3453.59961, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3456.56738, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3459.55103, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3462.51489, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3465.49316, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3468.46094, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3471.43140, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3474.38745, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3477.37012, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3480.29761, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3483.28394, -422.01889, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3486.26294, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3489.24951, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3492.19800, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3495.13867, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3498.10376, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3501.07715, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3504.05713, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3507.04297, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3510.03345, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3512.97437, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3515.98291, -422.03381, 124.78030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(11698, 3517.44043, -422.02301, 124.74030, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19842, 3482.39990, -410.47986, 7.46216, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3482.39990, -435.46631, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3482.39990, -460.42831, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3482.39990, -485.38721, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3482.39990, -510.34570, 7.46220, 0.00000, 0.00000, -0.06000);
    CreateDynamicObject(19842, 3482.37988, -533.06110, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3482.33984, -580.61609, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3494.02271, -435.46631, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3494.02271, -460.42831, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -460.42831, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -485.38721, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -510.34570, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3459.14990, -485.40649, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3459.14990, -510.34570, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -535.31372, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -560.30902, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3470.78442, -585.29932, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19842, 3459.18774, -560.30902, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(10166, 3478.00562, -403.34766, -1.98978, 0.00000, 0.00000, 83.78303);
    CreateDynamicObject(10166, 3484.43701, -520.04816, -2.90592, 0.00000, 0.00000, 83.78303);
    CreateDynamicObject(18752, 3474.34692, -311.48312, 6.27361, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18752, 3470.59009, -323.15891, -2.95682, 0.00000, 0.00000, 300.15598);
    CreateDynamicObject(19841, 3473.62744, -339.65689, 59.53640, -40.98000, 0.00000, 1.50710);
    CreateDynamicObject(17025, 3450.57617, -335.07910, 49.54970, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(17025, 3447.77979, -342.60834, 47.38861, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3473.80615, -346.46158, 58.35221, -40.98000, 0.00000, 1.50710);
    CreateDynamicObject(17025, 3453.14209, -350.34689, 44.17571, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3474.01416, -392.12302, 24.45827, -20.98000, 0.00000, 2.22845);
    CreateDynamicObject(17025, 3445.78467, -369.04596, 25.44747, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3473.74414, -359.98300, 53.57419, -40.98000, 0.00000, 1.50710);
    CreateDynamicObject(17025, 3443.11865, -361.52417, 33.28925, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3473.78882, -373.96475, 40.55322, -20.98000, 0.00000, 1.50710);
    CreateDynamicObject(19841, 3482.79077, -403.00952, 9.69428, -20.98000, 0.00000, 2.04845);
    CreateDynamicObject(19841, 3489.05688, -392.36984, 24.45827, -20.98000, 0.00000, 2.04845);
    CreateDynamicObject(17025, 3457.71729, -367.88440, 25.44747, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3482.31299, -374.31168, 40.55322, -20.98000, 0.00000, 1.50710);
    CreateDynamicObject(19841, 3489.87964, -374.30298, 40.55322, -20.98000, 0.00000, 1.32710);
    CreateDynamicObject(17025, 3464.29932, -368.28879, 25.44747, 0.00000, 340.00000, 305.14178);
    CreateDynamicObject(17025, 3462.47949, -350.88290, 44.17571, 0.00000, 340.00000, 297.82178);
    CreateDynamicObject(19841, 3480.46216, -360.17789, 53.57419, -40.98000, 0.00000, 1.50710);
    CreateDynamicObject(19841, 3473.74414, -359.98300, 53.57419, -40.98000, 0.00000, 1.50710);
    CreateDynamicObject(19841, 3484.31787, -359.61069, 53.57420, -41.00000, 0.00000, 18.00000);
    CreateDynamicObject(17025, 3461.71289, -347.38513, 47.28455, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(17025, 3440.06519, -366.15518, 33.22034, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(19841, 3481.37744, -348.56720, 58.35220, -41.00000, 0.00000, -4.00000);
    CreateDynamicObject(17025, 3455.29468, -325.48248, 57.76940, 0.00000, 340.00000, 305.08179);
    CreateDynamicObject(17025, 3447.82227, -323.25647, 62.95729, 0.00000, 340.00000, 313.06894);
    CreateDynamicObject(19841, 3482.20679, -392.82281, 24.45827, -20.98000, 0.00000, 2.04845);
    CreateDynamicObject(900, 3464.45483, -382.43185, 38.92474, 0.00000, -40.00000, 56.55053);
    CreateDynamicObject(900, 3462.61255, -350.19235, 59.13483, 0.00000, -40.00000, 56.55053);
    CreateDynamicObject(900, 3464.34717, -367.89703, 51.25868, 0.00000, -40.00000, 56.55053);
    CreateDynamicObject(900, 3493.18359, -367.81735, 49.82208, 0.00000, -40.00000, 77.64168);
    CreateDynamicObject(900, 3490.10449, -357.77774, 58.15973, 0.00000, -40.00000, 77.23564);
    CreateDynamicObject(900, 3469.51709, -341.92419, 64.63801, 0.00000, -40.00000, 9.86636);
    CreateDynamicObject(900, 3466.28760, -391.35770, 23.67800, 0.00000, -60.00000, 56.55050);
    CreateDynamicObject(900, 3487.70410, -391.30710, 23.67800, 0.00000, -60.00000, 56.55050);
    CreateDynamicObject(900, 3473.14771, -398.56821, 15.79340, 0.00000, -80.00000, 56.55050);
    CreateDynamicObject(900, 3479.26709, -396.98990, 15.79340, 0.00000, -80.00000, 56.55050);
    CreateDynamicObject(900, 3486.73755, -395.77316, 15.79340, 0.00000, -80.00000, 56.55050);
    CreateDynamicObject(900, 3480.03320, -406.98383, 2.15558, 0.00000, -80.00000, 56.55050);
    CreateDynamicObject(19841, 3473.36670, -550.32373, 2.68470, -50.98000, 0.00000, 2.04850);
    CreateDynamicObject(19841, 3470.68164, -510.53644, 2.05299, -50.98000, 0.00000, 2.04850);
    CreateDynamicObject(19842, 3459.18823, -585.26819, 7.46220, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(900, 3458.79102, -566.94220, 6.38243, 0.00000, 0.00000, 73.06567);
    CreateDynamicObject(900, 3454.89771, -607.93884, 5.08019, 0.00000, 0.00000, 97.12961);
    CreateDynamicObject(900, 3458.79102, -566.94220, 6.38243, 0.00000, 0.00000, 73.06567);
    CreateDynamicObject(900, 3488.12842, -579.77887, 6.38243, 0.00000, 0.00000, 73.12567);
    CreateDynamicObject(900, 3486.80298, -612.50159, -0.61667, 0.00000, 0.00000, 73.12567);
    CreateDynamicObject(19841, 3467.81909, -607.20380, 1.78827, -50.00000, 0.00000, 0.30301);
    CreateDynamicObject(900, 3487.57080, -595.83405, 6.13818, 0.00000, 0.00000, 73.12567);
    CreateDynamicObject(900, 3459.29736, -588.25476, 6.38243, 0.00000, 0.00000, 73.12567);
    CreateDynamicObject(19841, 3475.14526, -606.17712, 1.78827, -50.00000, 0.00000, 0.30301);
    CreateDynamicObject(901, 3466.58862, -602.40656, 5.08020, 0.00000, 0.00000, 97.12960);
    CreateDynamicObject(901, 3475.85205, -603.38348, 5.08020, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(901, 3484.50220, -609.04486, 2.36720, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(901, 3492.64282, -606.89221, 2.36720, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(901, 3478.61963, -610.71771, 0.87039, -139.01988, 25.68002, 97.12960);
    CreateDynamicObject(901, 3472.19604, -610.39398, 1.29714, -139.01988, 25.68002, 97.12960);
    CreateDynamicObject(901, 3473.53491, -549.43378, 5.49961, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(901, 3475.03516, -545.83624, 5.53377, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(901, 3466.57397, -506.95380, 5.12773, 0.00000, 0.00000, 327.28391);
    CreateDynamicObject(901, 3471.21436, -508.09042, 5.12773, 0.00000, 0.00000, 327.28391);

    new RuaTexturizar;
    RuaTexturizar = CreateDynamicObject(11111, 3405.00488, -73.76580, 6.81520, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3464.97192, -73.76420, 6.8252, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3577.27954, -170.83740, 6.81520, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3577.2542, -350.7098, 6.8352, -0.0300, 0.0000, 0.0000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3577.26807, -290.73560, 6.81520, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3577.26953, -230.79649, 6.81520, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(11111, 3477.40356, -73.76160, 6.81520, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(6881, 3194.98413, -243.76599, 6.81520, 0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(6881, 3274.95483, -183.76610, 6.81520, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(6881, 3195.09717, -442.23981, 6.81520, 0.00000, 0.00000, 270.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(6881, 3335.01953, -103.79177, 6.81520, 0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(6881, 3547.38477, -103.70110, 6.81520, 0.00000, 0.00000, 90.10870);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);
    RuaTexturizar = CreateDynamicObject(4808, 3150.24609, -343.01419, 6.82592, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(RuaTexturizar, 0, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 1, 5703, "roads_lawn", "LAroad_offroad1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(RuaTexturizar, 2, 17500, "stormdrain", "craproad3_LAe", 0xFFFFFFFF);

    CreateDynamicObject(901, 3482.59009, -509.14307, 5.12773, 0.00000, 0.00000, 327.28391);
    CreateDynamicObject(19840, 3238.85059, -414.17648, 5.41709, -20.00000, 0.00000, 269.38480);
    CreateDynamicObject(896, 3244.44653, -414.00293, 12.36418, 0.00000, 0.00000, 344.10785);
    CreateDynamicObject(896, 3267.76050, -416.51633, 76.73833, -107.69997, 59.64005, 76.68090);
    CreateDynamicObject(896, 3269.17944, -401.29236, 75.43732, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(896, 3267.41699, -413.62280, 70.49646, -1.74000, 22.50002, 350.72589);
    CreateDynamicObject(901, 3264.23438, -414.93848, 66.16544, 0.00000, 0.00000, 52.01093);
    CreateDynamicObject(901, 3268.25073, -410.51895, 80.60706, 0.00000, 0.00000, -85.98007);
    CreateDynamicObject(901, 3261.91455, -409.66403, 64.96253, -19.01999, -22.26000, 228.41080);
    CreateDynamicObject(896, 3268.48071, -410.87628, 70.49646, -1.74000, 22.50002, 350.72589);
    CreateDynamicObject(17026, 3263.28149, -413.71527, 22.66495, -144.00000, -100.00000, 360.00000);
    CreateDynamicObject(17026, 3271.99414, -415.11029, 46.35596, -144.00000, -100.00000, 360.00000);
    CreateDynamicObject(3930, 3258.59082, -412.65436, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3931, 3258.41943, -414.11050, 57.83980, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(3929, 3256.89697, -410.75214, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3929, 3258.38477, -409.11902, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3257.64722, -408.20691, 57.32970, 0.00000, 0.00000, -0.54000);
    CreateDynamicObject(3930, 3257.63940, -406.71539, 57.32970, 0.00000, 0.00000, -4.32000);
    CreateDynamicObject(3931, 3258.40845, -410.40411, 57.32969, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3258.66309, -411.74457, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3258.65527, -407.72021, 57.43168, 0.00000, 0.00000, -0.54000);
    CreateDynamicObject(3930, 3257.06812, -409.33432, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3929, 3257.64575, -415.55380, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3931, 3256.85962, -412.16241, 57.32970, 0.00000, 0.00000, -178.00000);
    CreateDynamicObject(3931, 3257.14722, -413.97818, 57.32969, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3258.62280, -416.88126, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(821, 3256.83301, -416.98550, 57.12780, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(3930, 3257.57178, -409.73639, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3257.76245, -411.40427, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3257.82983, -413.20084, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3258.44336, -415.30099, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3931, 3258.28418, -416.66556, 57.94489, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(821, 3256.51855, -414.23920, 57.12780, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(821, 3256.60522, -412.00806, 57.12780, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(821, 3256.81641, -409.19022, 57.12780, 0.00000, 0.00000, 310.55801);
    CreateDynamicObject(821, 3256.60522, -412.00806, 57.12780, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(821, 3262.61182, -405.57919, 78.71239, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3256.60522, -412.00806, 57.12780, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(821, 3256.81641, -409.19022, 57.12780, 0.00000, 0.00000, 310.55801);
    CreateDynamicObject(821, 3252.02393, -398.42786, 34.71839, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3257.37598, -420.29535, 55.57788, 0.00000, 0.00000, 310.97800);
    CreateDynamicObject(821, 3256.47461, -405.90622, 57.12780, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3261.84302, -407.73688, 77.99104, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3262.39746, -411.79269, 77.99104, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3261.57471, -411.07950, 80.00226, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3265.12500, -403.82687, 68.12209, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(3929, 3257.95117, -404.76389, 57.32970, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3929, 3257.34863, -405.42914, 56.70213, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3930, 3258.49268, -407.28378, 57.32970, 0.00000, 0.00000, -0.54000);
    CreateDynamicObject(3930, 3258.65527, -407.72021, 57.74700, 0.00000, 0.00000, -0.54000);
    CreateDynamicObject(821, 3262.57568, -403.47458, 77.99104, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(821, 3261.44385, -403.54459, 68.12209, 0.00000, 0.00000, 309.95804);
    CreateDynamicObject(19841, 3251.52637, -409.98251, 44.00393, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(17026, 3272.24463, -409.32602, 46.35596, -144.00000, -100.00000, 360.00000);
    CreateDynamicObject(17026, 3272.24463, -409.32602, 33.96714, -144.00000, -100.00000, 360.00000);
    CreateDynamicObject(896, 3271.06982, -409.58423, 89.53120, 0.00000, 0.00000, 336.66602);
    CreateDynamicObject(896, 3249.09985, -422.73767, 31.66614, 0.00000, 0.00000, 336.66602);
    CreateDynamicObject(901, 3245.96582, -414.69025, 25.05304, 0.00000, 0.00000, 262.77487);
    CreateDynamicObject(896, 3249.03296, -406.80164, 31.66614, 0.00000, 0.00000, 336.66602);
    CreateDynamicObject(896, 3246.03174, -410.08203, 4.97558, 0.00000, 0.00000, 336.56601);
    CreateDynamicObject(896, 3228.77246, -405.29468, 1.04624, 0.00000, 0.00000, 344.16785);
    CreateDynamicObject(896, 3244.07910, -414.29666, 18.94368, 0.00000, 0.00000, 344.10785);
    CreateDynamicObject(18228, 3233.83960, -446.26846, -4.46197, 0.00000, 0.00000, 235.06300);
    CreateDynamicObject(19841, 3242.88232, -413.59839, 19.60371, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(18228, 3232.62622, -391.40302, -5.91318, 0.00000, 0.00000, 235.12300);
    CreateDynamicObject(896, 3247.96729, -411.71515, 18.94368, 0.00000, 0.00000, 344.16785);
    CreateDynamicObject(896, 3229.36084, -426.44424, 3.04237, 0.00000, 0.00000, 344.16785);
    CreateDynamicObject(821, 3257.14600, -402.64694, 55.68085, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3231.64673, -404.52197, 9.10496, 0.00000, 0.00000, 310.40817);
    CreateDynamicObject(821, 3243.00439, -408.37024, 35.75931, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3243.10400, -420.10641, 34.59836, 0.00000, 0.00000, 308.96118);
    CreateDynamicObject(821, 3252.04028, -419.92111, 38.97221, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3246.43823, -421.59552, 37.70396, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3250.48218, -414.53195, 42.11245, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3244.06152, -417.09857, 35.75931, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3247.17749, -418.08566, 38.97221, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3250.70996, -414.28687, 38.97221, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3247.58789, -402.13947, 37.96842, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3250.49731, -403.53061, 40.37432, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3253.19946, -400.27744, 40.11897, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3249.04688, -402.51831, 44.41069, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3244.95044, -404.86938, 35.75931, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3241.21118, -406.59937, 27.95032, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3238.03320, -405.29462, 14.97377, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3238.99951, -420.08484, 15.06775, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3234.12183, -410.09885, 9.10496, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3230.95532, -420.32724, 4.45706, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3235.52002, -420.00601, 13.39944, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(821, 3235.96924, -406.66516, 10.94800, 0.00000, 0.00000, 309.89804);
    CreateDynamicObject(19841, 3130.60693, -433.07126, -6.66612, -40.00000, 0.00000, 291.59311);
    CreateDynamicObject(837, 3208.17725, -413.69754, 4.40450, 0.00000, 0.00000, 193.00000);
    CreateDynamicObject(837, 3211.18384, -414.29086, 4.40450, 0.00000, 0.00000, 171.00000);
    CreateDynamicObject(18671, 3231.73779, -416.00430, 4.34472, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18742, 3232.29688, -415.92590, 4.53922, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3241.76831, -413.22528, 26.88339, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18742, 3244.17017, -413.55414, 31.17266, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3256.36353, -405.47290, 50.85363, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3255.30151, -415.46329, 55.80839, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(896, 3253.82983, -418.96710, 31.66614, 0.00000, 0.00000, 336.66602);
    CreateDynamicObject(18671, 3136.89697, -432.09650, -2.01711, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3136.67480, -430.83331, -1.48848, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(896, 3122.29150, -436.12628, -10.98426, 0.00000, 0.00000, 342.94891);
    CreateDynamicObject(896, 3130.06372, -433.22253, -7.89693, 0.00000, 0.00000, 342.94891);
    CreateDynamicObject(896, 3122.76953, -437.54410, -14.34324, 0.00000, 0.00000, 342.94891);
    CreateDynamicObject(896, 3124.31934, -427.88507, -7.89693, 0.00000, 0.00000, 342.94891);
    CreateDynamicObject(896, 3127.68506, -435.15747, -7.49089, 0.00000, 0.00000, 342.94891);
    CreateDynamicObject(714, 3247.66382, -360.80539, -19.62880, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(714, 3240.54370, -393.77063, -19.62880, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(714, 3274.66797, -337.45926, -19.62880, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(714, 3255.13770, -318.69281, -19.62880, 0.00000, 0.00000, 77.97999);
    CreateDynamicObject(714, 3233.11865, -438.88339, -19.62880, 0.00000, 0.00000, 76.12000);
    CreateDynamicObject(714, 3234.50000, -526.75800, -19.62880, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(714, 3272.35156, -573.20007, -23.36930, 0.00000, 0.00000, 73.42000);
    CreateDynamicObject(16061, 3166.28540, -457.48447, -2.36500, 0.00000, 0.00000, 222.00000);
    CreateDynamicObject(714, 3122.80176, -402.58960, -27.62426, 0.00000, 0.00000, 178.00000);
    CreateDynamicObject(16061, 3300.56470, -488.18814, 116.69705, 0.00000, 0.00000, 171.44267);
    CreateDynamicObject(16061, 3159.52612, -548.69879, -2.36500, 0.00000, 0.00000, 338.00000);
    CreateDynamicObject(16061, 3179.15869, -584.47522, -2.36500, 0.00000, 0.00000, 265.00000);
    CreateDynamicObject(16061, 3181.41943, -547.74927, -2.36500, 0.00000, 0.00000, 331.00000);
    CreateDynamicObject(16061, 3206.78369, -514.74268, -2.36500, 0.00000, 0.00000, 360.00000);
    CreateDynamicObject(714, 3204.00952, -503.62930, -26.32444, 0.00000, 0.00000, 76.18000);
    CreateDynamicObject(714, 3177.39478, -513.02881, -26.32440, 0.00000, 0.00000, 120.00000);
    CreateDynamicObject(714, 3161.63184, -469.17151, -26.32440, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(714, 3172.64136, -554.31348, -26.32440, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(714, 3201.26538, -568.79395, -26.32440, 0.00000, 0.00000, 155.94000);
    CreateDynamicObject(714, 3138.88672, -385.40985, -24.32370, 0.00000, 0.00000, 178.00000);
    CreateDynamicObject(16061, 3182.80078, -380.46228, -6.12549, 0.00000, 0.00000, 360.00000);
    CreateDynamicObject(16061, 3192.67212, -262.19232, -2.36500, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(16061, 3197.54248, -378.02664, -2.36500, 0.00000, 0.00000, 200.00000);
    CreateDynamicObject(16061, 3218.23120, -379.25403, -2.36500, 0.00000, 0.00000, 360.00000);
    CreateDynamicObject(714, 3209.88330, -437.53363, -26.98739, 0.00000, 0.00000, 43.94573);
    CreateDynamicObject(18228, 3356.61035, -564.94324, -3.98165, 0.00000, 0.00000, 316.23999);
    CreateDynamicObject(18228, 3402.95679, -576.32190, -3.98165, 0.00000, 0.00000, 316.12000);
    CreateDynamicObject(18228, 3429.59741, -577.14972, -3.98165, 0.00000, 0.00000, 316.12000);
    CreateDynamicObject(18228, 3362.63452, -582.31403, -3.98165, 0.00000, 0.00000, 316.12000);
    CreateDynamicObject(18228, 3349.18677, -606.52679, -3.98160, 0.00000, 0.00000, 295.00000);
    CreateDynamicObject(18228, 3414.67847, -604.23187, -3.98165, 0.00000, 0.00000, 316.06000);
    CreateDynamicObject(18228, 3428.80371, -593.62488, -3.98165, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3371.25366, -597.54346, -3.98165, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3382.37988, -597.40967, -3.98160, 0.00000, 0.00000, 207.00000);
    CreateDynamicObject(706, 3288.05933, -585.60559, 4.83460, 0.00000, 0.00000, -47.00000);
    CreateDynamicObject(714, 3334.32056, -567.86169, -29.14078, 0.00000, 0.00000, 74.07999);
    CreateDynamicObject(714, 3334.61230, -602.04828, -29.14080, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(714, 3358.37012, -601.05444, -29.14080, 0.00000, 0.00000, 32.52000);
    CreateDynamicObject(714, 3366.01978, -579.27307, -29.14080, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(714, 3394.64819, -597.26263, -29.14080, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(714, 3430.16772, -602.59314, -29.14080, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(714, 3414.23950, -576.14026, -29.14080, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(714, 3388.56982, -576.03308, -29.14080, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(709, 3389.69849, -609.03894, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(714, 3329.75073, -612.81158, 6.16900, 0.00000, 0.00000, 33.48000);
    CreateDynamicObject(11695, 3581.55054, -532.81537, -25.61870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11695, 3661.22339, -530.35339, -25.57870, 0.00000, 0.00000, -0.18000);
    CreateDynamicObject(11695, 3673.67358, -413.38394, -25.53870, 0.00000, 0.00000, -0.18000);
    CreateDynamicObject(11695, 3600.48682, -255.43790, -25.85870, 0.00000, 0.00000, -0.18000);
    CreateDynamicObject(11695, 3522.20117, -132.23553, -25.87870, 0.00000, 0.00000, -0.18000);
    CreateDynamicObject(11695, 3381.03955, -133.93021, -25.87870, 0.00000, 0.00000, -0.60000);
    CreateDynamicObject(11695, 3345.04590, -221.67070, -25.93870, 0.00000, 0.00000, -0.60000);
    CreateDynamicObject(11695, 3235.17725, -177.46741, -25.81870, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16061, 3148.71045, -308.19220, -2.36500, 0.00000, 0.00000, 361.08002);
    CreateDynamicObject(16061, 3129.21362, -309.57703, -2.36500, 0.00000, 0.00000, 361.14001);
    CreateDynamicObject(16061, 3148.08423, -262.88809, -2.36500, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(16061, 3139.85327, -271.41357, -2.36500, 0.00000, 0.00000, 361.14001);
    CreateDynamicObject(16061, 3137.35205, -308.90140, -2.36500, 0.00000, 0.00000, 361.14001);
    CreateDynamicObject(714, 3129.77319, -299.60870, -24.32370, 0.00000, 0.00000, 178.00000);
    CreateDynamicObject(714, 3136.56934, -267.66058, -24.32370, 0.00000, 0.00000, 178.17999);
    CreateDynamicObject(8060, 3194.97925, -314.68839, 11.77340, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(16061, 3218.23120, -379.25403, -2.36500, 0.00000, 0.00000, 360.00000);
    CreateDynamicObject(16061, 3232.84473, -234.20477, -2.36500, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(16061, 3224.84839, -267.19531, -2.36500, 0.00000, 0.00000, 104.82000);
    CreateDynamicObject(16061, 3227.68628, -276.50586, -2.36500, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(16061, 3251.00439, -262.88730, -2.36500, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(714, 3224.27295, -260.86011, -25.12198, 0.00000, 0.00000, 78.51999);
    CreateDynamicObject(714, 3227.32031, -335.36938, -25.12198, 0.00000, 0.00000, 78.45999);
    CreateDynamicObject(714, 3234.06494, -302.19046, -25.12198, 0.00000, 0.00000, 78.93999);
    CreateDynamicObject(714, 3230.67285, -279.49741, -25.12198, 0.00000, 0.00000, 80.44000);
    CreateDynamicObject(3113, 3179.00317, -333.66879, 5.89546, 0.00000, -80.00000, 180.00000);
    CreateDynamicObject(3113, 3179.22363, -310.86871, 5.89550, 0.00000, -80.00000, 180.00000);
    CreateDynamicObject(3113, 3179.25952, -296.06589, 5.89550, 0.00000, -80.00000, 180.00000);
    CreateDynamicObject(16061, 3205.67749, -348.49438, -6.12550, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(16061, 3213.28101, -348.29749, -6.12550, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(16061, 3177.57129, -216.83833, -2.36500, 0.00000, 0.00000, 135.00000);
    CreateDynamicObject(16061, 3173.89990, -183.37807, -2.36500, 0.00000, 0.00000, 164.00000);
    CreateDynamicObject(16061, 3191.56812, -170.25563, -2.36500, 0.00000, 0.00000, 165.62000);
    CreateDynamicObject(16061, 3226.24121, -191.49585, -2.36500, 0.00000, 0.00000, 265.00000);
    CreateDynamicObject(16061, 3249.87500, -109.77433, -2.36500, 0.00000, 0.00000, 267.28000);
    CreateDynamicObject(16061, 3244.60083, -169.67105, -2.36500, 0.00000, 0.00000, 267.28000);
    CreateDynamicObject(16061, 3252.92090, -144.06143, -2.36500, 0.00000, 0.00000, 267.28000);
    CreateDynamicObject(16061, 3209.20288, -142.38121, -2.36500, 0.00000, 0.00000, 165.98000);
    CreateDynamicObject(16061, 3167.22217, -127.79128, -2.36500, 0.00000, 0.00000, 165.62000);
    CreateDynamicObject(16061, 3187.93604, -126.89034, -2.36500, 0.00000, 0.00000, 165.98000);
    CreateDynamicObject(714, 3195.75659, -187.81575, -24.32370, 0.00000, 0.00000, 178.17999);
    CreateDynamicObject(714, 3228.46167, -173.25269, -24.32370, 0.00000, 0.00000, 178.17999);
    CreateDynamicObject(714, 3256.62744, -153.50711, -24.32370, 0.00000, 0.00000, 178.17999);
    CreateDynamicObject(714, 3263.57642, -128.75987, -24.32370, 0.00000, 0.00000, 179.07999);
    CreateDynamicObject(714, 3212.96265, -123.54623, -24.32370, 0.00000, 0.00000, 179.07999);
    CreateDynamicObject(714, 3176.63135, -132.56110, -24.32370, 0.00000, 0.00000, 176.67999);
    CreateDynamicObject(714, 3273.90137, -237.15799, -19.62880, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(714, 3309.42920, -207.57237, -19.62880, 0.00000, 0.00000, 76.18000);
    CreateDynamicObject(714, 3342.24878, -251.52277, -19.62880, 0.00000, 0.00000, 76.72000);
    CreateDynamicObject(714, 3289.49927, -285.78125, -19.62880, 0.00000, 0.00000, 76.48000);
    CreateDynamicObject(714, 3399.15283, -256.30280, -19.62880, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3368.07690, -190.21797, -19.62880, 0.00000, 0.00000, 77.32001);
    CreateDynamicObject(714, 3338.14185, -122.32941, -27.33058, 0.00000, 0.00000, 77.50001);
    CreateDynamicObject(714, 3412.61768, -134.29468, -19.62880, 0.00000, 0.00000, 77.68001);
    CreateDynamicObject(714, 3400.30737, -109.12780, -19.62880, 0.00000, 0.00000, 81.70001);
    CreateDynamicObject(714, 3424.46460, -221.29620, -19.62880, 0.00000, 0.00000, 77.68001);
    CreateDynamicObject(16061, 3346.43042, -166.56488, -2.36500, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(16061, 3382.20728, -218.89186, -2.36500, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(16061, 3347.77954, -280.39752, -2.36500, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(16061, 3305.56909, -243.61601, -2.36500, 0.00000, 0.00000, 105.06000);
    CreateDynamicObject(16061, 3301.15674, -317.82056, -2.36500, 0.00000, 0.00000, 105.06000);
    CreateDynamicObject(16061, 3360.72021, -320.60193, -2.36500, 0.00000, 0.00000, 105.06000);
    CreateDynamicObject(16061, 3394.91260, -158.17650, -2.36500, 0.00000, 0.00000, 40.00000);
    CreateDynamicObject(16061, 3378.18652, -269.53806, -2.36500, 0.00000, 0.00000, 40.00000);
    CreateDynamicObject(16061, 3338.75146, -116.33057, -2.36500, 0.00000, 0.00000, 149.00000);
    CreateDynamicObject(16061, 3373.39111, -57.44460, -5.32465, 0.00000, 0.00000, 91.00000);
    CreateDynamicObject(16061, 3436.72290, -55.99176, -4.81216, 0.00000, 0.00000, 91.00000);
    CreateDynamicObject(16061, 3500.77295, -54.45861, -4.64709, 0.00000, 0.00000, 91.00000);
    CreateDynamicObject(714, 3311.38403, -69.54920, -26.57431, 0.00000, 0.00000, 273.00000);
    CreateDynamicObject(714, 3339.06030, -60.96857, -30.05280, 0.00000, 0.00000, 244.00000);
    CreateDynamicObject(714, 3410.77979, -54.81384, -31.19917, 0.00000, 0.00000, 244.00000);
    CreateDynamicObject(18228, 3479.38403, -297.07855, -5.21306, 0.00000, 0.00000, 235.12300);
    CreateDynamicObject(18228, 3407.91797, -332.32376, 6.01213, 0.00000, 0.00000, 228.00000);
    CreateDynamicObject(18228, 3445.14380, -255.61780, 5.24056, 0.00000, 0.00000, 171.00000);
    CreateDynamicObject(18228, 3479.91064, -242.23170, 8.06492, 0.00000, 0.00000, 127.00000);
    CreateDynamicObject(18228, 3519.30029, -267.42511, 8.06490, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(18228, 3539.22681, -298.20599, 8.06490, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(18228, 3544.49902, -341.39493, 8.06490, 0.00000, 0.00000, 62.00000);
    CreateDynamicObject(714, 3407.28564, -321.79037, -19.62880, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3415.11206, -291.88931, -19.62880, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3429.46875, -267.39279, -14.74016, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3445.66040, -252.23997, -19.62880, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3470.94336, -246.89543, -11.81979, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3505.45068, -257.34305, -11.81979, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3522.14648, -269.09875, -14.02169, 0.00000, 0.00000, 76.54000);
    CreateDynamicObject(714, 3526.46777, -321.76245, 7.19306, 0.00000, 0.00000, 76.60000);
    CreateDynamicObject(714, 3351.63818, -105.54745, -28.32373, 0.00000, 0.00000, 77.50001);
    CreateDynamicObject(714, 3361.67480, -129.16707, -27.40759, 0.00000, 0.00000, 77.50001);
    CreateDynamicObject(16326, 3390.21826, -95.44745, 6.64294, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3253, 3379.21045, -91.49205, 6.89824, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(16061, 3391.38013, -93.18462, -2.36500, 0.00000, 0.00000, 265.00000);
    CreateDynamicObject(16061, 3379.96289, -112.54856, -2.36500, 0.00000, 0.00000, 149.00000);
    CreateDynamicObject(709, 3189.67236, -574.80939, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3222.71997, -485.19678, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3233.89453, -336.57532, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(694, 3179.10815, -523.68604, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3211.46509, -432.93845, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3134.12549, -383.87314, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3129.99951, -274.92548, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3185.01440, -398.75644, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3213.49438, -265.65933, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3193.18896, -183.08452, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3261.13232, -153.01149, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3336.30591, -184.61469, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(689, 3167.42920, -468.90149, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3191.55493, -498.11249, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3165.35962, -555.41516, 6.09927, 0.00000, 0.00000, 3.18000);
    CreateDynamicObject(689, 3193.73096, -432.99728, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3142.01807, -406.39508, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3183.14722, -364.15747, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3146.67456, -332.23575, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3183.34741, -274.31396, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3172.45239, -212.85739, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3221.90894, -234.94293, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3247.56323, -182.56569, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3290.91064, -215.11168, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(709, 3146.46021, -297.94800, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(683, 3152.37231, -369.14755, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3188.77441, -376.35977, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3248.83740, -236.00957, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3161.36450, -239.05345, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3213.89282, -199.71196, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3269.80273, -184.65685, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3162.82422, -439.93454, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3196.01123, -474.26828, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3222.90405, -453.60034, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(694, 3236.27905, -293.57620, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(709, 3170.94019, -133.06422, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(689, 3156.69653, -437.88232, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(694, 3389.81567, -95.72344, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3313.51318, -66.54507, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(689, 3325.66357, -130.36449, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3385.12793, -131.86404, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3274.05591, -116.02928, 6.09927, 0.00000, 0.00000, 3.24000);
    CreateDynamicObject(709, 3355.24561, -102.01299, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3235.10400, -133.93115, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(683, 3289.49097, -111.23431, 6.30331, 0.00000, 0.00000, 0.60000);
    CreateDynamicObject(694, 3276.88184, -133.71233, 5.46833, 0.00000, 0.00000, -27.12000);
    CreateDynamicObject(16061, 3299.55273, -103.39229, -4.81560, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(689, 3300.33276, -97.53435, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(16061, 3459.99634, -95.66062, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3475.13721, -126.05692, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3459.91138, -158.15433, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3473.91895, -191.00899, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3519.67505, -142.37584, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3522.39087, -174.13937, -2.36500, 0.00000, 0.00000, -91.00000);
    CreateDynamicObject(16061, 3511.77148, -107.78604, -2.36500, 0.00000, 0.00000, -90.88000);
    CreateDynamicObject(16061, 3545.33008, -217.60565, -2.36500, 0.00000, 0.00000, 25.00000);
    CreateDynamicObject(16061, 3562.93164, -77.64806, -2.36500, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(714, 3466.92773, -105.25237, -19.62880, 0.00000, 0.00000, 77.68001);
    CreateDynamicObject(714, 3544.57349, -138.21646, -21.22730, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(714, 3540.09155, -182.74062, -19.62880, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(714, 3439.22754, -191.15611, -16.27055, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(714, 3506.33350, -197.05783, -16.27055, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(714, 3453.70068, -148.30219, -16.27055, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(714, 3490.58374, -163.13878, -16.27055, 0.00000, 0.00000, 142.06000);
    CreateDynamicObject(694, 3469.37012, -194.50055, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3519.85547, -150.59180, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3485.68188, -90.80882, 5.46833, 0.00000, 0.00000, 292.75754);
    CreateDynamicObject(694, 3397.61206, -191.92690, 5.46833, 0.00000, 0.00000, -28.74000);
    CreateDynamicObject(694, 3392.16895, -264.71436, 5.46833, 0.00000, 0.00000, -28.74000);
    CreateDynamicObject(709, 3441.13428, -116.79665, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3529.76270, -98.60490, 4.63770, 0.00000, 0.00000, -49.52000);
    CreateDynamicObject(709, 3418.68750, -224.74461, 4.63770, 0.00000, 0.00000, -49.70000);
    CreateDynamicObject(709, 3390.68774, -161.51657, 4.63770, 0.00000, 0.00000, -49.88000);
    CreateDynamicObject(689, 3320.34399, -170.13977, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3432.91211, -91.91730, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3467.64453, -90.46025, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3424.95874, -176.70595, 6.09927, 0.00000, 0.00000, 3.18000);
    CreateDynamicObject(689, 3554.49585, -152.93304, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3505.00317, -93.25480, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(694, 3468.05469, -149.44833, 5.46833, 0.00000, 0.00000, -28.68000);
    CreateDynamicObject(683, 3481.18091, -127.02474, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3514.92480, -85.53945, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3448.77368, -83.87209, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(689, 3410.65015, -108.75559, 6.09927, 0.00000, 0.00000, 2.82000);
    CreateDynamicObject(694, 3411.05151, -50.62452, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3555.01245, -56.91858, 5.46833, 0.00000, 0.00000, -27.90000);
    CreateDynamicObject(689, 3474.10596, -55.03181, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3531.21069, -57.50244, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3352.49658, -57.32841, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(683, 3376.85840, -53.00199, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3429.92993, -49.23575, 6.30331, 0.00000, 0.00000, 0.54000);
    CreateDynamicObject(683, 3452.98608, -51.09732, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3494.17407, -49.89186, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3514.87646, -49.51030, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(16061, 3572.50708, -64.86259, -2.36500, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(683, 3580.58984, -60.85606, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(689, 3568.53442, -72.94573, 6.09927, 0.00000, 0.00000, 4.02000);
    CreateDynamicObject(714, 3535.70605, -241.88403, -19.62880, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(16061, 3559.85205, -188.43613, -2.36500, 0.00000, 0.00000, 178.00000);
    CreateDynamicObject(694, 3557.48096, -247.04147, 5.46833, 0.00000, 0.00000, -28.20000);
    CreateDynamicObject(689, 3557.55420, -218.82083, 6.09927, 0.00000, 0.00000, 3.36000);
    CreateDynamicObject(689, 3558.56445, -280.11304, 6.09927, 0.00000, 0.00000, 3.60000);
    CreateDynamicObject(683, 3562.38428, -131.73558, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3557.27539, -230.66307, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3562.27051, -173.30673, 6.30331, 0.00000, 0.00000, 2.52000);
    CreateDynamicObject(709, 3557.35913, -180.68225, 4.63770, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(709, 3474.79028, -227.31294, 4.63770, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(16061, 3593.19531, -135.31497, -2.36500, 0.00000, 0.00000, 12.80769);
    CreateDynamicObject(694, 3603.52539, -173.36690, 5.46833, 0.00000, 0.00000, -27.90000);
    CreateDynamicObject(714, 3603.74829, -173.46851, -21.24320, 0.00000, 0.00000, 120.00000);
    CreateDynamicObject(689, 3582.74902, -91.30180, 6.09927, 0.00000, 0.00000, 4.08000);
    CreateDynamicObject(683, 3586.66455, -105.58208, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3593.31958, -123.45038, 6.30331, 0.00000, 0.00000, 2.64000);
    CreateDynamicObject(689, 3597.78296, -148.80382, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(683, 3599.19751, -159.68381, 6.30331, 0.00000, 0.00000, 2.64000);
    CreateDynamicObject(16061, 3557.48535, -257.58603, -2.36500, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(16061, 3599.15112, -229.64688, -2.36500, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(16061, 3600.13159, -299.80438, -2.36500, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(16061, 3622.09863, -248.24597, -2.36500, 0.00000, 0.00000, 3.46000);
    CreateDynamicObject(16061, 3648.18726, -221.22479, -2.36500, 0.00000, 0.00000, 3.40000);
    CreateDynamicObject(16061, 3659.31470, -305.61615, -2.36500, 0.00000, 0.00000, 3.70000);
    CreateDynamicObject(16061, 3630.79297, -329.11664, -2.36500, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(714, 3610.70264, -287.38641, -21.24320, 0.00000, 0.00000, 120.84000);
    CreateDynamicObject(714, 3642.04224, -341.90811, -21.24320, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3605.57104, -332.34076, -21.24320, 0.00000, 0.00000, 121.32000);
    CreateDynamicObject(714, 3640.77417, -277.42047, -21.24320, 0.00000, 0.00000, 121.08000);
    CreateDynamicObject(714, 3615.21826, -206.48801, -21.24320, 0.00000, 0.00000, 109.14000);
    CreateDynamicObject(709, 3636.11011, -210.25806, 4.63770, 0.00000, 0.00000, 47.06000);
    CreateDynamicObject(694, 3604.71729, -234.97336, 5.46833, 0.00000, 0.00000, -27.42000);
    CreateDynamicObject(694, 3657.13306, -304.16089, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(694, 3623.01221, -340.10867, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(694, 3661.74170, -263.43649, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(689, 3613.58325, -252.33499, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(689, 3606.31982, -294.51849, 6.09927, 0.00000, 0.00000, 3.36000);
    CreateDynamicObject(689, 3624.94434, -288.55713, 6.09927, 0.00000, 0.00000, 3.36000);
    CreateDynamicObject(683, 3597.86157, -208.28278, 6.30331, 0.00000, 0.00000, 2.16000);
    CreateDynamicObject(683, 3600.17749, -270.12924, 6.30331, 0.00000, 0.00000, 2.34000);
    CreateDynamicObject(683, 3598.59912, -325.88422, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(683, 3633.90527, -289.17044, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(683, 3667.53735, -196.80144, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(16061, 3660.25537, -211.29030, -2.36500, 0.00000, 0.00000, 3.40000);
    CreateDynamicObject(16061, 3471.41919, -392.32611, 23.20260, -40.00000, 0.00000, 187.61360);
    CreateDynamicObject(714, 3374.41870, -343.13336, -19.62880, 0.00000, 0.00000, 76.42000);
    CreateDynamicObject(714, 3307.83618, -339.03009, -19.62880, 0.00000, 0.00000, 74.74000);
    CreateDynamicObject(714, 3601.36377, -358.69037, -21.24320, 0.00000, 0.00000, 119.27999);
    CreateDynamicObject(694, 3600.47095, -356.11658, 5.46833, 0.00000, 0.00000, -22.38000);
    CreateDynamicObject(689, 3611.97046, -323.24939, 6.09927, 0.00000, 0.00000, 3.36000);
    CreateDynamicObject(683, 3593.08838, -301.31305, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3594.74243, -337.47369, 6.30331, 0.00000, 0.00000, 1.20000);
    CreateDynamicObject(714, 3541.17480, -325.81036, -18.54585, 0.00000, 0.00000, 121.32000);
    CreateDynamicObject(714, 3546.01929, -359.49893, -18.54585, 0.00000, 0.00000, 121.32000);
    CreateDynamicObject(714, 3538.37231, -294.03519, -14.02169, 0.00000, 0.00000, 76.60000);
    CreateDynamicObject(714, 3488.71313, -283.41895, 26.04790, 0.00000, 0.00000, 70.48000);
    CreateDynamicObject(714, 3443.84961, -288.88229, 14.53269, 0.00000, 0.00000, 67.24000);
    CreateDynamicObject(714, 3437.84961, -305.90485, 26.04790, 0.00000, 0.00000, 66.82000);
    CreateDynamicObject(714, 3516.07690, -294.62018, 17.33046, 0.00000, 0.00000, 76.48000);
    CreateDynamicObject(714, 3477.03711, -319.96307, 42.23977, 0.00000, 0.00000, 77.43334);
    CreateDynamicObject(714, 3497.54956, -280.41168, 7.19306, 0.00000, 0.00000, 75.82000);
    CreateDynamicObject(714, 3461.07446, -294.15790, 34.57137, 0.00000, 0.00000, 75.32040);
    CreateDynamicObject(714, 3452.89648, -277.44064, 12.25192, 0.00000, 0.00000, 75.82000);
    CreateDynamicObject(689, 3528.39429, -212.67311, 6.09927, 0.00000, 0.00000, 3.24000);
    CreateDynamicObject(694, 3514.34766, -323.59897, 37.76574, 0.00000, 0.00000, 333.37750);
    CreateDynamicObject(694, 3510.33496, -303.32855, 31.70929, 0.00000, 0.00000, -27.90000);
    CreateDynamicObject(694, 3482.48999, -272.16791, 33.92820, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(694, 3464.33472, -295.65973, 42.48646, 0.00000, 0.00000, -29.99999);
    CreateDynamicObject(714, 3521.58081, -335.44431, 25.99377, 0.00000, 0.00000, 76.60000);
    CreateDynamicObject(714, 3478.57837, -346.64948, 35.90334, 0.00000, 0.00000, 77.73335);
    CreateDynamicObject(694, 3513.71118, -346.48892, 37.63630, 0.00000, 0.00000, 333.44968);
    CreateDynamicObject(694, 3481.72949, -346.07263, 37.63630, 0.00000, 0.00000, 333.68967);
    CreateDynamicObject(694, 3446.95825, -341.94571, 32.00459, 0.00000, 0.00000, 338.27911);
    CreateDynamicObject(694, 3450.50000, -314.83972, 44.91550, 0.00000, 0.00000, 334.82965);
    CreateDynamicObject(714, 3425.40234, -334.30374, 12.79645, 0.00000, 0.00000, 77.52518);
    CreateDynamicObject(694, 3418.05688, -324.51553, 20.46452, 0.00000, 0.00000, 334.52966);
    CreateDynamicObject(694, 3496.07031, -291.02750, 50.70860, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(714, 3451.67822, -347.30362, 35.69723, 0.00000, 0.00000, 77.52929);
    CreateDynamicObject(714, 3498.10742, -353.21851, 26.14636, 0.00000, 0.00000, 76.68929);
    CreateDynamicObject(689, 3497.29419, -354.42584, 58.84648, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(726, 3469.78003, -364.99875, 57.15409, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(694, 3358.73511, -290.51709, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(694, 3265.92603, -335.02664, 5.46833, 0.00000, 0.00000, -28.38000);
    CreateDynamicObject(689, 3299.75488, -321.93063, 6.09927, 0.00000, 0.00000, 3.30000);
    CreateDynamicObject(714, 3459.24829, -359.92545, 23.06426, 0.00000, 0.00000, 77.52929);
    CreateDynamicObject(16061, 3674.42065, -292.62814, -2.36500, 0.00000, 0.00000, 3.40000);
    CreateDynamicObject(16061, 3492.80225, -381.25549, 32.96240, -40.00000, 0.00000, 187.55360);
    CreateDynamicObject(16061, 3486.60986, -590.87244, -1.74481, 0.00000, 0.00000, 163.00000);
    CreateDynamicObject(16061, 3461.96533, -584.30780, -0.80323, 0.00000, 0.00000, 178.55521);
    CreateDynamicObject(18228, 3525.30396, -586.12396, 3.86016, 0.00000, 0.00000, 336.00000);
    CreateDynamicObject(18228, 3574.19507, -586.92279, 3.86020, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3622.92896, -595.03589, 3.86020, 0.00000, 0.00000, 316.00000);
    CreateDynamicObject(18228, 3670.39844, -581.05865, 3.86020, 0.00000, 0.00000, 345.00000);
    CreateDynamicObject(18228, 3692.55005, -549.79883, 3.86020, 0.00000, 0.00000, 40.00000);
    CreateDynamicObject(18228, 3699.39819, -500.84467, 3.86020, 0.00000, 0.00000, 39.64000);
    CreateDynamicObject(18228, 3707.32642, -450.48840, 3.86020, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(18228, 3700.85254, -406.43857, 3.86020, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(18228, 3677.25171, -368.02231, 3.86020, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(18228, 3636.17017, -361.05789, 3.86020, 0.00000, 0.00000, 135.00000);
    CreateDynamicObject(714, 3664.23560, -363.32135, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3690.24585, -378.66089, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3705.97070, -423.43622, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3707.45654, -456.98682, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3701.92847, -496.14706, -19.04130, 0.00000, 0.00000, 123.48000);
    CreateDynamicObject(714, 3700.91235, -541.59113, -19.04130, 0.00000, 0.00000, 123.66000);
    CreateDynamicObject(714, 3683.76538, -575.60992, -19.04130, 0.00000, 0.00000, 123.66000);
    CreateDynamicObject(714, 3651.31909, -598.31805, -19.04130, 0.00000, 0.00000, 124.14001);
    CreateDynamicObject(714, 3607.29175, -597.60480, -19.04130, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(714, 3560.32178, -597.06982, -19.04130, 0.00000, 0.00000, 34.32000);
    CreateDynamicObject(714, 3514.17505, -593.08765, -19.04130, 0.00000, 0.00000, 34.32000);
    CreateDynamicObject(714, 3524.46216, -609.35553, -19.04130, 0.00000, 0.00000, 34.68000);
    CreateDynamicObject(714, 3709.65161, -592.97772, -19.04130, 0.00000, 0.00000, 123.66000);
    CreateDynamicObject(714, 3712.12866, -512.86877, -19.04130, 0.00000, 0.00000, 123.72000);
    CreateDynamicObject(714, 3729.54761, -471.67072, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3741.46265, -449.71747, -19.04130, 0.00000, 0.00000, 123.42001);
    CreateDynamicObject(714, 3727.61914, -419.84433, -19.04130, 0.00000, 0.00000, 123.30000);
    CreateDynamicObject(714, 3723.01855, -380.06317, -19.04130, 0.00000, 0.00000, 122.82001);
    CreateDynamicObject(714, 3701.59863, -345.87622, -19.04130, 0.00000, 0.00000, 121.62001);
    CreateDynamicObject(714, 3677.49048, -339.36420, -19.04130, 0.00000, 0.00000, 121.62001);
    CreateDynamicObject(683, 3739.20337, -347.47610, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(683, 3696.54785, -335.98270, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(683, 3721.91040, -375.56766, 6.30331, 0.00000, 0.00000, 2.28000);
    CreateDynamicObject(683, 3740.14673, -407.00543, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3752.43555, -433.57620, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3735.93750, -457.23474, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3737.05444, -477.86722, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3720.25122, -490.84674, 6.30331, 0.00000, 0.00000, 2.40000);
    CreateDynamicObject(683, 3731.08032, -526.54291, 6.30331, 0.00000, 0.00000, 2.64000);
    CreateDynamicObject(683, 3737.03760, -560.59082, 6.30331, 0.00000, 0.00000, 2.70000);
    CreateDynamicObject(683, 3736.52026, -580.58081, 6.30331, 0.00000, 0.00000, 2.82000);
    CreateDynamicObject(683, 3718.91772, -598.08099, 6.30331, 0.00000, 0.00000, 2.82000);
    CreateDynamicObject(683, 3709.45923, -579.73993, 6.30331, 0.00000, 0.00000, 2.82000);
    CreateDynamicObject(683, 3696.69751, -607.20422, 6.30331, 0.00000, 0.00000, 2.88000);
    CreateDynamicObject(683, 3678.19458, -599.65430, 6.30331, 0.00000, 0.00000, 2.88000);
    CreateDynamicObject(683, 3647.70337, -609.31158, 6.30331, 0.00000, 0.00000, 2.88000);
    CreateDynamicObject(683, 3622.20605, -611.56165, 6.30331, 0.00000, 0.00000, 2.94000);
    CreateDynamicObject(683, 3570.87158, -611.26001, 6.30331, 0.00000, 0.00000, 3.06000);
    CreateDynamicObject(683, 3541.02295, -605.70068, 6.30331, 0.00000, 0.00000, 3.06000);
    CreateDynamicObject(683, 3508.17139, -615.50098, 6.30331, 0.00000, 0.00000, 3.48000);
    CreateDynamicObject(709, 3525.77490, -612.77032, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3720.15186, -594.83997, 4.63770, 0.00000, 0.00000, -50.06000);
    CreateDynamicObject(709, 3709.23022, -534.91107, 4.63770, 0.00000, 0.00000, -50.06000);
    CreateDynamicObject(709, 3743.20923, -460.03940, 4.63770, 0.00000, 0.00000, -50.18000);
    CreateDynamicObject(709, 3738.00122, -401.73486, 4.63770, 0.00000, 0.00000, -53.36000);
    CreateDynamicObject(709, 3706.74121, -343.43057, 4.63770, 0.00000, 0.00000, -54.14000);
    CreateDynamicObject(694, 3734.11792, -364.50122, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(694, 3752.67554, -437.44659, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(694, 3724.78955, -501.24161, 5.46833, 0.00000, 0.00000, -21.12000);
    CreateDynamicObject(694, 3731.34106, -559.67578, 5.46833, 0.00000, 0.00000, -21.06000);
    CreateDynamicObject(694, 3689.31079, -599.14191, 5.46833, 0.00000, 0.00000, -21.00000);
    CreateDynamicObject(694, 3655.56030, -604.03638, 5.46833, 0.00000, 0.00000, -20.82000);
    CreateDynamicObject(694, 3599.36523, -608.40393, 5.46833, 0.00000, 0.00000, -20.76000);
    CreateDynamicObject(694, 3561.44116, -606.67181, 5.46833, 0.00000, 0.00000, -20.64000);
    CreateDynamicObject(19952, 3315.33276, -509.92502, 123.09140, 0.00000, 0.00000, 176.30479);
    CreateDynamicObject(19952, 3312.64087, -509.51053, 123.09140, 0.00000, 0.00000, 154.12303);
    CreateDynamicObject(19952, 3310.60156, -508.20358, 123.09140, 0.00000, 0.00000, 136.57768);
    CreateDynamicObject(19952, 3309.09082, -506.46124, 123.09140, 0.00000, 0.00000, 123.75571);
    CreateDynamicObject(19952, 3308.22119, -504.26544, 123.09140, 0.00000, 0.00000, 106.49351);
    CreateDynamicObject(978, 3307.99780, -497.69940, 125.55900, 0.00000, 0.00000, -90.00000);
    CreateDynamicObject(978, 3309.07251, -486.65302, 125.55900, 0.00000, 0.00000, -100.00000);
    CreateDynamicObject(978, 3312.70435, -475.18909, 125.55900, 0.00000, 0.00000, -113.00000);
    CreateDynamicObject(979, 3317.87622, -494.59329, 125.55900, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(979, 3321.00952, -482.61069, 125.55900, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(978, 3319.85059, -464.32990, 125.55900, 0.00000, 0.00000, -130.00000);
    CreateDynamicObject(979, 3328.20483, -471.39471, 125.55900, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(978, 3329.60645, -455.04340, 125.55900, 0.00000, 0.00000, -139.00000);
    CreateDynamicObject(979, 3338.37378, -462.12210, 125.55900, 0.00000, 0.00000, 38.00000);
    CreateDynamicObject(978, 3341.41187, -445.64001, 125.55900, 0.00000, 0.00000, -142.00000);
    CreateDynamicObject(979, 3348.55103, -453.79050, 125.55900, 0.00000, 0.00000, 38.00000);
    CreateDynamicObject(978, 3354.31201, -436.10059, 125.55900, 0.00000, 0.00000, -148.00000);
    CreateDynamicObject(979, 3359.87012, -444.82211, 125.55900, 0.00000, 0.00000, 37.94000);
    CreateDynamicObject(978, 3367.24316, -429.11768, 125.55900, 0.00000, 0.00000, -156.00000);
    CreateDynamicObject(979, 3371.89038, -437.21027, 125.55900, 0.00000, 0.00000, 25.00000);
    CreateDynamicObject(979, 3383.58081, -432.67657, 125.55900, 0.00000, 0.00000, 18.00000);
    CreateDynamicObject(978, 3379.75049, -424.92807, 125.55900, 0.00000, 0.00000, -164.00000);
    CreateDynamicObject(978, 3393.22876, -421.75726, 125.55900, 0.00000, 0.00000, -171.00000);
    CreateDynamicObject(979, 3397.46313, -429.58295, 125.55900, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(978, 3406.99585, -420.09274, 125.55900, 0.00000, 0.00000, -178.00000);
    CreateDynamicObject(979, 3410.35840, -428.42984, 125.55900, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(978, 3418.99780, -419.67706, 125.55900, 0.00000, 0.00000, -178.00000);
    CreateDynamicObject(979, 3420.11548, -427.30756, 125.55900, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(978, 3429.10693, -419.57822, 125.55900, 0.00000, 0.00000, -178.06000);
    CreateDynamicObject(979, 3429.64453, -425.46512, 125.55900, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(978, 3439.21753, -419.93997, 125.55900, 0.00000, 0.00000, -185.00000);
    CreateDynamicObject(979, 3439.27466, -424.12289, 125.55900, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(714, 3248.35596, -448.66687, -19.62880, 0.00000, 0.00000, 76.12000);
    CreateDynamicObject(16061, 3164.59741, -480.09735, -2.36500, 0.00000, 0.00000, 222.00000);
    CreateDynamicObject(16061, 3328.99902, -442.66461, 116.69705, 0.00000, 0.00000, 133.21693);
    CreateDynamicObject(16061, 3378.29297, -415.28802, 116.69705, 0.00000, 0.00000, 105.39956);
    CreateDynamicObject(16061, 3415.61426, -411.23792, 116.69705, 0.00000, 0.00000, 94.51708);
    CreateDynamicObject(16061, 3345.52075, -472.05954, 116.69705, 0.00000, 0.00000, 133.27257);
    CreateDynamicObject(16061, 3355.61279, -461.64948, 116.69705, 0.00000, 0.00000, 128.96484);
    CreateDynamicObject(16061, 3393.64111, -444.84039, 116.69705, 0.00000, 0.00000, 102.41914);
    CreateDynamicObject(16061, 3413.68286, -436.89828, 116.69705, 0.00000, 0.00000, 277.15933);
    CreateDynamicObject(714, 3241.81714, -496.41891, -19.62880, 0.00000, 0.00000, 76.18000);
    CreateDynamicObject(709, 3299.50513, -259.22632, 4.63770, 0.00000, 0.00000, -49.58000);
    CreateDynamicObject(709, 3332.45361, -443.57843, 124.34824, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(708, 3308.41138, -472.26447, 124.34820, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(708, 3365.80420, -408.91019, 124.34820, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(706, 3313.68652, -431.89249, 120.45879, 0.00000, 0.00000, 0.66000);
    CreateDynamicObject(706, 3341.82251, -413.04453, 120.45880, 0.00000, 0.00000, 62.00000);
    CreateDynamicObject(726, 3493.44507, -374.56384, 50.46271, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(726, 3470.60034, -385.53989, 38.30498, 0.00000, 0.00000, 62.00000);
    CreateDynamicObject(726, 3493.44507, -374.56384, 50.46271, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(726, 3485.70483, -360.53946, 59.60125, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(726, 3464.75854, -376.03271, 50.46270, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(726, 3493.73975, -383.54999, 38.30500, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(726, 3494.96289, -391.64050, 43.07665, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(726, 3472.54736, -401.44885, 23.61716, 0.00000, 0.00000, 142.00000);
    CreateDynamicObject(706, 3310.85718, -391.89178, 120.45879, 0.00000, 0.00000, 0.66000);
    CreateDynamicObject(706, 3294.60742, -412.78113, 120.45879, 0.00000, 0.00000, 0.66000);
    CreateDynamicObject(709, 3295.20776, -511.54504, 124.34824, 0.00000, 0.00000, 2.52000);
    CreateDynamicObject(709, 3412.47437, -413.27725, 124.34820, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(708, 3366.75317, -421.60617, 124.34820, 0.00000, 0.00000, -0.42000);
    CreateDynamicObject(708, 3308.41138, -472.26447, 124.34820, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(708, 3390.40869, -415.03860, 124.34820, 0.00000, 0.00000, -1.32000);
    CreateDynamicObject(709, 3393.67456, -473.83994, 124.34824, 0.00000, 0.00000, -0.42000);
    CreateDynamicObject(709, 3442.75244, -433.48660, 124.34820, 0.00000, 0.00000, -135.00000);
    CreateDynamicObject(709, 3332.80664, -480.50656, 124.34824, 0.00000, 0.00000, -0.36000);
    CreateDynamicObject(708, 3369.64722, -472.36612, 124.34820, 0.00000, 0.00000, -0.42000);
    CreateDynamicObject(708, 3429.23853, -438.44431, 124.34820, 0.00000, 0.00000, -0.42000);
    CreateDynamicObject(708, 3313.20361, -518.22479, 124.34820, 0.00000, 0.00000, -0.42000);
    CreateDynamicObject(713, 3443.24951, -417.02753, 124.19423, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16061, 3433.70215, -511.87799, 116.69705, 0.00000, 0.00000, 1.90744);
    CreateDynamicObject(16061, 3420.45898, -518.56049, 116.69705, 0.00000, 0.00000, 337.53632);
    CreateDynamicObject(16061, 3411.03613, -464.88092, 116.69705, 0.00000, 0.00000, 264.11331);
    CreateDynamicObject(16061, 3402.29468, -449.69495, 116.69705, 0.00000, 0.00000, 263.45331);
    CreateDynamicObject(16061, 3389.27490, -473.74149, 116.69705, 0.00000, 0.00000, 263.51331);
    CreateDynamicObject(708, 3436.40942, -497.01166, 124.34820, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(713, 3433.40015, -467.66949, 126.64586, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(713, 3373.33325, -448.52820, 126.64586, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(709, 3431.46924, -524.02960, 124.34824, 0.00000, 0.00000, -0.48000);
    CreateDynamicObject(706, 3435.73267, -484.18240, 127.73022, 0.00000, 0.00000, 0.66000);
    CreateDynamicObject(713, 3437.15820, -408.72498, 126.64586, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16061, 3403.95410, -399.64532, 116.69705, 0.00000, 0.00000, 94.51708);
    CreateDynamicObject(16061, 3349.80029, -397.57932, 116.69705, 0.00000, 0.00000, 93.67709);
    CreateDynamicObject(16061, 3330.61011, -415.22211, 116.69705, 0.00000, 0.00000, 93.67709);
    CreateDynamicObject(16061, 3300.59912, -415.37097, 116.69705, 0.00000, 0.00000, 171.50267);
    CreateDynamicObject(16061, 3312.25195, -413.25534, 116.69705, 0.00000, 0.00000, 171.50267);
    CreateDynamicObject(713, 3331.89063, -511.00540, 135.69971, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(713, 3341.91064, -504.68729, 143.30521, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(979, 3529.37451, -426.73853, 125.55900, 0.00000, 0.00000, -25.00000);
    CreateDynamicObject(978, 3529.80566, -421.63019, 125.55900, 0.00000, 0.00000, 164.00000);
    CreateDynamicObject(978, 3539.92480, -426.29208, 125.55900, 0.00000, 0.00000, 149.00000);
    CreateDynamicObject(19952, 3544.56860, -429.26700, 123.00300, 0.00000, 0.00000, -62.00000);
    CreateDynamicObject(19952, 3545.21411, -431.21286, 123.00300, 0.00000, 0.00000, -98.00000);
    CreateDynamicObject(19952, 3545.00439, -430.15100, 123.00300, 0.00000, 0.00000, -76.00000);
    CreateDynamicObject(18228, 3557.30933, -414.33029, 116.65660, 10.00000, 0.00000, 295.00000);
    CreateDynamicObject(19951, 3534.72168, -429.21555, 123.00300, 0.00000, 0.00000, 156.00000);
    CreateDynamicObject(19951, 3536.66846, -430.29800, 123.00300, 0.00000, 0.00000, 149.00000);
    CreateDynamicObject(18228, 3570.11279, -450.74567, 116.65660, 10.00000, 0.00000, 295.00000);
    CreateDynamicObject(18228, 3602.53027, -421.38345, 121.39780, 0.00000, 0.00000, 345.00000);
    CreateDynamicObject(18228, 3633.90015, -497.71689, 121.39780, 0.00000, 0.00000, 251.00000);
    CreateDynamicObject(18228, 3592.33936, -512.81659, 121.39780, 0.00000, 0.00000, 302.72000);
    CreateDynamicObject(18228, 3627.80542, -542.16138, 121.39780, 0.00000, 0.00000, 303.01999);
    CreateDynamicObject(18228, 3575.14160, -539.16052, 121.39780, 0.00000, 0.00000, 303.01999);
    CreateDynamicObject(18228, 3635.36377, -449.73715, 121.39780, 0.00000, 0.00000, 301.64001);
    CreateDynamicObject(16061, 3568.11499, -448.68970, 116.69705, 0.00000, 0.00000, 1.96744);
    CreateDynamicObject(16061, 3606.21411, -528.64502, 116.69710, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(16061, 3597.61841, -554.52899, 116.69710, 0.00000, 0.00000, 76.00000);
    CreateDynamicObject(18228, 3543.57544, -533.11279, 123.39390, 0.00000, 0.00000, 324.00000);
    CreateDynamicObject(16061, 3541.37207, -542.62866, 116.69710, 0.00000, 0.00000, 98.00000);
    CreateDynamicObject(709, 3537.84570, -537.80011, 124.34824, 0.00000, 0.00000, 16.98000);
    CreateDynamicObject(709, 3578.07104, -441.50723, 124.34824, 0.00000, 0.00000, 17.40000);
    CreateDynamicObject(709, 3642.78540, -446.70197, 124.34824, 0.00000, 0.00000, 17.34000);
    CreateDynamicObject(706, 3609.82080, -448.99832, 127.73022, 0.00000, 0.00000, 0.66000);
    CreateDynamicObject(706, 3581.43726, -530.59210, 127.73022, 0.00000, 0.00000, 1.08000);
    CreateDynamicObject(706, 3629.56641, -527.50275, 127.73022, 0.00000, 0.00000, 0.90000);
    CreateDynamicObject(16061, 3548.43823, -420.55099, 116.69710, 0.00000, 0.00000, 62.00000);
    CreateDynamicObject(706, 3549.40161, -425.23898, 118.50067, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(16061, 3543.30713, -529.08447, 119.52142, 0.00000, 0.00000, 62.00000);
    CreateDynamicObject(706, 3517.29175, -509.57391, 121.26136, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(979, 3346.38770, -352.01910, 58.14630, 0.00000, 0.00000, 176.00000);
    CreateDynamicObject(19951, 3356.13013, -358.29779, 55.36610, 0.00000, 0.00000, -76.00000);
    CreateDynamicObject(19951, 3355.66211, -356.54260, 55.36610, 0.00000, 0.00000, -62.00000);
    CreateDynamicObject(19951, 3354.52979, -354.43579, 55.36610, 0.00000, 0.00000, -47.00000);
    CreateDynamicObject(19951, 3352.87305, -353.07819, 55.36610, 0.00000, 0.00000, -33.00000);
    CreateDynamicObject(979, 3320.48315, -351.32312, 58.14630, 0.00000, 0.00000, 184.00000);
    CreateDynamicObject(979, 3300.14551, -355.18137, 58.14630, 0.00000, 0.00000, 207.00000);
    CreateDynamicObject(979, 3281.84839, -361.85919, 58.14630, 0.00000, 0.00000, 191.00000);
    CreateDynamicObject(979, 3269.10986, -367.70218, 58.14630, 0.00000, 0.00000, 218.00000);
    CreateDynamicObject(979, 3261.48877, -378.87717, 58.14630, 0.00000, 0.00000, 262.00000);
    CreateDynamicObject(979, 3264.92090, -448.94037, 58.14630, 0.00000, 0.00000, 297.00000);
    CreateDynamicObject(979, 3270.69922, -478.74490, 58.14630, 0.00000, 0.00000, 262.00000);
    CreateDynamicObject(19951, 3269.05469, -485.91861, 55.33140, 0.00000, 0.00000, 105.00000);
    CreateDynamicObject(19951, 3269.58789, -487.34000, 55.33140, 0.00000, 0.00000, 113.00000);
    CreateDynamicObject(19951, 3270.49146, -489.56851, 55.33140, 0.00000, 0.00000, 127.00000);
    CreateDynamicObject(19951, 3271.80273, -490.94070, 55.33140, 0.00000, 0.00000, 135.00000);
    CreateDynamicObject(19951, 3462.79663, -432.74048, 79.44141, 0.00000, 0.00000, 200.23967);
    CreateDynamicObject(19951, 3464.38940, -432.04019, 79.44140, 0.00000, 0.00000, 215.00000);
    CreateDynamicObject(19951, 3465.75513, -430.97699, 79.44140, 0.00000, 0.00000, 229.00000);
    CreateDynamicObject(19951, 3466.71387, -429.42010, 79.44140, 0.00000, 0.00000, 244.00000);
    CreateDynamicObject(19951, 3467.64868, -427.78949, 79.44140, 0.00000, 0.00000, 258.00000);
    CreateDynamicObject(979, 3467.59473, -422.54111, 82.15290, 0.00000, 0.00000, 91.00000);
    CreateDynamicObject(979, 3465.11523, -406.26862, 82.15290, 0.00000, 0.00000, 97.00000);
    CreateDynamicObject(979, 3460.06665, -388.41321, 82.15290, 0.00000, 0.00000, 110.00000);
    CreateDynamicObject(19951, 3457.68188, -383.51620, 79.53010, 0.00000, 0.00000, -33.00000);
    CreateDynamicObject(19951, 3455.29614, -381.13181, 79.53010, 0.00000, 0.00000, -25.00000);
    CreateDynamicObject(19951, 3456.51025, -382.34631, 79.53010, 0.00000, 0.00000, -33.00000);
    CreateDynamicObject(19951, 3453.77832, -380.00891, 79.53010, 0.00000, 0.00000, -18.00000);
    CreateDynamicObject(19951, 3452.05957, -379.05258, 79.53010, 0.00000, 0.00000, -11.00000);
    CreateDynamicObject(19951, 3450.09204, -378.51880, 79.53010, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(19951, 3448.14673, -379.33240, 79.53010, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(19952, 3666.98779, -563.64832, 79.38060, 0.00000, 0.00000, -55.00000);
    CreateDynamicObject(19952, 3667.89941, -565.49054, 79.38060, 0.00000, 0.00000, -76.00000);
    CreateDynamicObject(19952, 3667.67603, -567.87842, 79.38060, 0.00000, 0.00000, -105.00000);
    CreateDynamicObject(19952, 3666.78271, -569.98029, 79.38060, 0.00000, 0.00000, -113.00000);
    CreateDynamicObject(978, 3657.98291, -576.40936, 82.13530, 0.00000, 0.00000, 20.00000);
    CreateDynamicObject(19952, 3665.63135, -571.64093, 79.38060, 0.00000, 0.00000, -135.00000);
    CreateDynamicObject(19952, 3663.97339, -573.23535, 79.38060, 0.00000, 0.00000, -135.00000);
    CreateDynamicObject(978, 3643.74878, -580.72858, 82.13530, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(978, 3626.11816, -583.46429, 82.13530, 0.00000, 0.00000, 2.00000);
    CreateDynamicObject(19952, 3619.60522, -583.52185, 79.38060, 0.00000, 0.00000, -200.00000);
    CreateDynamicObject(19952, 3617.13281, -582.44171, 79.38060, 0.00000, 0.00000, -215.00000);
    CreateDynamicObject(19952, 3614.96997, -580.83020, 79.38060, 0.00000, 0.00000, -244.00000);
    CreateDynamicObject(19952, 3614.20142, -578.61102, 79.38060, 0.00000, 0.00000, -258.00000);
    CreateDynamicObject(19952, 3557.01514, -387.57440, 55.49985, 0.00000, 0.00000, 37.60539);
    CreateDynamicObject(19952, 3559.50952, -385.60400, 55.49990, 0.00000, 0.00000, 30.00000);
    CreateDynamicObject(19952, 3562.33105, -384.49881, 55.49980, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(978, 3567.57153, -385.76349, 58.06040, 0.00000, 0.00000, 164.00000);
    CreateDynamicObject(978, 3593.45557, -383.80402, 58.06040, 0.00000, 0.00000, 208.00000);
    CreateDynamicObject(978, 3618.98853, -376.30450, 58.06040, 0.00000, 0.00000, 191.00000);
    CreateDynamicObject(978, 3645.61182, -375.14465, 58.06040, 0.00000, 0.00000, 177.00000);
    CreateDynamicObject(978, 3669.91943, -378.03912, 58.06040, 0.00000, 0.00000, 170.00000);
    CreateDynamicObject(978, 3679.98584, -384.56677, 58.06040, 0.00000, 0.00000, 128.00000);
    CreateDynamicObject(978, 3691.65015, -413.94385, 58.06040, 0.00000, 0.00000, 117.00000);
    CreateDynamicObject(978, 3696.87061, -440.39221, 58.06040, 0.00000, 0.00000, 93.00000);
    CreateDynamicObject(978, 3696.28198, -463.11398, 58.06040, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(19952, 3695.05762, -468.83633, 55.70460, 0.00000, 0.00000, 229.00000);
    CreateDynamicObject(19952, 3693.86865, -470.20871, 55.70460, 0.00000, 0.00000, 215.00000);
    CreateDynamicObject(19952, 3691.90454, -471.83289, 55.70460, 0.00000, 0.00000, 200.00000);
    CreateDynamicObject(19952, 3689.84595, -472.58841, 55.70460, 0.00000, 0.00000, 185.00000);
    CreateDynamicObject(19952, 3554.00513, -572.61462, 30.44661, 0.00000, 0.00000, -120.00000);
    CreateDynamicObject(19952, 3552.75366, -574.67603, 30.44660, 0.00000, 0.00000, -142.00000);
    CreateDynamicObject(19952, 3550.68506, -575.88770, 30.44660, 0.00000, 0.00000, -156.00000);
    CreateDynamicObject(19952, 3548.64429, -576.03931, 30.44660, 0.00000, 0.00000, -185.00000);
    CreateDynamicObject(19952, 3546.75928, -575.66022, 30.44660, 0.00000, 0.00000, -193.00000);
    CreateDynamicObject(19952, 3544.86279, -575.25629, 30.44660, 0.00000, 0.00000, -193.00000);
    CreateDynamicObject(978, 3536.35693, -575.53741, 33.18070, 0.00000, 0.00000, 9.00000);
    CreateDynamicObject(978, 3518.01147, -579.18256, 33.18070, 0.00000, 0.00000, 17.00000);
    CreateDynamicObject(978, 3500.91406, -581.54529, 33.18070, 0.00000, 0.00000, -6.00000);
    CreateDynamicObject(978, 3485.12524, -575.38873, 33.18070, 0.00000, 0.00000, -43.00000);
    CreateDynamicObject(978, 3477.86841, -562.13452, 33.18070, 0.00000, 0.00000, -79.00000);
    CreateDynamicObject(978, 3477.31812, -545.53809, 33.18070, 0.00000, 0.00000, -101.00000);
    CreateDynamicObject(978, 3479.57031, -525.89520, 33.18070, 0.00000, 0.00000, -88.00000);
    CreateDynamicObject(978, 3481.56201, -500.04138, 33.18070, 0.00000, 0.00000, -101.00000);
    CreateDynamicObject(978, 3488.55664, -480.97305, 33.18070, 0.00000, 0.00000, -116.00000);
    CreateDynamicObject(19952, 3490.71216, -475.72681, 30.53220, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(19952, 3490.88135, -473.81372, 30.53220, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(19952, 3491.17407, -471.86758, 30.53220, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(19952, 3491.39429, -469.81815, 30.53220, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(19952, 3492.23462, -467.70261, 30.53220, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(19952, 3493.61792, -465.94431, 30.53220, 0.00000, 0.00000, 33.00000);
    CreateDynamicObject(19952, 3495.68848, -464.74088, 30.53220, 0.00000, 0.00000, 25.00000);
    CreateDynamicObject(19952, 3497.52173, -463.94360, 30.53220, 0.00000, 0.00000, 11.00000);
    CreateDynamicObject(978, 3572.15796, -152.47580, 7.66360, 0.00000, 0.00000, -90.06000);
    CreateDynamicObject(979, 3582.40869, -136.82591, 7.66360, 0.00000, 0.00000, 94.00000);
    CreateDynamicObject(979, 3577.90991, -117.36510, 7.66360, 0.00000, 0.00000, 111.00000);
    CreateDynamicObject(979, 3567.70068, -98.68870, 7.66360, 0.00000, 0.00000, 127.00000);
    CreateDynamicObject(979, 3552.86011, -83.73192, 7.66360, 0.00000, 0.00000, 143.00000);
    CreateDynamicObject(979, 3534.33521, -73.47763, 7.66360, 0.00000, 0.00000, 159.00000);
    CreateDynamicObject(979, 3513.24023, -68.75437, 7.66360, 0.00000, 0.00000, 176.00000);
    CreateDynamicObject(978, 3570.32593, -129.53772, 7.66360, 0.00000, 0.00000, -77.00000);
    CreateDynamicObject(978, 3563.75562, -112.48411, 7.66360, 0.00000, 0.00000, -62.00000);
    CreateDynamicObject(978, 3552.69434, -97.89204, 7.66360, 0.00000, 0.00000, -46.00000);
    CreateDynamicObject(978, 3538.40698, -87.30300, 7.66360, 0.00000, 0.00000, -29.00000);
    CreateDynamicObject(978, 3521.28320, -80.90249, 7.66360, 0.00000, 0.00000, -12.00000);
    CreateDynamicObject(978, 3370.44238, -79.47590, 7.66360, 0.00000, 0.00000, 4.00000);
    CreateDynamicObject(979, 3349.02905, -72.96180, 7.66360, 0.00000, 0.00000, 202.00000);
    CreateDynamicObject(978, 3336.17383, -92.55570, 7.66360, 0.00000, 0.00000, 37.00000);
    CreateDynamicObject(979, 3315.21387, -98.05710, 7.66360, 0.00000, 0.00000, 234.00000);
    CreateDynamicObject(978, 3314.99048, -120.80050, 7.66360, 0.00000, 0.00000, 69.00000);
    CreateDynamicObject(979, 3299.70923, -137.69583, 7.66360, 0.00000, 0.00000, 265.00000);
    CreateDynamicObject(978, 3308.38989, -160.79083, 7.66360, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(979, 3291.45874, -174.77879, 7.66360, 0.00000, 0.00000, 241.00000);
    CreateDynamicObject(978, 3288.39380, -196.90881, 7.66360, 0.00000, 0.00000, 44.00000);
    CreateDynamicObject(979, 3266.24097, -199.94850, 7.66360, 0.00000, 0.00000, 210.00000);
    CreateDynamicObject(978, 3251.35986, -217.25690, 7.66360, 0.00000, 0.00000, 13.00000);
    CreateDynamicObject(979, 3229.73779, -208.53825, 7.66360, 0.00000, 0.00000, 184.00000);
    CreateDynamicObject(978, 3211.70020, -223.82629, 7.66360, 0.00000, 0.00000, 21.00000);
    CreateDynamicObject(979, 3190.02002, -223.44698, 7.66360, 0.00000, 0.00000, 217.00000);
    CreateDynamicObject(978, 3183.55127, -245.29881, 7.66360, 0.00000, 0.00000, 53.00000);
    CreateDynamicObject(979, 3164.90601, -256.11990, 7.66360, 0.00000, 0.00000, 249.00000);
    CreateDynamicObject(978, 3170.86743, -278.86716, 7.66360, 0.00000, 0.00000, 84.00000);
    CreateDynamicObject(979, 3159.59619, -297.48358, 7.66360, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(979, 3159.63574, -325.57550, 7.66360, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(978, 3170.35010, -311.66531, 7.66360, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(978, 3170.39355, -351.18323, 7.66360, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(979, 3159.74780, -376.34052, 7.66360, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(978, 3170.49780, -394.65421, 7.66360, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(979, 3161.46484, -418.30121, 7.66360, 0.00000, 0.00000, 282.00000);
    CreateDynamicObject(978, 3178.67163, -433.35596, 7.66360, 0.00000, 0.00000, 119.00000);
    CreateDynamicObject(979, 3181.80444, -455.42380, 7.66360, 0.00000, 0.00000, 315.00000);
    CreateDynamicObject(978, 3203.50024, -458.37460, 7.66360, 0.00000, 0.00000, 151.00000);
    CreateDynamicObject(1571, 3588.77759, -203.41051, 8.01600, 0.00000, 0.00000, 273.00000);
    CreateDynamicObject(11712, 3229.05566, -414.14655, 4.08420, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11712, 3229.27271, -414.10818, 4.10420, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11712, 3229.72925, -414.34299, 4.04420, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19897, 3229.35693, -414.20322, 4.00970, -22.00000, -8.00000, 156.00000);
    CreateDynamicObject(19896, 3229.48364, -414.43378, 4.02970, 36.74000, -23.84000, 18.00000);
    CreateDynamicObject(19824, 3229.37231, -414.36310, 3.94970, -3.10000, 2.74000, 156.00000);
    CreateDynamicObject(868, 3229.18994, -414.06201, 3.35810, 0.00000, 0.00000, 78.00000);
    CreateDynamicObject(1933, 3229.14966, -414.30240, 3.93670, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1933, 3229.35449, -413.97830, 4.01670, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1933, 3229.66895, -414.28580, 3.95670, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3127.02319, -437.78073, -1.18628, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3472.65991, -596.69702, 6.91724, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3485.34375, -410.24057, 7.46136, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3483.95386, -411.13556, 7.46088, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3485.04956, -400.14667, 15.71092, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3482.90332, -411.32022, 8.86693, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3469.61792, -620.48340, -4.01427, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(979, 3461.08105, -561.50610, 33.09500, 0.00000, 0.00000, 47.00000);
    CreateDynamicObject(18671, 3127.02319, -437.78073, -1.18628, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3472.65991, -596.69702, 6.91724, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3485.34375, -410.24057, 7.46136, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3483.95386, -411.13556, 7.46088, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3485.04956, -400.14667, 15.71092, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3482.90332, -411.32022, 8.86693, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 3469.61792, -620.48340, -4.01427, 0.00000, 0.00000, 0.00000);

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

    // PRAÇA POSTO / LANCHONETE
    CreateObject(715, 1953.9000000, -1795.8000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (1)
    CreateObject(715, 1952.6000000, -1780.6000000, 20.5000000, 0.0000000, 0.0000000, 254.0000000); //object(veg_bevtree3) (2)
    CreateObject(715, 1937.0000000, -1796.1000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (3)
    CreateObject(715, 1911.0000000, -1795.8000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (4)
    CreateObject(715, 1907.0000000, -1768.9000000, 20.5500000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (5)
    CreateObject(715, 1934.9000000, -1762.2000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (6)
    CreateObject(715, 1953.2000000, -1761.5000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (7)
    CreateObject(1446, 1908.2000000, -1790.0000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (2)
    CreateObject(1446, 1908.2000000, -1785.3000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (3)
    CreateObject(4199, 1945.6000000, -1813.6000000, 14.7000000, 0.0000000, 0.0000000, 180.0000000); //object(garages1_lan) (1)
    CreateObject(1446, 1913.8000000, -1795.6000000, 13.3900000, 0.0000000, 0.0000000, 134.0000000); //object(dyn_f_r_wood_4) (5)
    CreateObject(1446, 1910.2000000, -1792.8000000, 13.4000000, 0.0000000, 0.0000000, 149.9980000); //object(dyn_f_r_wood_4) (6)
    CreateObject(1446, 1908.3000000, -1780.6888000, 13.3000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (7)
    CreateObject(1446, 1908.1000000, -1794.6000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (8)
    CreateObject(1446, 1904.0000000, -1768.7000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (10)
    CreateObject(1446, 1903.9000000, -1791.3000000, 13.4000000, 0.0000000, 0.0000000, 85.9990000); //object(dyn_f_r_wood_4) (11)
    CreateObject(1446, 1904.0000000, -1787.0996000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (12)
    CreateObject(1446, 1904.0000000, -1782.5000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (13)
    CreateObject(1446, 1904.0000000, -1777.9004000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (14)
    CreateObject(1446, 1904.0000000, -1773.2998000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (15)
    CreateObject(1446, 1904.0000000, -1764.2000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (16)
    CreateObject(1446, 1906.1000000, -1761.7000000, 13.4000000, 0.0000000, 0.0000000, 188.0000000); //object(dyn_f_r_wood_4) (17)
    CreateObject(1446, 1913.0000000, -1797.3000000, 13.4000000, 0.0000000, 0.0000000, 180.0000000); //object(dyn_f_r_wood_4) (18)
    CreateObject(1446, 1908.4000000, -1797.3000000, 13.4000000, 0.0000000, 0.0000000, 179.9950000); //object(dyn_f_r_wood_4) (19)
    CreateObject(1446, 1904.8000000, -1795.4000000, 13.4000000, 0.0000000, 0.0000000, 125.9990000); //object(dyn_f_r_wood_4) (20)
    CreateObject(1446, 1901.5000000, -1791.4000000, 13.4000000, 0.0000000, 0.0000000, 359.9950000); //object(dyn_f_r_wood_4) (21)
    CreateObject(3521, 1951.8000000, -1770.5000000, 14.1000000, 0.0000000, 0.0000000, 90.0000000); //object(vgsn_rbstiff) (1)
    CreateObject(1446, 1908.3000500, -1772.9000200, 13.3900000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (22)
    CreateObject(1446, 1908.3000500, -1763.6999500, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (23)
    CreateObject(1446, 1908.3000500, -1768.3000500, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (24)
    CreateObject(1446, 1901.7998000, -1762.2002000, 13.4000000, 0.0000000, 0.0000000, 187.9980000); //object(dyn_f_r_wood_4) (25)
    CreateObject(3256, 1868.3000000, -1804.8000000, 12.5000000, 0.0000000, 0.0000000, 0.0000000); //object(refchimny01) (1)
    CreateObject(3567, 1851.3000000, -1801.8000000, 13.4000000, 0.0000000, 0.0000000, 266.0000000); //object(lasnfltrail) (1)
    CreateObject(2921, 1914.3000000, -1771.8000000, 16.0000000, 0.0000000, 0.0000000, 0.0000000); //object(kmb_cam) (1)
    CreateObject(2921, 1929.6000000, -1765.5000000, 15.8000000, 0.0000000, 0.0000000, 226.0000000); //object(kmb_cam) (2)
    //segunda parte
    CreateObject(715, 1953.9000000, -1795.8000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (1)
    CreateObject(715, 1952.6000000, -1780.6000000, 20.5000000, 0.0000000, 0.0000000, 254.0000000); //object(veg_bevtree3) (2)
    CreateObject(715, 1937.0000000, -1796.1000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (3)
    CreateObject(715, 1911.0000000, -1795.8000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (4)
    CreateObject(715, 1907.0000000, -1768.9000000, 20.5500000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (5)
    CreateObject(715, 1934.9000000, -1762.2000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (6)
    CreateObject(715, 1953.2000000, -1761.5000000, 20.5000000, 0.0000000, 0.0000000, 0.0000000); //object(veg_bevtree3) (7)
    CreateObject(1446, 1908.2000000, -1790.0000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (2)
    CreateObject(1446, 1908.2000000, -1785.3000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (3)
    CreateObject(1446, 1913.8000000, -1795.6000000, 13.3900000, 0.0000000, 0.0000000, 134.0000000); //object(dyn_f_r_wood_4) (5)
    CreateObject(1446, 1910.2000000, -1792.8000000, 13.4000000, 0.0000000, 0.0000000, 149.9980000); //object(dyn_f_r_wood_4) (6)
    CreateObject(1446, 1908.3000000, -1780.6888000, 13.3000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (7)
    CreateObject(1446, 1908.1000000, -1794.6000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (8)
    CreateObject(1446, 1904.0000000, -1768.7000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (10)
    CreateObject(1446, 1903.9000000, -1791.3000000, 13.4000000, 0.0000000, 0.0000000, 85.9990000); //object(dyn_f_r_wood_4) (11)
    CreateObject(1446, 1904.0000000, -1787.0996000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (12)
    CreateObject(1446, 1904.0000000, -1782.5000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (13)
    CreateObject(1446, 1904.0000000, -1777.9004000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (14)
    CreateObject(1446, 1904.0000000, -1773.2998000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (15)
    CreateObject(1446, 1904.0000000, -1764.2000000, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (16)
    CreateObject(1446, 1906.1000000, -1761.7000000, 13.4000000, 0.0000000, 0.0000000, 188.0000000); //object(dyn_f_r_wood_4) (17)
    CreateObject(1446, 1913.0000000, -1797.3000000, 13.4000000, 0.0000000, 0.0000000, 180.0000000); //object(dyn_f_r_wood_4) (18)
    CreateObject(1446, 1908.4000000, -1797.3000000, 13.4000000, 0.0000000, 0.0000000, 179.9950000); //object(dyn_f_r_wood_4) (19)
    CreateObject(1446, 1904.8000000, -1795.4000000, 13.4000000, 0.0000000, 0.0000000, 125.9990000); //object(dyn_f_r_wood_4) (20)
    CreateObject(1446, 1901.5000000, -1791.4000000, 13.4000000, 0.0000000, 0.0000000, 359.9950000); //object(dyn_f_r_wood_4) (21)
    CreateObject(3521, 1951.8000000, -1770.5000000, 14.1000000, 0.0000000, 0.0000000, 90.0000000); //object(vgsn_rbstiff) (1)
    CreateObject(1446, 1908.3000500, -1772.9000200, 13.3900000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (22)
    CreateObject(1446, 1908.3000500, -1763.6999500, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (23)
    CreateObject(1446, 1908.3000500, -1768.3000500, 13.4000000, 0.0000000, 0.0000000, 90.0000000); //object(dyn_f_r_wood_4) (24)
    CreateObject(1446, 1901.7998000, -1762.2002000, 13.4000000, 0.0000000, 0.0000000, 187.9980000); //object(dyn_f_r_wood_4) (25)
    CreateObject(2921, 1914.3000000, -1771.8000000, 16.0000000, 0.0000000, 0.0000000, 0.0000000); //object(kmb_cam) (1)
    CreateObject(2921, 1929.0000000, -1766.0000000, 16.0000000, 0.0000000, 0.0000000, 226.0000000); //object(kmb_cam) (2)
    CreateObject(7017, 1915.6000000, -1819.8000000, 12.5000000, 0.0000000, 0.0000000, 348.0000000); //object(circusconstruct07) (1)
    CreateObject(7017, 1868.0000000, -1809.9000000, 12.5000000, 0.0000000, 0.0000000, 347.9970000); //object(circusconstruct07) (2)
    CreateObject(1233, 1828.6000000, -1800.1000000, 14.1000000, 0.0000000, 0.0000000, 278.0000000); //object(noparkingsign1) (1)
    CreateObject(1233, 1828.5996000, -1800.0996000, 14.1000000, 0.0000000, 0.0000000, 277.9980000); //object(noparkingsign1) (2)
    CreateObject(1233, 1828.5000000, -1789.5000000, 14.1000000, 0.0000000, 0.0000000, 277.9980000); //object(noparkingsign1) (3)
    CreateObject(3265, 1807.6000000, -1799.5000000, 22.3000000, 0.0000000, 0.0000000, 0.0000000); //object(privatesign4) (1)
    CreateObject(3265, 1815.0000000, -1792.8000000, 12.5000000, 0.0000000, 0.0000000, 0.0000000); //object(privatesign4) (2)
    CreateObject(3265, 1815.0000000, -1792.3000000, 12.5000000, 0.0000000, 0.0000000, 180.0000000); //object(privatesign4) (3)
    CreateObject(3631, 1953.4000000, -1831.0000000, 13.1000000, 0.0000000, 0.0000000, 90.0000000); //object(oilcrat_las) (1)
    CreateObject(3631, 1953.6000000, -1838.5000000, 13.1000000, 0.0000000, 0.0000000, 90.0000000); //object(oilcrat_las) (2)
    CreateObject(3631, 1953.7000000, -1838.5000000, 14.3000000, 0.0000000, 0.0000000, 90.0000000); //object(oilcrat_las) (3)
    CreateObject(3631, 1953.6000000, -1830.9000000, 14.3000000, 0.0000000, 0.0000000, 90.0000000); //object(oilcrat_las) (4)
    CreateObject(1299, 1953.0000000, -1825.6000000, 13.0000000, 0.0000000, 0.0000000, 0.0000000); //object(smashboxpile) (1)
    CreateObject(2920, 1831.5000000, -1798.8000000, 13.7000000, 325.0000000, 0.0000000, 0.0000000); //object(police_barrier) (1)
    CreateObject(4639, 1831.4000000, -1799.8000000, 14.0000000, 0.0000000, 0.0000000, 0.0000000); //object(paypark_lan02) (1)
    CreateObject(7017, 1914.7000000, -1798.9000000, 12.5000000, 0.0000000, 0.0000000, 359.9970000); //object(circusconstruct07) (3)
    CreateObject(8841, 1931.0000000, -1810.2000000, 15.7000000, 0.0000000, 0.0000000, 356.0000000); //object(rsdncarprk01_lvs) (1)
    CreateObject(10838, 1801.6000000, -1799.5000000, 47.5000000, 0.0000000, 0.0000000, 0.0000000); //object(airwelcomesign_sfse) (1)
    CreateObject(10838, 1960.0000000, -2179.6001000, 30.1000000, 0.0000000, 0.0000000, 90.0000000); //object(airwelcomesign_sfse) (2)
    CreateObject(10401, 2122.0000000, -1776.3000000, 14.7000000, 0.0000000, 0.0000000, 314.0000000); //object(hc_shed02_sfs) (2)
    CreateObject(1684, 2106.1001000, -1780.7000000, 14.0000000, 0.0000000, 0.0000000, 270.0000000); //object(portakabin) (2)
    CreateObject(1684, 2106.1001000, -1770.6999500, 14.0000000, 0.0000000, 0.0000000, 270.0000000); //object(portakabin) (3)
    CreateObject(737, 2098.8999000, -1773.0000000, 12.6000000, 0.0000000, 0.0000000, 0.0000000); //object(aw_streettree3) (1)
    CreateObject(737, 2095.5000000, -1784.8000000, 12.6000000, 0.0000000, 0.0000000, 0.0000000); //object(aw_streettree3) (2)
    CreateObject(737, 2095.1001000, -1826.8000000, 12.6000000, 0.0000000, 0.0000000, 0.0000000); //object(aw_streettree3) (3)
    CreateObject(16322, 1839.1000000, -1744.8000000, 16.6000000, 0.0000000, 0.0000000, 0.0000000); //object(a51_plat) (1)

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


    // HOSPITAL EXTERIOR
    tmpobjid = CreateDynamicObject(5708, 1134.250000, -1338.079956, 23.156299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 2, 6052, "law_doontoon", "sf_window_mod1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 10023, "bigwhitesfe", "archgrnd3_SFE", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 10, 9593, "hosbibalsfw", "2hospital1sfw", 0x00000000);
    tmpobjid = CreateDynamicObject(10308, 1157.477661, -1364.409545, 56.635829, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9593, "hosbibalsfw", "2hospital2sfw", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 1419, "break_fence3", "CJ_FRAME_Glass", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1178.462890, -1338.066162, 18.838443, 90.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1178.462890, -1328.076904, 18.838443, 90.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1178.462890, -1318.136962, 18.838443, 90.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1178.462890, -1308.157958, 18.838443, 90.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1183.441528, -1338.066162, 18.838443, 89.999992, 180.000000, -89.999992, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1183.441528, -1328.076904, 18.838443, 89.999992, 180.000000, -89.999992, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1183.441528, -1318.136962, 18.838443, 89.999992, 180.000000, -89.999992, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 1183.441528, -1308.157958, 18.838443, 89.999992, 180.000000, -89.999992, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1179.907470, -1330.853271, 16.268011, 0.000006, -25.299982, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1182.027099, -1330.853271, 11.783761, 0.000006, -25.299982, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1179.907470, -1315.911132, 16.268011, 0.000006, -25.299989, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1182.027099, -1315.911132, 11.783761, 0.000006, -25.299989, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1182.857543, -1330.873291, 16.268011, 0.000014, -25.299997, 179.999832, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1180.737915, -1330.873291, 11.783761, 0.000014, -25.299997, 179.999832, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1182.857543, -1315.931152, 16.268011, 0.000014, -25.299989, 179.999877, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1180.737915, -1315.931152, 11.783761, 0.000014, -25.299989, 179.999877, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "cof_wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1179.196289, -1300.468994, 15.835627, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1179.226318, -1295.596801, 15.835627, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1174.395996, -1305.258789, 15.835627, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1171.195922, -1305.408935, 15.835627, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1172.795776, -1316.568481, 12.455627, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1171.095458, -1318.219116, 12.455627, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1171.165649, -1329.379516, 12.455627, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1172.905639, -1334.159057, 12.455627, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1172.905639, -1343.768676, 12.455627, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1181.015380, -1367.477905, 14.915632, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1171.385009, -1367.477905, 14.915632, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1171.385009, -1367.477905, 14.915632, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1185.775268, -1372.267700, 14.915632, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19446, 1185.795288, -1380.338012, 14.915632, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1316.129150, 13.066863, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1315.398437, 13.066863, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1314.677734, 13.066863, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1318.379394, 13.066863, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1317.648681, 13.066863, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1316.927978, 13.066863, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1335.401367, 13.066863, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1334.670654, 13.066863, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1333.949951, 13.066863, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1333.351074, 13.066863, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1332.620361, 13.066863, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1331.899658, 13.066863, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1330.981323, 13.066863, 0.000000, 0.000029, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1330.250610, 13.066863, 0.000000, 0.000029, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19121, 1185.724731, -1329.529907, 13.066863, 0.000000, 0.000029, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFF00);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFFFFF00);
    tmpobjid = CreateDynamicObject(19360, 1177.995361, -1320.292358, 13.115905, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1174.775878, -1320.292358, 13.115905, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1174.922363, -1320.292358, 13.641597, 0.000000, 113.700050, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1181.202514, -1320.312377, 12.522999, 0.000000, 113.600074, -0.899999, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1171.755737, -1320.302368, 14.385908, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1177.236694, -1320.323486, 13.224118, 180.000000, 90.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} AREA DE", 130, "Arial", 50, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1177.757080, -1320.323486, 13.224118, 180.000000, 90.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} EMERGENCIA", 130, "Arial", 50, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(932, 1181.186767, -1318.295532, 12.576631, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(932, 1181.186767, -1317.405517, 12.576631, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(13725, 1163.968505, -1324.072998, 20.338439, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 9593, "hosbibalsfw", "2hospital2sfw", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1185.041015, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.052001, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.062011, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.072021, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.082031, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.092041, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.102050, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.112060, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.122070, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.132080, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.142089, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.152099, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.162109, -1355.456054, 38.412376, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} H", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.162109, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.172119, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.182128, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.192138, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.202148, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.212158, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.222167, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.232177, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.232177, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.242187, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.252197, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.252197, -1355.456054, 35.262371, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} O", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.062011, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.072021, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.082031, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.092041, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.102050, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.112060, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.122070, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.132080, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.142089, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.152099, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.162109, -1355.456054, 31.752388, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} S", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.162109, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.172119, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.182128, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.192138, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.202148, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.212158, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.222167, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.232177, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.242187, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.252197, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.262207, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272216, -1355.456054, 28.522386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} P", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272216, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272216, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272216, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.242309, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.242309, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.282226, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.282226, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.282226, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.252319, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.252319, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.292236, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.292236, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.292236, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.262329, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.262329, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.302246, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.302246, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.302246, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272338, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.272338, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312255, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312255, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312255, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.282348, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.282348, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.322265, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.322265, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.322265, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.292358, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.292358, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.332275, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.332275, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.332275, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.302368, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.302368, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312377, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312377, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1356.106079, 25.192382, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1355.835815, 22.062391, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} T", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342285, -1355.805786, 19.462402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} A", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312377, -1353.186035, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312377, -1350.556274, 17.962379, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000080} I", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.312377, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.322387, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.332397, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.342407, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.352416, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.362426, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.372436, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.382446, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.392456, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1185.402465, -1350.566284, 28.102380, 90.000000, 180.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000} +", 50, "Arial", 100, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(14793, 1181.271972, -1326.158325, 18.247766, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1419, "break_fence3", "CJ_FRAME_Glass", 0x00000000);
    tmpobjid = CreateDynamicObject(14793, 1181.291992, -1337.299438, 18.247766, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1419, "break_fence3", "CJ_FRAME_Glass", 0x00000000);
    tmpobjid = CreateDynamicObject(14793, 1181.271972, -1314.519165, 18.247766, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1419, "break_fence3", "CJ_FRAME_Glass", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1185.958862, -1324.300537, 18.858440, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000000} HOSPITAL CENTRAL", 120, "Quartz MS", 60, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19378, 1120.928833, -1333.461547, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1120.928833, -1323.831909, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1120.928833, -1314.211669, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1333.461547, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1323.831909, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1314.211669, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.885375, -1333.461547, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.885375, -1323.831909, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.885375, -1314.211669, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.364990, -1333.461547, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.364990, -1323.831909, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.364990, -1314.211669, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1110.459838, -1333.461547, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1110.459838, -1323.831909, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1110.459838, -1314.211669, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1100.020751, -1333.461547, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1100.020751, -1323.831909, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1100.020751, -1314.211669, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1089.661254, -1333.461547, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1089.661254, -1323.831909, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1089.661254, -1314.211669, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1086.911499, -1334.042114, 12.636975, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1086.911499, -1324.412475, 12.636975, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1086.911499, -1314.792236, 12.636975, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1114.684326, -1335.545166, 14.682909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicbrikwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1114.684448, -1335.545166, 19.572908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicbrikwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1118.924072, -1339.765014, 19.462938, 90.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1123.874633, -1339.765014, 19.472938, 90.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1128.804443, -1339.765014, 19.502931, 90.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1132.473999, -1340.715209, 19.502931, 90.000000, 180.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1118.633789, -1335.534667, 19.462938, 90.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicbrikwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 1118.633789, -1338.484375, 19.452936, 90.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicbrikwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1343.100219, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.895751, -1343.100219, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.244506, -1343.100219, 12.726974, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1304.672607, 12.726974, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.885375, -1304.672607, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.364990, -1304.672607, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1131.396728, -1295.043334, 12.726974, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1141.885375, -1295.043334, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1152.364990, -1295.043334, 12.726974, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1099.936767, -1295.043334, 12.726974, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1110.425415, -1295.043334, 12.726974, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1120.905029, -1295.043334, 12.726974, 0.000000, 90.000045, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(1493, 1129.350708, -1350.073974, 18.967163, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    tmpobjid = CreateDynamicObject(1493, 1129.350708, -1347.054077, 18.967163, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 1131.895507, -1348.655639, 21.087158, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9593, "hosbibalsfw", "2hospital2sfw", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 1131.895507, -1353.635986, 21.087158, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9593, "hosbibalsfw", "2hospital2sfw", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 1131.895507, -1344.647216, 21.087158, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9593, "hosbibalsfw", "2hospital2sfw", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1129.392944, -1353.202392, 21.067173, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} ESTACIONAMENTO", 120, "Arial", 50, 0, 0x00000000, 0x00000001, 1);
    tmpobjid = CreateDynamicObject(1496, 1173.058105, -1342.083129, 12.889767, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    tmpobjid = CreateDynamicObject(1496, 1176.047729, -1342.083129, 12.889767, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(759, 1175.423828, -1315.492431, 12.810482, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(759, 1178.414184, -1315.492431, 12.810482, 0.000000, 0.000000, 115.800010, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(759, 1177.737304, -1333.025024, 12.810482, 0.000000, 0.000000, 115.800010, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(759, 1176.771118, -1331.026489, 12.810482, 0.000000, 0.000000, -152.800018, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(7636, 1107.460571, -1360.517700, 21.650472, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1444, 1129.226684, -1346.556762, 19.767160, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2773, 1128.157348, -1350.011352, 19.477165, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2773, 1128.157348, -1346.991210, 19.477165, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1129.523071, -1355.502685, 20.447162, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1129.523071, -1351.012573, 20.447162, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(638, 1117.737792, -1341.492065, 19.457160, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(638, 1120.397583, -1341.492065, 19.457160, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(638, 1123.027221, -1341.492065, 19.457160, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(638, 1125.716918, -1341.492065, 19.457160, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18014, 1129.049560, -1353.246093, 19.317163, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19277, 1131.896484, -1361.693359, 23.787160, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19277, 1131.896484, -1368.843383, 31.597164, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19277, 1131.896484, -1351.162963, 43.047161, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1422, 1090.065307, -1335.694580, 19.297157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1422, 1087.075195, -1335.694580, 19.297157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1422, 1084.144897, -1335.694580, 19.297157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1422, 1093.035156, -1335.694580, 19.297157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1422, 1095.425659, -1335.694580, 19.297157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(657, 1179.420043, -1362.333984, 12.554637, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(657, 1182.610229, -1360.944091, 12.554637, 0.000000, 0.000000, -159.500000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(657, 1181.998535, -1365.389526, 12.554637, 0.000000, 0.000000, -159.500000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(877, 1180.760620, -1361.037963, 14.435826, 0.000000, 0.000000, -29.500003, -1, -1, -1, 300.00, 300.00);

    // Loja eletronicos
    tmpobjid = CreateDynamicObject(19443, 1127.690795, -1561.979858, 13.608960, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
    tmpobjid = CreateDynamicObject(19443, 1129.295410, -1561.979980, 13.608960, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1134.961181, -1561.559448, 15.844510, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1134.961181, -1561.559448, 11.731249, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
    tmpobjid = CreateDynamicObject(19157, 1128.479370, -1558.940429, 12.759300, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19157, 1126.880126, -1558.935546, 12.759300, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19157, 1130.102172, -1558.932495, 12.759300, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19427, 1128.473022, -1561.322631, 15.388600, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(1897, 1128.205688, -1560.963378, 13.710499, 0.000000, 90.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(1897, 1128.753295, -1560.972900, 13.686499, 900.000000, 90.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1124.138061, -1562.600585, 13.241399, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "lostonclad1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1132.593505, -1562.614746, 13.241399, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "lostonclad1", 0x00000000);
    tmpobjid = CreateDynamicObject(2010, 1126.175903, -1562.669433, 12.537389, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFF66FF33);
    tmpobjid = CreateDynamicObject(2010, 1130.761474, -1562.640991, 12.537389, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFF66FF00);
    tmpobjid = CreateDynamicObject(19377, 1127.598388, -1559.064819, 12.463000, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 8391, "ballys01", "ws_floortiles4", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1124.009521, -1561.962768, 11.701589, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gallery01_law", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1133.631835, -1561.962036, 11.701589, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gallery01_law", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1129.106201, -1559.062744, 12.462699, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 8391, "ballys01", "ws_floortiles4", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1128.723999, -1557.579589, -31.287410, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_flroortile9", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1128.725219, -1547.946899, -26.979719, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1123.495605, -1557.594360, -31.202329, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1123.496704, -1547.960205, -31.202329, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1128.358032, -1549.718505, -31.202299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1123.610107, -1556.723754, -29.211465, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{0040ff} [", 120, "Webdings", 80, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19381, 1132.465332, -1547.825683, -31.202329, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1132.464599, -1557.457763, -31.202329, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1128.276611, -1562.329956, -36.150409, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033CC);
    tmpobjid = CreateDynamicObject(19929, 1128.041137, -1551.657104, -31.197200, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, 1126.176269, -1551.652832, -31.197200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, 1129.904785, -1551.654174, -31.197200, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1128.685180, -1549.334716, -27.315689, 0.000000, -60.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1132.054443, -1549.340942, -27.315689, 0.000000, -60.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1129.572875, -1549.728515, -27.240999, 30.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1127.825195, -1549.736083, -30.264650, 30.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1128.725219, -1547.946899, -31.287410, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_flroortile9", 0x00000000);
    tmpobjid = CreateDynamicObject(19433, 1128.742553, -1562.291503, -30.326599, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1128.723999, -1557.579589, -26.979700, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19433, 1127.145019, -1562.291137, -30.326610, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19157, 1127.935180, -1565.333129, -31.174600, 0.000000, 0.000000, 45.099998, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19157, 1126.355468, -1565.336547, -31.174600, 0.000000, 0.000000, 45.099998, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19433, 1127.915283, -1562.949218, -28.522300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(1897, 1128.199951, -1563.303344, -30.148300, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(1897, 1127.660522, -1563.306030, -30.174299, 180.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1131.756958, -1549.408325, -31.481729, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1131.755249, -1561.982055, -31.481729, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1122.664550, -1561.964233, -31.481729, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1122.671386, -1549.400878, -31.481729, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1128.276611, -1562.331909, -31.202299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 1132.462646, -1557.457763, -36.150398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033CC);
    tmpobjid = CreateDynamicObject(19381, 1132.463378, -1547.825683, -36.150398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033CC);
    tmpobjid = CreateDynamicObject(19381, 1128.358154, -1549.720458, -36.150398, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033CC);
    tmpobjid = CreateDynamicObject(19381, 1123.497558, -1557.593994, -36.150398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033FF);
    tmpobjid = CreateDynamicObject(19381, 1123.494384, -1547.960327, -36.150398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033FF);
    tmpobjid = CreateDynamicObject(19381, 1123.498291, -1547.960083, -36.150398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0033CC);
    tmpobjid = CreateDynamicObject(19926, 1124.014892, -1559.005126, -31.201400, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19926, 1124.023559, -1554.201293, -31.201400, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19926, 1131.959716, -1559.078613, -31.201370, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19926, 1131.972290, -1554.101196, -31.201370, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19931, 1131.895751, -1556.599731, -31.200580, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19931, 1124.023071, -1556.607299, -31.200599, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.397827, -1558.232055, -30.984699, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.397827, -1558.232055, -30.545099, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.397949, -1556.232910, -30.984699, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.397949, -1556.232910, -30.545099, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1128.173217, -1558.229980, -30.984699, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1128.173217, -1558.229980, -30.545099, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1128.173339, -1556.230834, -30.984699, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1128.173339, -1556.230834, -30.545099, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(2010, 1131.911376, -1561.798339, -31.203199, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFF009900);
    tmpobjid = CreateDynamicObject(2010, 1124.054077, -1561.769775, -31.203199, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFF009900);
    tmpobjid = CreateDynamicObject(19940, 1131.895874, -1556.582763, -31.039100, -70.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1131.635620, -1556.583984, -31.039100, -70.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(1234, 1133.349975, -1559.035522, -30.076299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(1234, 1133.322998, -1558.412475, -30.076299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(1234, 1133.339599, -1559.711669, -30.076299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19807, 1123.858154, -1559.724975, -30.214700, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19807, 1124.198730, -1559.719482, -30.214700, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(11705, 1124.028076, -1559.139648, -30.326099, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(11705, 1124.032836, -1558.458740, -30.326099, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(334, 1123.604858, -1556.668334, -29.976810, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
    tmpobjid = CreateDynamicObject(18867, 1131.632202, -1556.403808, -30.277200, 0.000000, 0.000000, 286.252777, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18867, 1131.648925, -1556.703857, -30.277200, 0.000000, 0.000000, 286.252777, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18872, 1127.924072, -1558.220581, -30.237300, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1130.348999, -1562.037963, -31.481700, 0.000000, 60.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1126.583984, -1562.040527, -31.481700, 0.000000, 60.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1127.224609, -1562.321533, -27.411520, -30.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1128.868286, -1562.321044, -30.264600, -30.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19997, 1133.209350, -1554.142700, -29.222299, 0.000000, 90.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
    tmpobjid = CreateDynamicObject(19997, 1133.217529, -1559.098388, -29.222299, 0.000000, 90.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
    tmpobjid = CreateDynamicObject(19997, 1122.761474, -1556.461669, -29.222299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.949951, -1559.202392, -31.318700, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.630493, -1559.203491, -31.318700, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.619018, -1555.249755, -31.318700, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1127.959716, -1555.248901, -31.318700, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1123.615478, -1556.478515, -29.091474, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} 50%", 120, "Calibri", 30, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1132.359130, -1559.343383, -29.231477, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{0040ff} )", 120, "Webdings", 90, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(14397, 1132.194458, -1554.952758, -31.481700, 0.000000, 60.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(14397, 1132.167236, -1557.297729, -31.481700, 0.000000, 60.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19433, 1132.455078, -1557.682006, -27.295700, 30.000000, 0.000000, 359.899993, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19433, 1132.459960, -1555.933593, -30.326599, 30.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_oldpainted", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1130.321166, -1559.974487, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1125.723388, -1560.170898, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1125.712768, -1555.672363, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1130.320678, -1555.640136, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1125.771484, -1551.804809, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19789, 1130.329467, -1551.732299, -27.077699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1128.411987, -1564.226440, 17.768321, 0.000000, 0.000000, -89.099990, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{0040ff} MAGALU", 120, "Engravers MT", 50, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19430, 1128.476806, -1564.120483, 17.640190, 90.199989, -4.399998, 94.799995, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(19430, 1128.475097, -1563.970336, 17.640159, 90.199989, -4.399998, 94.799995, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18652, 1124.096069, -1562.691528, 12.464090, 0.000000, 0.000000, -88.400047, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18652, 1124.226196, -1562.688110, 12.254089, 0.000000, 0.000000, -88.400047, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18652, 1132.567016, -1562.564697, 12.424094, 0.000000, 0.000000, -88.400047, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18652, 1132.567016, -1562.564697, 12.424094, 0.000000, 0.000000, -88.400047, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18648, 1127.761596, -1564.195800, 17.302839, 0.000000, 0.000000, 90.600013, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(18648, 1129.199218, -1564.187500, 17.302843, 0.000000, 0.000000, 90.300010, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4833, "airprtrunway_las", "Mannblok2_LAn", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1132.358398, -1559.106445, -29.181453, 0.000000, 0.000000, -179.900085, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} 30%", 120, "Ariel", 30, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1132.363037, -1554.497070, -29.241470, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{0040ff} (", 120, "Webdings", 90, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1132.361450, -1554.257080, -29.161466, 0.000000, 0.000000, -179.900054, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} 15%", 120, "Ariel", 30, 1, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(2010, 1132.041870, -1552.184448, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFF00CC00);
    tmpobjid = CreateDynamicObject(2010, 1124.090942, -1552.184448, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFF00FF00);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(19377, 1123.969116, -1554.670043, 12.491000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19377, 1133.564086, -1554.687744, 12.498889, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(717, 1118.970336, -1564.888183, 12.679880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(717, 1137.270874, -1565.088500, 12.679880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1514, 1128.803222, -1551.642700, -30.142799, 0.000000, 0.000000, 5.187900, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2190, 1126.945190, -1551.767456, -30.413999, 0.000000, 0.000000, 156.478256, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1714, 1128.058837, -1550.105834, -31.199249, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19157, 1129.515258, -1565.343017, -31.174600, 0.000000, 0.000000, 45.099998, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1127.566040, -1556.231323, -30.310100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1128.004150, -1556.229614, -30.310100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1128.004882, -1558.228027, -30.310100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1127.567016, -1558.229858, -30.310100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19623, 1132.187133, -1553.770996, -30.214599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19623, 1131.880615, -1553.771362, -30.214599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19893, 1131.949340, -1554.223022, -30.278699, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19894, 1131.941894, -1554.735351, -30.278499, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18866, 1132.170898, -1556.444091, -30.245599, 60.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18866, 1132.168212, -1556.664306, -30.245599, 60.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18874, 1127.908447, -1556.037597, -30.237499, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18874, 1127.896606, -1556.288330, -30.237499, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19623, 1131.874877, -1553.359130, -30.214599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19623, 1132.181274, -1553.354736, -30.214599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19423, 1131.807495, -1558.402099, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19423, 1131.907592, -1558.404174, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19423, 1132.007690, -1558.406127, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1131.907714, -1559.023071, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1132.068115, -1559.027221, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1131.988525, -1559.033325, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1132.167846, -1559.019897, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19421, 1131.828247, -1559.697387, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19421, 1131.907836, -1559.702758, -30.193599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(11728, 1123.505371, -1558.556274, -29.758199, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(11728, 1123.510375, -1559.257812, -29.758199, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1234, 1123.626953, -1559.621093, -30.794750, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19610, 1124.143066, -1556.760375, -30.238300, 0.000000, 0.000000, 123.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19610, 1124.129516, -1556.433471, -30.238300, 0.000000, 0.000000, 123.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1124.005615, -1556.642089, -30.161600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1123.905517, -1556.642700, -30.161600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19422, 1123.785400, -1556.643432, -30.161600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2232, 1124.038208, -1557.516601, -30.618499, 0.000000, 0.000000, 96.446296, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2231, 1123.675415, -1555.619873, -31.200599, 0.000000, 0.000000, 87.175682, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(367, 1131.853759, -1553.477783, -30.253799, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19814, 1132.348754, -1555.275390, -30.181600, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19814, 1132.346435, -1557.217773, -30.181600, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19787, 1123.510864, -1554.160278, -29.468799, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2028, 1123.890136, -1554.711425, -30.207899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2028, 1123.879150, -1553.707153, -30.207899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19893, 1127.587524, -1558.616699, -30.302700, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19893, 1127.595703, -1557.676269, -30.302700, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19893, 1127.584106, -1556.736083, -30.302700, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19893, 1127.590087, -1555.615478, -30.302700, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19894, 1128.025146, -1555.720581, -30.302499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19894, 1128.032592, -1556.781494, -30.302499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19894, 1128.022338, -1557.661621, -30.302499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19894, 1128.026977, -1558.632324, -30.302499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1127.622192, -1558.119262, -31.039100, -70.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1127.635131, -1557.198486, -31.039100, -70.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19940, 1127.609497, -1556.197509, -31.039100, -70.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18874, 1131.918945, -1556.405639, -30.237499, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18874, 1131.933837, -1556.665649, -30.237499, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18871, 1127.939819, -1557.066894, -30.230300, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18871, 1127.940063, -1557.300292, -30.230300, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18872, 1127.917602, -1557.976562, -30.237300, 70.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19808, 1128.067138, -1558.135375, -30.279100, 0.000000, 0.000000, 91.021202, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19808, 1128.075927, -1557.214843, -30.279100, 0.000000, 0.000000, 91.021202, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19808, 1128.057495, -1556.233032, -30.279100, 0.000000, 0.000000, 89.362998, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2196, 1127.393310, -1559.348510, -30.298599, 0.000000, 0.000000, 170.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19299, 1125.332885, -1552.856079, -30.794839, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1125.700317, -1560.141357, -27.108699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1130.314331, -1555.613525, -27.082700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1130.375122, -1551.765258, -27.078699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1130.343505, -1559.993896, -27.078699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1125.687133, -1555.642456, -27.108699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(957, 1125.758789, -1551.827148, -27.108699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18648, 1128.273803, -1558.228637, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18648, 1128.273803, -1556.208618, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18648, 1127.303344, -1556.208618, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18648, 1127.303344, -1558.228637, -31.201473, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);

    // Aeroporto
    tmpobjid = CreateDynamicObject(736, 1409.584960, -2271.592041, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1399.064208, -2271.464355, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1383.566284, -2271.479736, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1373.237182, -2271.047607, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1409.330688, -2300.718750, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1398.627807, -2300.451416, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1385.140747, -2300.911132, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1373.174194, -2301.437500, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1443.804931, -2287.017578, 12.480600, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_slatetiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 1454.305908, -2287.017333, 12.480600, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_slatetiles", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1441.834838, -2302.812011, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1460.941528, -2320.209472, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1488.806762, -2320.677978, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1508.385253, -2299.649658, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1508.168212, -2273.047363, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1488.314941, -2252.860351, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1459.425170, -2252.964599, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1441.490600, -2271.919189, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(4828, 1474.414062, -2286.796875, 26.359380, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 6282, "beafron2_law2", "boardwalk2_la", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "white", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 6282, "beafron2_law2", "boardwalk2_la", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1357.926513, -2281.688476, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(736, 1365.529663, -2286.638671, 23.104700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1352.987915, -2275.715820, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1352.830078, -2297.619873, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(700, 1358.787109, -2291.842773, 12.405960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1442.641723, -2274.053222, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1444.211547, -2272.614257, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1442.946533, -2305.231445, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1441.302490, -2303.690917, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1441.235107, -2300.922851, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1462.898437, -2318.604736, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1461.634521, -2320.673095, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1460.386596, -2317.809814, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1490.544921, -2319.374267, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1488.343627, -2318.494384, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1507.058837, -2298.532470, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1508.348876, -2272.876464, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1488.057617, -2254.844482, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1459.320922, -2255.536376, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(870, 1459.435180, -2252.627685, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1440.277099, -2292.239501, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1448.546386, -2292.254882, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1445.785156, -2292.234863, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1443.041259, -2292.238525, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1440.290649, -2281.836425, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1443.054809, -2281.835449, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1445.798706, -2281.831787, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(638, 1448.559936, -2281.851806, 13.227999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1376.404296, -2301.878906, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1370.991577, -2271.051513, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1398.212158, -2299.436767, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1388.286376, -2299.606933, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1407.209594, -2299.559326, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1412.222167, -2299.359375, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1407.367065, -2273.640136, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1402.362304, -2272.624023, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1381.218017, -2273.079833, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(631, 1438.811889, -2295.491699, 13.399600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFFFFF66);
    SetDynamicObjectMaterial(tmpobjid, 1, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(631, 1438.764038, -2293.242919, 13.399600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFFFFF66);
    SetDynamicObjectMaterial(tmpobjid, 1, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(631, 1438.888305, -2280.553955, 13.399600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFFFFF66);
    SetDynamicObjectMaterial(tmpobjid, 1, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(631, 1438.804809, -2278.135009, 13.399600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFFFFF66);
    SetDynamicObjectMaterial(tmpobjid, 1, 3820, "boxhses_sfsx", "ws_blocks_grey_1", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1535.514404, -2234.944824, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1533.136108, -2235.375488, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1528.552124, -2234.982177, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1524.527709, -2234.567626, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1520.004516, -2234.035156, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1511.939086, -2233.892822, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.143920, -2237.356689, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.194091, -2241.683593, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.296630, -2244.041992, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.110839, -2249.121582, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.230102, -2252.833984, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.153930, -2259.042968, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.221923, -2261.211914, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.224121, -2266.708007, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.089721, -2268.674560, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.457763, -2271.935546, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1532.581665, -2274.771484, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1530.501220, -2268.543457, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1529.396850, -2262.333740, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1529.055786, -2260.698486, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1526.816284, -2256.447753, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1507.044189, -2269.718017, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1521.938842, -2247.906494, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1518.690917, -2244.183593, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1514.138549, -2239.826904, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1528.125366, -2314.188964, 13.046999, 0.000000, 0.000000, 341.562408, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1527.087768, -2316.879394, 13.046999, 0.000000, 0.000000, 341.122436, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1524.651611, -2321.536376, 13.046999, 0.000000, 0.000000, 340.234741, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1515.452270, -2332.285400, 13.046999, 0.000000, 0.000000, 339.784179, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1529.233520, -2311.592041, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1530.771118, -2304.202636, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1530.316406, -2308.600341, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1523.786254, -2250.279052, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1518.576171, -2328.769531, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1520.722534, -2326.679687, 13.046999, 0.000000, 0.000000, 339.784179, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1522.406494, -2324.285156, 13.046999, 0.000000, 0.000000, 339.329101, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1511.017333, -2335.757812, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1509.286865, -2336.719726, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1515.606323, -2338.320312, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1517.665649, -2338.218994, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1522.420410, -2338.396240, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1530.332153, -2338.222900, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.230834, -2333.065429, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1528.901367, -2338.882568, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.777709, -2329.410400, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.765502, -2324.271484, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.362182, -2318.064697, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.478393, -2309.491699, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.646728, -2302.017822, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1536.639648, -2304.883789, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1492.318115, -2254.312744, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1463.131835, -2252.956054, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1442.713500, -2268.425048, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1457.336791, -2318.759033, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "bevflower2", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1485.997802, -2319.380126, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    tmpobjid = CreateDynamicObject(869, 1506.258544, -2303.232177, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3946, "bistro_plants", "starflower4", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(1226, 1398.224487, -2281.734130, 16.273130, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1416.764404, -2281.427734, 16.273130, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1398.031005, -2291.306640, 16.273099, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1416.811279, -2291.184570, 16.273099, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1381.179077, -2291.423339, 16.273099, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.556396, -2281.905273, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.653442, -2279.448486, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.665161, -2277.050048, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.590209, -2292.070312, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.628417, -2294.372314, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1438.725341, -2296.631347, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1450.243164, -2292.921630, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1450.152099, -2281.322509, 12.749219, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(712, 1507.137084, -2337.868408, 21.648439, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(712, 1535.826660, -2337.531982, 21.648439, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(712, 1505.118896, -2234.025634, 21.648439, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(712, 1535.937744, -2235.774414, 21.648439, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1537.169921, -2262.227294, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1537.168090, -2246.080566, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1520.792114, -2234.112304, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1537.171997, -2312.528320, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1536.647338, -2326.324951, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(620, 1521.449096, -2337.731689, 5.957099, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1441.256713, -2272.196533, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1443.330932, -2270.966552, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1441.092041, -2270.129882, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1444.638305, -2303.613281, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1443.177490, -2302.363525, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1458.906005, -2318.956298, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1459.612060, -2320.249755, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1489.690307, -2320.370849, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1487.840698, -2320.201660, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1489.781494, -2318.149658, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1508.286987, -2299.559570, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1506.046752, -2301.529541, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1508.492919, -2297.828857, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1508.323852, -2301.220458, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1507.745239, -2273.850341, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1508.380004, -2274.893066, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1506.426513, -2273.699707, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1506.826904, -2271.160156, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1489.700317, -2254.805419, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1488.234252, -2252.390869, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1486.770874, -2253.466064, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1490.445312, -2252.731689, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1460.589843, -2254.505615, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1461.384887, -2252.779296, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(870, 1458.047851, -2253.968261, 12.745400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1437.721679, -2275.924072, 16.273099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1437.660034, -2297.664062, 16.273099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1445.082031, -2315.047851, 16.273099, 0.000000, 0.000000, 40.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1474.535034, -2327.421142, 16.273099, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1503.737792, -2315.381347, 16.273099, 0.000000, 0.000000, 135.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1503.757934, -2257.539794, 16.273099, 0.000000, 0.000000, 230.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1474.502319, -2246.098876, 16.273099, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1445.190917, -2257.832519, 16.273099, 0.000000, 0.000000, 315.803314, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1450.738281, -2279.408203, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1459.795288, -2266.815185, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1474.445190, -2261.907714, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1489.134033, -2266.560302, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1498.252929, -2278.914306, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1498.328857, -2294.413330, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1489.424194, -2306.853271, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1474.709716, -2311.704345, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1460.005859, -2307.187011, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1450.900512, -2294.771728, 20.496410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1376.238037, -2300.051269, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1373.563476, -2302.876953, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1373.402587, -2301.022705, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1370.766723, -2302.394042, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1373.214111, -2300.338867, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1372.283325, -2269.880126, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1375.685791, -2271.130615, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1376.058471, -2269.754150, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1373.199951, -2269.806152, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1374.260986, -2272.118408, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1396.230224, -2299.719726, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1395.830078, -2302.808837, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1401.022338, -2299.521728, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1401.698974, -2301.117675, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1398.661254, -2302.285156, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1383.734252, -2299.042236, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1383.220214, -2302.893554, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1388.885620, -2302.241943, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1384.835815, -2300.056884, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1385.539062, -2302.372314, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1410.200561, -2302.118164, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1406.918823, -2302.646972, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1413.010742, -2300.952636, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1409.370849, -2300.078613, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1407.441772, -2270.737060, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1412.989990, -2270.017822, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1410.645263, -2273.398193, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1412.884643, -2272.385253, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1410.153320, -2270.535400, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1396.913330, -2271.395263, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1401.617309, -2270.189941, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1399.372558, -2273.108154, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1396.310424, -2273.629882, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1398.549804, -2270.479003, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1382.118041, -2271.153076, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1385.951416, -2270.268310, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1384.605712, -2273.141357, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1387.140869, -2272.388427, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1382.999633, -2270.224365, 12.925200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.560791, -2234.952880, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1526.154663, -2234.830810, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1522.452026, -2234.485839, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1517.209716, -2234.251464, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1514.356079, -2234.091552, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1509.251220, -2233.996826, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1507.130004, -2233.956298, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.365234, -2239.277587, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.293823, -2246.602050, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.170898, -2251.149414, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.164062, -2254.967285, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.187011, -2256.808593, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.351074, -2264.103027, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1535.924194, -2273.873046, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.036621, -2271.823242, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.268676, -2265.897949, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1529.766723, -2263.997070, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1528.013793, -2258.695556, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1525.931030, -2254.512451, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.886962, -2252.392822, 13.046999, 0.000000, 0.000000, 101.302223, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1521.938842, -2247.906494, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1520.480102, -2246.065429, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1521.938842, -2247.906494, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1518.690917, -2244.183593, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1521.938842, -2247.906494, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1520.480102, -2246.065429, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1516.853271, -2242.079101, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1520.480102, -2246.065429, 13.046999, 0.000000, 0.000000, 116.033409, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1514.138549, -2239.826904, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1511.998657, -2238.352050, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1514.138549, -2239.826904, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1509.435424, -2236.906982, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1511.998657, -2238.352050, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1507.517944, -2235.125976, 13.046999, 0.000000, 0.000000, 134.179824, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1535.944580, -2298.208740, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1533.182373, -2298.129394, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.715332, -2298.763916, 13.047019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1525.906616, -2319.286621, 13.046999, 0.000000, 0.000000, 340.680755, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.771118, -2304.202636, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.771118, -2304.202636, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.409790, -2306.740722, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.771118, -2304.202636, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.409790, -2306.740722, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.316406, -2308.600341, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1517.214843, -2330.797607, 12.977000, 0.000000, 0.000000, 339.329101, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.771118, -2304.202636, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.409790, -2306.740722, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.316406, -2308.600341, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1529.549804, -2310.742187, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1531.279296, -2301.267089, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1530.409790, -2306.740722, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1529.549804, -2310.742187, 13.046999, 0.000000, 0.000000, 71.287841, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1513.197631, -2333.957519, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1507.570068, -2337.897705, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1505.990356, -2338.604736, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1509.565917, -2338.342041, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1512.147949, -2338.516601, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1513.427978, -2338.503417, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1519.804077, -2338.329589, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1525.992065, -2338.390136, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1528.472045, -2338.290283, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1532.167602, -2338.253173, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1534.467041, -2338.575195, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.306518, -2337.973632, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.494628, -2335.712646, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1524.643310, -2338.337890, 13.046999, 0.000000, 0.000000, 338.869567, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.463256, -2326.645507, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.503784, -2321.163818, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.514160, -2332.706542, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.576293, -2306.911132, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.639648, -2304.883789, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.576293, -2306.911132, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.626464, -2315.371093, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.576293, -2306.911132, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.585815, -2299.616943, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.501708, -2312.358642, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1536.576293, -2306.911132, 13.046999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1443.640869, -2306.481933, 12.949000, 0.000000, 0.000000, 339.784210, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1508.402954, -2276.748046, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1485.277832, -2252.765625, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1456.299560, -2254.402343, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1441.299072, -2275.192626, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1442.594970, -2299.916992, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1464.292602, -2319.927490, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1492.186645, -2318.506103, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(869, 1507.537475, -2296.282226, 12.920999, 0.000000, 0.000000, 101.302200, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(717, 1463.673828, -2205.495361, 12.721099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(717, 1463.677978, -2229.744140, 12.721099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(717, 1485.300903, -2229.799072, 12.721099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(717, 1485.436401, -2205.555175, 12.721099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(717, 1565.227539, -2205.577636, 12.721099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1479.341186, -2207.003906, 16.347799, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1226, 1469.864501, -2227.887451, 16.347799, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.782836, -2316.436767, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1510.996459, -2233.690429, 12.541040, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.443969, -2240.438964, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.180297, -2248.135742, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1535.877929, -2255.424804, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.562133, -2264.658203, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1535.699584, -2271.794433, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1531.347290, -2273.149414, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1529.723144, -2266.736572, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1528.722290, -2261.149414, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1527.189086, -2257.381347, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1522.652709, -2249.363281, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1516.102539, -2241.169921, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1531.348022, -2298.843261, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1528.597778, -2313.810546, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1537.107788, -2307.061279, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1530.406127, -2305.762695, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.659057, -2321.022949, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1536.438354, -2329.939453, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1534.340942, -2339.309082, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1528.895263, -2339.016357, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1522.673095, -2338.295410, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1515.416625, -2338.217773, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1510.925292, -2337.743408, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1514.809082, -2331.852294, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1519.936279, -2327.386230, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1523.522216, -2321.442138, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1526.359863, -2318.064697, 12.541040, 0.000000, 0.000000, 359.798980, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1409.344970, -2300.619873, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1409.792480, -2271.638183, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1399.312377, -2271.348388, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1383.820312, -2271.319580, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1373.617431, -2270.936767, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1373.406616, -2301.184082, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1385.212646, -2300.788085, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(1215, 1398.741577, -2300.336425, 12.785440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1529.165893, -2329.605712, 13.079870, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1530.139892, -2325.657958, 12.370820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1525.707153, -2331.440185, 12.370820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1528.471557, -2247.447021, 12.370820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1527.390258, -2243.632812, 13.079870, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
    tmpobjid = CreateDynamicObject(3515, 1524.164184, -2241.410644, 12.370820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);


    // Mecanica ao lado da pizzaria
    tmpobjid = CreateDynamicObject(10575, 2152.647216, -1735.895996, 17.400230, 0.000000, 85.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "sw_sheddoor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2168.206542, -1729.110839, 15.931400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19817, 2151.989501, -1729.435058, 11.610030, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2168.206542, -1729.110839, 15.931400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2163.476806, -1724.381713, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2153.843994, -1724.379028, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2144.230957, -1724.377197, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2139.482666, -1729.108642, 15.931409, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2144.620605, -1729.132568, 17.834899, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2139.482666, -1729.108642, 12.434800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2144.211181, -1724.380371, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2153.843994, -1724.379028, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2163.476806, -1724.381713, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2168.206542, -1729.110839, 12.434800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2155.146484, -1729.131103, 12.473299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_airpt_concrete", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2163.042724, -1729.132202, 12.471300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_airpt_concrete", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2144.645019, -1729.131103, 12.473299, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_airpt_concrete", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2155.115966, -1729.132324, 17.662900, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2163.042724, -1729.132202, 17.664899, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19385, 2141.176025, -1733.836791, 15.928831, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.386230, -1733.835449, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2141.173095, -1727.103149, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.381591, -1727.102539, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2145.905517, -1729.103759, 12.434800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2141.173095, -1727.103149, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.381591, -1727.102539, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 2145.905517, -1729.103759, 15.931400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.386230, -1733.835449, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19385, 2141.176513, -1733.838623, 12.434800, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(2010, 2145.364501, -1733.247192, 12.560310, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0x00000000);
    tmpobjid = CreateDynamicObject(19385, 2141.176513, -1733.826660, 14.154040, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
    tmpobjid = CreateDynamicObject(19385, 2141.176513, -1733.836669, 15.153630, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
    tmpobjid = CreateDynamicObject(2010, 2139.927734, -1734.271484, 12.540390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(2010, 2142.472167, -1734.315429, 12.540390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2151.109375, -1737.494750, 12.471300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2161.604980, -1737.495117, 12.471300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2163.025634, -1737.500488, 12.469300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
    tmpobjid = CreateDynamicObject(19430, 2156.927978, -1733.856567, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(10575, 2161.531005, -1735.855346, 17.400230, 0.000000, 85.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "sw_sheddoor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2144.620605, -1729.132568, 17.662929, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2155.115966, -1729.132324, 17.834899, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2163.042724, -1729.132202, 17.832899, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2147.588623, -1733.835327, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2166.588623, -1733.759033, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19430, 2157.268798, -1733.844604, 15.931400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_sandstone1", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2147.588623, -1733.835327, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19430, 2156.927978, -1733.856567, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19430, 2157.268798, -1733.844604, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2166.588623, -1733.759033, 12.434800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "sl_vicwall01", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2144.666992, -1737.490722, 12.469300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2141.010253, -1732.116577, 16.234409, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2141.147705, -1728.883056, 16.234409, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.272460, -1728.881347, 16.234409, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 2144.207275, -1732.064453, 16.234409, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19817, 2161.529296, -1729.669433, 11.610030, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
    tmpobjid = CreateDynamicObject(2311, 2166.181396, -1730.897827, 12.557000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12821, "alleystuff", "planks01", 0x00000000);
    tmpobjid = CreateDynamicObject(2258, 2147.924072, -1724.471679, 16.484579, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_controltowerwin1", 0x00000000);
    tmpobjid = CreateDynamicObject(2258, 2165.585937, -1724.487792, 16.484579, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_controltowerwin1", 0x00000000);
    tmpobjid = CreateDynamicObject(2258, 2156.776855, -1724.475341, 16.484579, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_controltowerwin1", 0x00000000);
    tmpobjid = CreateDynamicObject(2258, 2152.176269, -1724.476928, 16.484579, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_controltowerwin1", 0x00000000);
    tmpobjid = CreateDynamicObject(2258, 2160.958496, -1724.530029, 16.484579, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_controltowerwin1", 0x00000000);
    tmpobjid = CreateDynamicObject(3593, 2129.317871, -1729.180175, 13.049500, 0.000000, 0.000000, 40.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(1217, 2119.212890, -1735.429443, 12.928600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(1217, 2118.037353, -1734.551269, 12.928600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(1217, 2117.088867, -1735.041259, 12.928600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(2670, 2118.684570, -1734.030395, 12.656399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(1131, 2122.977783, -1736.179199, 12.553930, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7555, "bballcpark1", "ws_carparknew2a", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2144.199951, -1733.986083, 7.317242, 0.000000, 0.000000, 89.700035, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2153.793701, -1734.036376, 7.317242, 0.000000, 0.000000, 89.700035, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 2163.479003, -1734.047607, 7.317242, 0.000000, 0.000000, 90.000030, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(19903, 2154.089843, -1724.869750, 12.545200, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(11709, 2148.440917, -1724.942749, 13.191260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1502, 2140.387939, -1733.875488, 12.399299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1998, 2141.096435, -1728.682006, 12.559900, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1714, 2140.982421, -1727.591186, 12.560770, 0.000000, 0.000000, 358.290618, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1726, 2145.259277, -1730.364135, 12.560000, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2311, 2143.655517, -1732.210815, 12.560400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1776, 2145.365478, -1727.871093, 13.670399, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2059, 2143.493896, -1731.047119, 13.090399, 0.000000, 0.000000, 52.666278, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2161, 2143.056396, -1727.196411, 12.558950, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2141.997802, -1728.335327, 16.649150, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2142.186767, -1732.242919, 16.649150, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19903, 2163.433837, -1724.933349, 12.545200, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1098, 2158.677978, -1724.900512, 13.037099, 0.000000, 0.000000, 280.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1728, 2167.683593, -1729.055541, 12.556799, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1487, 2166.414062, -1729.222778, 13.265500, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1487, 2166.350097, -1730.953002, 13.265500, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2823, 2166.286865, -1729.507690, 13.061249, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2860, 2166.117919, -1730.297119, 13.061200, 0.000000, 0.000000, 200.783340, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2166.031494, -1728.116088, 12.649399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2157.192871, -1731.992553, 12.649399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2166.522949, -1732.575195, 12.649399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2147.671142, -1730.795410, 12.649399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2148.262939, -1727.432495, 12.571100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2156.388916, -1726.302612, 12.571100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2162.434570, -1727.662353, 12.571100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3632, 2146.641113, -1726.681396, 12.961990, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3632, 2146.365966, -1727.368408, 12.961990, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3632, 2154.950439, -1724.961181, 12.961990, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19621, 2155.086181, -1725.144653, 13.531100, 0.000000, 0.000000, 231.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19899, 2156.797851, -1725.000488, 12.558699, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19899, 2167.624755, -1726.149291, 12.558699, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19900, 2146.435791, -1728.267456, 12.559880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19900, 2159.250488, -1725.698120, 12.559900, 0.000000, 0.000000, 32.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19815, 2151.250976, -1724.455688, 14.981550, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19815, 2160.403564, -1724.478759, 14.981550, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19921, 2146.557373, -1729.212768, 12.643699, 0.000000, 0.000000, 32120.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19921, 2153.961425, -1728.156860, 12.643699, 0.000000, 0.000000, 32120.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1128, 2147.151367, -1731.377807, 12.560199, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1150, 2147.927734, -1729.616088, 12.566049, 0.000000, 0.000000, 6.122260, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1074, 2146.182373, -1730.443115, 13.040300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1074, 2148.540771, -1733.557983, 13.040300, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1074, 2148.579345, -1732.554931, 12.669300, 0.000000, 270.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1010, 2152.832275, -1725.111938, 13.529939, 0.000000, 0.000000, 10.675700, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1008, 2159.128173, -1725.726806, 13.434889, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2551, 2157.119628, -1733.310058, 13.496100, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2585, 2146.123779, -1732.459594, 13.746100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1001, 2165.400146, -1725.064331, 12.558090, 0.000000, 0.000000, 0.406040, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1000, 2165.444580, -1725.401367, 12.558190, 0.000000, 0.000000, 358.274200, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1003, 2165.370605, -1726.243896, 12.558219, 0.000000, 0.000000, 0.828570, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1010, 2167.499511, -1726.978149, 13.826359, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1078, 2166.945556, -1726.952026, 13.053899, 0.000000, -10.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1078, 2167.931152, -1728.040771, 13.053899, 0.000000, -10.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1078, 2166.124023, -1726.927368, 12.652899, 0.000000, 270.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2000, 2149.885009, -1724.937866, 12.561470, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2000, 2167.613769, -1732.305419, 12.558500, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19622, 2167.242187, -1733.562255, 13.265999, 10.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19622, 2157.890136, -1733.609863, 13.265999, 10.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19621, 2157.312255, -1733.511962, 15.097599, 0.000000, 0.000000, 120.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19621, 2156.908447, -1733.551635, 15.097599, 0.000000, 0.000000, 170.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19631, 2157.000488, -1733.525024, 14.700900, 0.000000, 90.000000, 80.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19627, 2157.239257, -1733.441650, 14.677599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19627, 2157.024658, -1733.348632, 14.677599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19627, 2156.978515, -1733.446411, 14.677599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19627, 2157.405029, -1733.350830, 14.677599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19832, 2157.364257, -1733.569213, 14.316880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19832, 2156.891113, -1733.480712, 14.316900, 0.000000, 0.000000, 30.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19917, 2161.536621, -1725.575927, 12.558329, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18633, 2157.216064, -1733.516723, 13.984999, 0.000000, 90.000000, 80.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19627, 2157.344970, -1733.352172, 13.985600, 0.000000, 0.000000, -353.055297, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18635, 2157.146240, -1733.606079, 13.609700, 90.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18635, 2157.094970, -1733.469482, 13.609700, 90.000000, 90.000000, 20.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18634, 2156.690429, -1733.565307, 13.646599, 0.000000, 90.000000, -50.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2150.796386, -1729.450805, 17.868000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2163.750976, -1729.825439, 17.868000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2159.770751, -1729.762451, 17.868000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1893, 2155.130371, -1729.742675, 17.868000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2126.665771, -1722.637451, 13.703700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2121.414062, -1722.636962, 13.703700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2116.149658, -1722.638671, 13.703700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2112.625732, -1725.110473, 13.703700, 0.000000, 0.000000, 70.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2110.822753, -1730.064086, 13.703700, 0.000000, 0.000000, 70.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2109.022705, -1735.007202, 13.703700, 0.000000, 0.000000, 70.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2107.830810, -1738.276855, 13.703700, 0.000000, 0.000000, 70.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2109.602050, -1740.739990, 13.703700, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2114.872314, -1740.741333, 13.703700, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2120.131591, -1740.742675, 13.703700, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1412, 2125.393310, -1740.742797, 13.703700, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1358, 2116.105957, -1726.113281, 13.749990, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3594, 2111.832519, -1736.207519, 13.245900, 0.000000, 0.000000, 10.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3594, 2124.127685, -1727.443847, 13.245900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3594, 2133.152343, -1727.213256, 13.245900, 0.000000, 0.000000, 30.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3593, 2117.541503, -1736.943725, 13.049500, 0.000000, 0.000000, 80.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1217, 2118.331542, -1724.575805, 12.928600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1217, 2118.718261, -1726.025146, 12.928600, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(918, 2125.353515, -1730.581542, 12.860400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(918, 2125.953125, -1730.394531, 12.860400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(918, 2156.983642, -1725.919311, 12.860400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(918, 2147.071044, -1728.924804, 12.860400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1222, 2122.052734, -1738.390380, 13.060190, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1222, 2131.304687, -1728.077636, 13.060190, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1222, 2132.714355, -1730.134155, 13.060190, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2124.145263, -1738.783325, 12.656399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2670, 2126.290039, -1729.016967, 12.656399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2109.642333, -1738.470336, 12.567099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2120.514892, -1726.805541, 12.567099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2113.870117, -1734.545654, 12.567099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2671, 2127.554199, -1730.345581, 12.567099, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1299, 2113.688964, -1730.012207, 12.942350, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1327, 2135.805908, -1726.530639, 13.326390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1149, 2116.847900, -1729.071044, 12.539859, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1149, 2114.875732, -1738.593750, 12.539859, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2114.081298, -1724.468139, 16.302299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2135.712158, -1724.377319, 16.302299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2108.739501, -1740.063598, 16.302299, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2114.081298, -1724.468139, 16.302299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2135.712158, -1724.377319, 16.302299, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1226, 2108.739501, -1740.063598, 16.302299, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1215, 2156.474121, -1734.285278, 12.558380, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1215, 2157.697021, -1734.286254, 12.558380, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);



    // DELEGACIA interior
    tmpobjid = CreateDynamicObject(18765, 1567.694091, 1597.024780, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.665771, 1597.024780, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.665771, 1607.014648, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.665771, 1587.035034, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1567.705810, 1587.035034, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1567.705810, 1607.005004, 1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.107055, 1602.039184, 1004.120178, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1567.907348, 1602.039184, 1004.120178, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1564.717651, 1602.039184, 1004.120178, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.087890, 1600.369873, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.107055, 1592.788330, 1004.120178, -0.000007, 0.000000, 89.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1567.907348, 1592.788330, 1004.120178, -0.000007, 0.000000, 89.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1564.717651, 1592.788330, 1004.120178, -0.000007, 0.000000, 89.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.087890, 1594.438232, 1004.120178, 0.000000, 0.000007, 179.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19396, 1574.201049, 1602.047119, 1004.120178, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19396, 1574.201049, 1592.786376, 1004.120178, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.087890, 1600.369873, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19696, 1576.633911, 1597.539794, 998.430297, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.946533, 1593.823974, 1004.120178, 0.000000, 0.000007, 132.299850, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.778198, 1601.081176, 1004.120178, 0.000000, 0.000007, 222.299850, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19696, 1576.633911, 1597.539794, 1009.920898, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.665771, 1597.024780, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(19696, 1576.613403, 1597.539794, 998.370605, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
    tmpobjid = CreateDynamicObject(19696, 1576.613403, 1597.539794, 1010.020263, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1567.706665, 1597.024780, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(2643, 1576.712524, 1593.725952, 1004.260192, 0.000004, 720.000000, -137.499954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 7009, "vgndwntwn1", "newpolice_sa", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19696, 1576.663452, 1597.539794, 999.960998, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1566.270751, 1592.594970, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1569.551147, 1592.594970, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1566.270751, 1602.235229, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1569.431396, 1602.235229, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2047, 1576.538574, 1601.217529, 1004.620300, 0.000000, 0.000000, -47.299976, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10028, "copshop_sfe", "dt_cops_US_flag", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1565.520629, 1593.274780, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1570.480102, 1593.274780, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1573.650268, 1593.274780, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1565.520629, 1601.604980, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1570.480102, 1601.604980, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1573.650268, 1601.604980, 1002.039855, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2960, 1573.380737, 1592.863281, 1002.589782, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2960, 1575.271484, 1592.863281, 1002.589782, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2960, 1575.271484, 1601.953369, 1002.589782, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2960, 1573.351318, 1601.953369, 1002.589782, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(2960, 1573.351318, 1601.953369, 1002.589782, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1579.478515, 1600.039550, 1004.120178, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.097900, 1597.328125, 1004.120178, 0.000000, 0.000007, 179.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "patiodr_law", 0x00000000);
    tmpobjid = CreateDynamicObject(1499, 1573.461303, 1592.870483, 1002.380004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 3715, "archlax", "ws_greymetal", 0x00000000);
    tmpobjid = CreateDynamicObject(1499, 1573.412231, 1601.824096, 1002.389953, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 3715, "archlax", "ws_greymetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.006591, 1591.148803, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.837158, 1591.148803, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.837158, 1587.979125, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.837158, 1584.789062, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.006713, 1588.079956, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1569.487060, 1586.499633, 1004.120178, -0.000007, 0.000000, 269.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1562.754394, 1581.659545, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1562.754394, 1587.958618, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1562.754394, 1591.108520, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1562.760620, 1592.594970, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1569.487060, 1582.089599, 1004.120178, -0.000007, 0.000000, 269.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1566.316894, 1582.089599, 1004.120178, -0.000007, 0.000000, 269.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.205932, 1582.089599, 1004.120178, -0.000007, 0.000000, 269.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1562.754394, 1584.789062, 1004.120178, -0.000007, 0.000000, 179.999954, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19397, 1567.901123, 1584.345214, 1004.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1567.600952, 1586.124755, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1567.600952, 1582.364501, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1567.706665, 1587.065795, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.686767, 1587.065795, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(1499, 1567.871093, 1583.620483, 1002.380004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    tmpobjid = CreateDynamicObject(1716, 1570.205078, 1587.145019, 1003.444946, 0.000009, 0.000018, 119.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFF303030);
    tmpobjid = CreateDynamicObject(2266, 1570.360229, 1587.505981, 1003.555053, 0.000039, -0.000009, -150.000030, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19598, "sfbuilding1", "darkwood1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
    tmpobjid = CreateDynamicObject(2266, 1570.843383, 1586.629150, 1003.555053, -0.000039, 0.000009, 30.000089, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19598, "sfbuilding1", "darkwood1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19598, "sfbuilding1", "darkwood1", 0x00000000);
    tmpobjid = CreateDynamicObject(19808, 1570.481445, 1587.541748, 1003.464965, 0.000018, -0.000009, -149.999969, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF404040);
    tmpobjid = CreateDynamicObject(19874, 1570.057495, 1587.321655, 1003.444946, -0.000009, -0.000018, -60.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18064, "ab_sfammuunits", "gun_blackbox", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1588.207153, 1004.920104, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "a51_map", 0x00000000);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1588.207153, 1003.980163, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "a51_radardisp", 0x00000000);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1589.987426, 1003.980163, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "a51_map", 0x00000000);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1589.987426, 1004.910278, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} wanted", 110, "courier", 20, 0, 0x00000000, 0x00000000, 0);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1591.687255, 1004.910278, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "a51_radardisp", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1572.908203, 1603.629394, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1572.908203, 1606.768920, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.699340, 1603.229614, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.699340, 1606.349731, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19397, 1572.903198, 1609.949462, 1004.100341, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.068603, 1603.629394, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.068603, 1606.829467, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1563.068603, 1609.999511, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1564.678222, 1611.609008, 1004.120178, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1567.868164, 1611.609008, 1004.120178, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.028198, 1611.609008, 1004.120178, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1572.691528, 1611.604980, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 1563.848144, 1604.618896, 1000.499816, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 1563.848144, 1609.538085, 1000.499816, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1567.706665, 1607.153930, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(1656, 1566.522094, 1610.818603, 1002.500000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(1656, 1566.522094, 1609.468627, 1002.500000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(2445, 1565.618896, 1606.277832, 1002.999816, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1563.191162, 1606.715209, 1004.489807, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000000} POLICIA", 130, "Quartz MS", 100, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1563.191162, 1608.875122, 1004.489807, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{000000} d", 130, "Webdings", 100, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1563.191162, 1608.875122, 1004.489807, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} d", 140, "Webdings", 100, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(1499, 1572.941894, 1609.224121, 1002.389953, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
    tmpobjid = CreateDynamicObject(19397, 1575.694335, 1609.489013, 1004.100341, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1581.128906, 1601.628906, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1581.128906, 1604.828247, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1581.128906, 1607.997436, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1581.128906, 1611.127685, 1004.120178, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1577.309082, 1611.127685, 1004.120178, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1580.308959, 1611.127685, 1004.120178, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1577.780883, 1600.005126, 1003.450073, 0.000000, 180.000000, -10.600001, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1577.665771, 1607.015136, 1008.229858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(1499, 1575.712890, 1608.723632, 1002.389953, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
    tmpobjid = CreateDynamicObject(19328, 1577.093139, 1607.511474, 1002.824584, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(964, 1576.447631, 1607.116210, 1002.294494, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    SetDynamicObjectMaterial(tmpobjid, 2, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    tmpobjid = CreateDynamicObject(964, 1576.447631, 1605.885131, 1002.294494, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    SetDynamicObjectMaterial(tmpobjid, 2, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    tmpobjid = CreateDynamicObject(19843, 1576.615844, 1605.887084, 1002.794433, 0.000014, 90.000015, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.615844, 1605.837036, 1002.794433, 0.000014, 90.000015, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.235595, 1605.887084, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.235595, 1605.837036, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.615844, 1607.128051, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.615844, 1607.078002, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.235595, 1607.128051, 1002.794433, 0.000014, 90.000030, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.235595, 1607.078002, 1002.794433, 0.000014, 90.000030, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.405761, 1605.527343, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.405761, 1606.217407, 1002.794433, 0.000014, 90.000022, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.405761, 1607.447998, 1002.794433, 0.000014, 90.000030, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19843, 1576.405761, 1606.717895, 1002.794433, 0.000014, 90.000030, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    tmpobjid = CreateDynamicObject(19328, 1577.093139, 1605.461791, 1002.824584, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(964, 1576.407714, 1607.116210, 1002.294494, -0.000014, -0.000007, -89.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    SetDynamicObjectMaterial(tmpobjid, 2, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    tmpobjid = CreateDynamicObject(964, 1576.407714, 1605.875854, 1002.294494, -0.000014, -0.000007, -89.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-50-percent", 0xFF80877B);
    SetDynamicObjectMaterial(tmpobjid, 2, 1675, "wshxrefhse", "greygreensubuild_128", 0xFF627855);
    tmpobjid = CreateDynamicObject(19328, 1575.752197, 1605.461914, 1002.824584, -0.000014, -0.000007, -90.000045, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19328, 1577.093139, 1606.292602, 1002.824584, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19328, 1577.093139, 1606.692626, 1002.824584, 0.000014, 0.000007, 89.999923, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19328, 1575.752197, 1607.531616, 1002.824584, -0.000014, -0.000007, -90.000045, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19328, 1575.752197, 1606.700805, 1002.824584, -0.000014, -0.000007, -90.000045, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19328, 1575.752197, 1606.290771, 1002.824584, -0.000014, -0.000007, -90.000045, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{30332a}g", 100, "Webdings", 40, 0, 0x00000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(14596, 1578.072509, 1617.441650, 1001.619995, 0.000000, 0.000000, 1170.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18787, "matramps", "cardboard4", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10101, "2notherbuildsfe", "sl_vicbrikwall01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 10765, "airportgnd_sfse", "black64", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1572.677001, 1582.089599, 1004.120178, -0.000007, 0.000000, 269.999938, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1574.724365, 1582.640380, 1004.120178, -0.000007, 0.000000, -49.600059, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1575.751953, 1611.434814, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1572.971801, 1611.434814, 1003.450073, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
    tmpobjid = CreateDynamicObject(974, 1576.556396, 1614.623413, 1002.526245, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 1, 10806, "airfence_sfse", "ws_leccyfncetop", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1616.949584, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1613.739257, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1571.916015, 1614.414184, 988.440185, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1571.916015, 1604.424926, 988.440185, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1571.916015, 1624.394409, 988.440185, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 14711, "vgshm2int2", "HSV_carpet2", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1573.848266, 1618.649169, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1573.848266, 1621.828735, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1573.848266, 1625.038574, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1573.848266, 1628.238159, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1572.398071, 1629.368164, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1569.228271, 1629.368164, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.848876, 1612.159423, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.848876, 1608.969482, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.848876, 1605.799316, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.848876, 1602.629516, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1576.848876, 1599.429443, 992.460327, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1610.888427, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1608.047973, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1605.007934, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1575.358886, 1601.806396, 992.460327, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.036376, 1608.094970, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.036376, 1610.835937, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.036376, 1613.735839, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.046386, 1610.945678, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.046386, 1607.905883, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.046386, 1605.345703, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.066406, 1604.775146, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 1574.066406, 1602.034667, 993.099975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3998, "civic04_lan", "sl_crthooswall1", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1562.795898, 1604.515014, 996.689575, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1562.805175, 1614.535644, 996.699401, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1562.815795, 1624.524902, 996.689392, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1568.517700, 1599.428466, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1571.687133, 1599.428466, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1574.836914, 1599.428466, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19360, 1578.046508, 1599.428466, 992.460327, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 6873, "vgnshambild1", "fitzwallvgn6_256", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1566.867553, 1604.352539, 992.699951, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "nt_bonav1", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1566.867553, 1613.962646, 992.699951, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "nt_bonav1", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1561.916137, 1614.414184, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1561.916137, 1624.363647, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1561.916137, 1604.503906, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1551.917114, 1604.503906, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1551.917114, 1614.433471, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1551.917114, 1624.393066, 987.440002, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_asphalt2", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1563.003295, 1629.355346, 994.909973, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1572.938354, 1604.127563, 994.190246, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1572.938354, 1613.727905, 994.190246, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1572.938354, 1623.327026, 994.190246, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 1572.938354, 1632.936767, 994.190246, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bowler", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1553.423706, 1629.355346, 994.909973, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1543.784057, 1629.355346, 994.909973, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1563.003295, 1599.476318, 994.909973, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1553.423706, 1599.476318, 994.909973, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1543.784057, 1599.476318, 994.909973, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1552.906616, 1604.515014, 996.689575, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1552.915893, 1614.535644, 996.699401, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1552.926513, 1624.524902, 996.689392, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1542.947265, 1604.515014, 996.689575, 0.000000, 0.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1542.956542, 1614.535644, 996.699401, 0.000000, 0.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 1542.967163, 1624.524902, 996.689392, 0.000000, 0.000015, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10041, "archybuild10", "rooftop_gz3", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1546.943603, 1619.315551, 994.909973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1546.943603, 1609.695678, 994.909973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1546.943603, 1600.076171, 997.549621, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 1546.943603, 1628.947021, 997.549621, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1561.441772, 1599.489990, 992.100036, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3922, "bistro", "Marble2", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1551.842041, 1599.489990, 992.100036, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3922, "bistro", "Marble2", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1561.441772, 1629.340820, 992.100036, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3922, "bistro", "Marble2", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 1551.842041, 1629.340820, 992.100036, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3922, "bistro", "Marble2", 0x00000000);
    tmpobjid = CreateDynamicObject(14793, 1557.318603, 1620.963623, 994.010253, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19598, "sfbuilding1", "wall8", 0x00000000);
    tmpobjid = CreateDynamicObject(14793, 1557.318603, 1609.945800, 994.010253, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19598, "sfbuilding1", "wall8", 0x00000000);
    tmpobjid = CreateDynamicObject(14793, 1578.589599, 1608.744750, 994.010253, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19598, "sfbuilding1", "wall8", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(955, 1570.529907, 1601.562500, 1002.929748, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19994, 1568.394165, 1601.461059, 1002.469909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19994, 1567.473876, 1601.461059, 1002.469909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19994, 1567.473876, 1593.360473, 1002.469909, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19994, 1568.443603, 1593.360473, 1002.469909, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1566.197265, 1593.042602, 1004.719848, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1569.537231, 1593.042602, 1004.719848, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1569.477172, 1601.913452, 1004.719848, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1566.277099, 1601.913452, 1004.719848, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(633, 1563.700927, 1593.296264, 1003.489990, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(633, 1563.700927, 1601.266235, 1003.489990, 0.000000, 0.000000, -76.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2612, 1571.382202, 1592.912475, 1004.230041, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(14793, 1566.752319, 1598.762939, 1005.639831, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2206, 1570.395996, 1588.693359, 1002.500000, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2206, 1570.395996, 1591.512939, 1002.500000, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19787, 1570.983398, 1591.687255, 1003.990356, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19611, 1570.565917, 1588.496337, 1002.009765, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19610, 1570.584106, 1588.481201, 1003.602661, 16.100000, 0.800000, 87.899963, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2894, 1570.431152, 1589.857177, 1003.419982, 0.000000, 0.000000, -120.700012, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1806, 1569.665039, 1587.672851, 1002.500000, 0.000000, 0.000000, -53.700000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1562.878784, 1590.679931, 1004.630187, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1562.878784, 1588.729370, 1004.630187, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1562.878784, 1586.619140, 1004.630187, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1562.878784, 1586.619140, 1004.630187, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2604, 1563.337402, 1589.886474, 1003.200012, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1806, 1564.186523, 1591.179809, 1002.500000, 0.000000, 0.000000, 143.299972, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(334, 1570.339111, 1590.920654, 1003.530090, -89.899978, 94.200019, -54.499992, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1564.411499, 1582.245117, 1004.899963, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1565.821655, 1582.245117, 1004.899963, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1565.821655, 1582.245117, 1004.899963, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1565.821044, 1582.245117, 1003.659973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1564.311035, 1582.245117, 1003.659973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2615, 1564.311035, 1582.245117, 1003.659973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1572.138671, 1607.995483, 1003.060302, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1572.138671, 1606.995239, 1003.060302, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1572.138671, 1605.935424, 1003.060302, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1572.138671, 1604.865112, 1003.060302, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1572.138671, 1603.774780, 1003.060302, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1570.147216, 1607.995483, 1003.060302, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1570.147216, 1606.995239, 1003.060302, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1570.147216, 1605.935424, 1003.060302, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1570.147216, 1604.865112, 1003.060302, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1570.147216, 1603.774780, 1003.060302, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1568.196777, 1607.995483, 1003.060302, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1568.196777, 1606.995239, 1003.060302, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1568.196777, 1605.935424, 1003.060302, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1568.196777, 1604.865112, 1003.060302, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1811, 1568.196777, 1603.774780, 1003.060302, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1566.251464, 1602.651367, 1005.230102, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(950, 1569.401855, 1602.651367, 1005.230102, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(631, 1563.430297, 1602.531127, 1003.909606, 0.000000, 0.000000, 29.400005, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(631, 1563.583007, 1611.283081, 1003.909606, 0.000000, 0.000000, -162.800033, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19871, 1565.759155, 1606.270629, 1003.319946, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19610, 1565.757934, 1606.265625, 1004.370056, 23.200002, 1.499999, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2894, 1565.449707, 1606.253173, 1004.069763, 0.000000, 0.000000, -91.600013, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19175, 1569.229370, 1611.528442, 1004.500000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(14604, 1567.005126, 1602.839965, 1003.440307, 0.000000, 0.000000, -38.999980, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19172, 1572.794555, 1605.411132, 1004.589904, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2400, 1580.941406, 1603.329467, 1003.020019, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2400, 1580.941406, 1607.039428, 1003.020019, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3388, 1576.275756, 1602.801879, 1002.500000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3388, 1576.275756, 1603.771850, 1002.500000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3388, 1576.275756, 1604.711303, 1002.500000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3014, 1578.515380, 1600.364257, 1002.629943, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3014, 1579.255615, 1600.364257, 1002.629943, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(3014, 1579.255615, 1600.364257, 1002.629943, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(349, 1580.833251, 1606.505737, 1003.947937, 0.000000, 15.499999, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(349, 1580.603027, 1606.505737, 1003.947937, 0.000000, 15.499999, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2985, 1577.719726, 1600.961425, 1002.480102, 0.000000, 0.000000, 28.599998, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1238, 1579.699707, 1600.739746, 1002.780029, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1238, 1579.699707, 1600.739746, 1002.780029, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1238, 1579.699707, 1600.739746, 1002.780029, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1238, 1580.679809, 1600.739746, 1002.780029, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1577.071044, 1610.987670, 1004.340148, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2611, 1579.651123, 1610.987670, 1004.340148, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2579, 1580.888549, 1608.258789, 1004.339843, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(2579, 1580.888549, 1609.558837, 1004.339843, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(355, 1580.655029, 1605.475341, 1003.869995, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(355, 1580.865234, 1605.475341, 1003.869995, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(366, 1572.424682, 1592.845092, 1003.370239, -7.899999, 36.899997, 5.799999, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1654, 1579.182495, 1600.300415, 1003.070068, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1654, 1579.362670, 1600.300415, 1003.070068, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1536, 1573.587158, 1612.421264, 996.779296, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(1536, 1574.064086, 1612.421264, 1007.897277, 0.000000, -32.499996, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1612.321655, 992.230041, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1609.470825, 992.230041, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1606.540649, 992.230041, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1603.400756, 992.230041, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1612.321655, 994.680236, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1609.470825, 994.680236, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1606.540649, 994.680236, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19303, 1573.857055, 1603.400756, 994.680236, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19861, 1546.938110, 1602.242431, 992.389709, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19861, 1546.938110, 1626.752685, 992.389709, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(19174, 1571.123901, 1590.052124, 1004.580078, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18756, 1575.681152, 1625.450439, 992.780578, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18756, 1571.870361, 1625.440917, 992.780578, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18756, 1575.681152, 1619.999877, 992.780578, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(18756, 1571.870361, 1619.990356, 992.780578, 0.000000, -0.000007, 179.999954, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(14416, 1564.660400, 1627.236572, 987.729614, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(14416, 1564.660400, 1623.276489, 987.729614, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    tmpobjid = CreateDynamicObject(14416, 1564.660400, 1619.316894, 987.729614, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);


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
    if (!DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = false;
        VSenha[playerid] = "-1";
        VGenero[playerid] = -1;
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for (new i; i < 10; i++)
        {
            PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
        }
        SelectTextDraw(playerid, 0xFF0000AA);
    }
    else if (DOF2_FileExists(arquivo))
    {
        EstaRegistrado[playerid] = true;
        VSenha[playerid] = "-1";
        TentativasSenha[playerid] = 0;
        PlayerTextDrawSetString(playerid, TextdrawRegistro[6][playerid], PlayerName(playerid));
        for (new i; i < 10; i++)
        {
            PlayerTextDrawShow(playerid, TextdrawRegistro[i][playerid]);
        }
        SelectTextDraw(playerid, 0xFF0000AA);
    }
    LimparChat(playerid, 30);
    TogglePlayerSpectating(playerid, 1);
    InterpolateCameraPos(playerid, 3243.553466, -410.080627, 48.884914, 3136.406005, -415.946533, 8.551589, 7000);
    InterpolateCameraLookAt(playerid, 3247.088623, -410.126434, 52.420448, 3141.343017, -416.213256, 9.296744, 8000);
    SetPlayerColor(playerid, 0xFFFF00AA);
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Loja eletronicos
    RemoveBuildingForPlayer(playerid, 792, 1119.601, -1566.437, 12.625, 0.250);
    RemoveBuildingForPlayer(playerid, 1297, 1128.039, -1567.531, 15.859, 0.250);
    RemoveBuildingForPlayer(playerid, 792, 1141.578, -1566.437, 12.617, 0.250);

    // REMOVE BUILDING EXTERIOR HOSPITAL
    RemoveBuildingForPlayer(playerid, 5708, 1134.250, -1338.079, 23.156, 0.250);
    RemoveBuildingForPlayer(playerid, 5930, 1134.250, -1338.079, 23.156, 0.250);
    RemoveBuildingForPlayer(playerid, 617, 1178.599, -1332.069, 12.890, 0.250);
    RemoveBuildingForPlayer(playerid, 618, 1177.729, -1315.660, 13.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1184.010, -1343.270, 12.578, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1184.010, -1353.500, 12.578, 0.250);
    RemoveBuildingForPlayer(playerid, 5811, 1131.199, -1380.420, 17.070, 0.250);
    RemoveBuildingForPlayer(playerid, 5810, 1114.310, -1348.099, 17.984, 0.250);
    RemoveBuildingForPlayer(playerid, 5931, 1114.310, -1348.099, 17.984, 0.250);
    RemoveBuildingForPlayer(playerid, 5993, 1110.900, -1328.810, 13.851, 0.250);

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


    // Remove building aeroporto
    RemoveBuildingForPlayer(playerid, 4828, 1474.414, -2286.796, 26.359, 0.250);
    RemoveBuildingForPlayer(playerid, 4942, 1474.414, -2286.796, 26.359, 0.250);
    RemoveBuildingForPlayer(playerid, 4985, 1394.945, -2286.156, 17.539, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 1413.234, -2290.796, 16.242, 0.250);
    RemoveBuildingForPlayer(playerid, 671, 1530.890, -2251.421, 12.609, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1531.085, -2250.382, 11.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1531.085, -2329.140, 11.296, 0.250);


    // Mecanica ao lado da pizzaria ls
    RemoveBuildingForPlayer(playerid, 5551, 2140.515, -1735.140, 15.890, 0.250);
    RemoveBuildingForPlayer(playerid, 1412, 2116.726, -1713.460, 13.703, 0.250);
    RemoveBuildingForPlayer(playerid, 1412, 2118.093, -1718.546, 13.703, 0.250);
    RemoveBuildingForPlayer(playerid, 1412, 2121.375, -1721.687, 13.703, 0.250);
    RemoveBuildingForPlayer(playerid, 1412, 2126.578, -1722.468, 13.703, 0.250);
    RemoveBuildingForPlayer(playerid, 5410, 2140.515, -1735.140, 15.890, 0.250);

    CarregarTextdrawPlayer(playerid);
    VerificarLogin[playerid] = false;
    PlayAudioStreamForPlayer(playerid, "http://live.hunter.fm/sertanejo_high");
    InterpolateCameraPos(playerid, 3243.553466, -410.080627, 48.884914, 3136.406005, -415.946533, 8.551589, 7000);
    InterpolateCameraLookAt(playerid, 3247.088623, -410.126434, 52.420448, 3141.343017, -416.213256, 9.296744, 8000);

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

    if (VerificarLogin[playerid] == true)
    {
        SalvarDados(playerid);
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    StopAudioStreamForPlayer(playerid);

    if (VerificarLogin[playerid] == false)
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

stock SendClientMessageInRange(Float:_r, playerid, const _s[], c1, c2, c3, c4, c5)
{
    new Float:_x, Float:_y, Float:_z;
    GetPlayerPos(playerid, _x, _y, _z);
    foreach (Player, i)
    {
        if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid)) continue;
        if (GetPlayerDistanceFromPoint(i, _x, _y, _z) < _r / 16)
            SendClientMessage(i, c1, _s);
        else if (GetPlayerDistanceFromPoint(i, _x, _y, _z) < _r / 8)
            SendClientMessage(i, c2, _s);
        else if (GetPlayerDistanceFromPoint(i, _x, _y, _z) < _r / 4)
            SendClientMessage(i, c3, _s);
        else if (GetPlayerDistanceFromPoint(i, _x, _y, _z) < _r / 2)
            SendClientMessage(i, c4, _s);
        else if (GetPlayerDistanceFromPoint(i, _x, _y, _z) < _r)
            SendClientMessage(i, c5, _s);
    }
    return 1;
}

//AQUI
public OnPlayerText(playerid, text[])
{
    if (VerificarLogin[playerid] == false)
    {
        MensagemText(playerid, "~r~ERRO: ~w~Voce nao pode falar no chat.");
        return 0;
    }
    if (IsPlayerAdmin(playerid))
    {
        ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1, 1);
        format(String, sizeof(String), "%s{DAA520} {0C981F}[Administrador]{FFFFFF}]{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
        SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return 0;
    }
    if (Policial[playerid] == 1)
    {
        format(String, sizeof(String), "{0000FF}[Policial]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
        SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return 0;
    }
    if (Bandido[playerid] == 1)
    {
        format(String, sizeof(String), "{FF0000}[Bandido]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
        SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return 0;
    }
    else if (Bandido[playerid] == 0)
    {
        format(String, sizeof(String), "{4B0082}[Jogador]{FFFFFF}{FFFFFF} %s{FFFFFF} [%d]: %s", GetPlayerNome(playerid), playerid, text);
        SendClientMessageInRange(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return 0;
    }
    else if (Policial[playerid] == 0)
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
    if (!success)
    {
        new string[256];
        format(string, 256, "{9900FF}[Five] {FFFFFF}Comando Invalido.", cmdtext);
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
    if (dialogid == D_SENHA)
    {
        if (response)
        {
            if (strlen(inputtext) < 5 || strlen(inputtext) > 20)
            {
                MensagemText(playerid, "~r~ERRO: ~w~Voce informou uma senha muito pequena ou muito grande, informe senha maior que 5 e menor que 20");
            }
            else
            {
                format(VSenha[playerid], 20, inputtext);
                for (new i; i < strlen(inputtext); i++)
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
    if (dialogid == D_GENERO)
    {
        if (response)
        {
            if (listitem == 0)
            {
                VGenero[playerid] = 1;
                CriarDadosPlayer(playerid);
            }
            if (listitem == 1)
            {
                VGenero[playerid] = 2;
                CriarDadosPlayer(playerid);
            }
        }
        else
        {
            return ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");
        }
    }

    if (dialogid == DIALOG_ESCOLHER_LADO)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SCM(playerid, COR_BRANCO, "{63AFF0}[Five] Policial: {FFFFFF}Voce Virou Policial, Use {9900FF}/ajudapm, {FFFFFF}para ver os comandos!");
                Policial[playerid] = 1;
                Bandido[playerid] = 0;
                SetPlayerSkin(playerid, 285);
                SetPlayerColor(playerid, COR_AZUL);
                SetPlayerPos(playerid, 1551.9346, -1675.5179, 16.0681);
                ShowLoadInt(playerid);
            }
            if (listitem == 1)
            {
                SCM(playerid, COR_BRANCO, "{FB0000}[Five] Bandido: {FFFFFF}Voce Virou Bandido, Use {9900FF}/ajudabandidos, {FFFFFF}para ver os comandos!");
                Bandido[playerid] = 1;
                Policial[playerid] = 0;
                SetPlayerSkin(playerid, 19);
                SetPlayerColor(playerid, COR_MARROM);
                SetPlayerPos(playerid, 2583.4858, -873.5188, 84.0401);
                ShowLoadInt(playerid);
            }
        }
    }


    if (dialogid == Garagem_Policial)
    {
        if (response)
        {
            if (listitem == 0)
            {
                new VTR_LS;
                VTR_LS = CreateVehicle(596, 1601.8549, -1704.2041, 5.5705, 89.6262, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_LS, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 1)
            {
                new VTR_SF;
                VTR_SF = CreateVehicle(597, 1600.9486, -1700.1726, 5.5705, 90.1010, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_SF, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 2)
            {
                new VTR_LV;
                VTR_LV = CreateVehicle(598, 1601.2448, -1696.0468, 5.5700, 90.6570, 1, 1, 0);
                PutPlayerInVehicle(playerid, VTR_LV, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 3)
            {
                new VTR_FBI;
                VTR_FBI = CreateVehicle(490, 1601.0087, -1683.9307, 6.0225, 89.8976, 1, 1, 0); // 0, -1, 0
                PutPlayerInVehicle(playerid, VTR_FBI, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 4)
            {
                new Blindado;
                Blindado = CreateVehicle(427, 1601.6797, -1692.0331, 5.5701, 89.7597, 1, 1, 0);
                PutPlayerInVehicle(playerid, Blindado, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 5)
            {
                new Rocam;
                Rocam = CreateVehicle(523, 1601.8209, -1687.7991, 5.5705, 91.5505, 1, 1, 0);
                PutPlayerInVehicle(playerid, Rocam, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 6)
            {
                new Helicoptero;
                Helicoptero = CreateVehicle(497, 1550.4500, -1609.7612, 13.5594, 272.5140, 1, 1, 0);
                PutPlayerInVehicle(playerid, Helicoptero, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
        }
        return true;
    }


    if (dialogid == Garagem_Bandido)
    {
        if (response)
        {
            if (listitem == 0)
            {
                new CarSultan;
                CarSultan = CreateVehicle(560, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarSultan, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 1)
            {
                new CarElegy;
                CarElegy = CreateVehicle(562, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarElegy, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 2)
            {
                new CarCheetah;
                CarCheetah = CreateVehicle(415, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, CarCheetah, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 3)
            {
                new MotoPCJ;
                MotoPCJ = CreateVehicle(461, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, MotoPCJ, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
            if (listitem == 4)
            {
                new VanBurrito;
                VanBurrito = CreateVehicle(482, 2533.8132, -913.4097, 86.3253, 176.4708, 0, -1, 0);
                PutPlayerInVehicle(playerid, VanBurrito, 0);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo retirado da garagem!");
            }
        }
    }


    if (dialogid == Skins_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                ShowPlayerDialog(playerid, SkinsMasculinas_Bandidos, DIALOG_STYLE_LIST, "Skins Masculinas", "{1E90FF}Skin 01\n{1E90FF}Skin 02\n{1E90FF}Skin 03\n{1E90FF}Skin 04\n{1E90FF}Skin 05", "Selecionar", "Fechar");
            }
            if (listitem == 1)
            {
                ShowPlayerDialog(playerid, SkinsFemininas_Bandidos, DIALOG_STYLE_LIST, "Skins Femininas", "{FF69B4}Skin 01\n{FF69B4}Skin 02\n{FF69B4}Skin 03\n{FF69B4}Skin 04\n{FF69B4}Skin 05", "Selecionar", "Fechar");
            }
        }
    }
    if (dialogid == SkinsMasculinas_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 115);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 01 Selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 293);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 02 Selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 123);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 03 Selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 230);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 04 Selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 292);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Masculina 05 Selecionada!");
            }
        }
    }
    if (dialogid == SkinsFemininas_Bandidos)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 298);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 01 Selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 193);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 02 Selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 169);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 03 Selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 55);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 04 Selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 12);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Skin Feminina 05 Selecionada!");
            }
        }
    }
    if (dialogid == Skins_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                ShowPlayerDialog(playerid, 72, 2, "Fardas Masculinas", "{1E90FF}Farda 01\n{1E90FF}Farda 02\n{1E90FF}Farda 03\n{1E90FF}Farda 04\n{1E90FF}Farda 05", "Selecionar", "Fechar");
            }
            if (listitem == 1)
            {
                ShowPlayerDialog(playerid, 73, 2, "Fardas Femininas", "{FF69B4}Farda 01\n{FF69B4}Farda 02", "Selecionar", "Fechar");
            }
        }
    }
    if (dialogid == SkinsMasculinas_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 280);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 01 selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 281);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 02 selecionada!");
            }
            if (listitem == 2)
            {
                SetPlayerSkin(playerid, 285);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 03 selecionada!");
            }
            if (listitem == 3)
            {
                SetPlayerSkin(playerid, 284);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 04 selecionada!");
            }
            if (listitem == 4)
            {
                SetPlayerSkin(playerid, 286);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda masculina 05 selecionada!");
            }
        }
    }
    if (dialogid == SkinsFemininas_Policiais)
    {
        if (response)
        {
            if (listitem == 0)
            {
                SetPlayerSkin(playerid, 306);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda feminina 01 selecionada!");
            }
            if (listitem == 1)
            {
                SetPlayerSkin(playerid, 309);
                SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Farda feminina 02 selecionada!");
            }
        }
    }
    return false;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if (playertextid != INVALID_PLAYER_TEXT_DRAW)
    {
        if (playertextid == TextdrawRegistro[7][playerid]) // Botao Senha
        {
            if (EstaRegistrado[playerid] == false)
            {
                CancelSelectTextDraw(playerid);
                ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo uma senha para registrar-se.", "Pronto", "Voltar");
            }
            if (EstaRegistrado[playerid] == true)
            {
                CancelSelectTextDraw(playerid);
                ShowPlayerDialog(playerid, D_SENHA, DIALOG_STYLE_PASSWORD, "Senha", "Informe abaixo sua senha para logar no servidor.", "Pronto", "Voltar");
            }
        }
        if (playertextid == TextdrawRegistro[8][playerid])
        {
            if (EstaRegistrado[playerid] == false)
            {
                if(new_strcmp(VSenha[playerid], "-1"))
                {
                    return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
                }
                else
                {
                    ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");

                    for (new i; i < 10; i++)
                    {
                        PlayerTextDrawHide(playerid, TextdrawRegistro[i][playerid]);
                    }
                    CancelSelectTextDraw(playerid);
                }
            }
            else if (EstaRegistrado[playerid] == true)
            {
                if (new_strcmp(VSenha[playerid], "-1"))
                {
                    return MensagemText(playerid, "~r~ERRO: ~w~Voce nao digitou a senha na textdraw de senha.");
                }
                format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
                if (!new_strcmp(VSenha[playerid], DOF2_GetString(arquivo, "Senha")))
                {
                    if (TentativasSenha[playerid] < 3)
                    {
                        new string[120];
                        TentativasSenha[playerid]++;
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
                    for (new i; i < 10; i++)
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
    if (!DOF2_FileExists(arquivo))
    {
        DOF2_CreateFile(arquivo); // caso o nome dele nao esteja na pasta administradores.
    }
    if (info[playerid][Admin] > 5) return SCM(playerid, -1, "");

    DOF2_SetInt(arquivo, "Admin", 10); // irá setar na linha Admin o valor do nível desejado.
    DOF2_SaveFile(); // salva e fecha o arquivo.
    info[playerid][Admin] = 10;
    SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Correct!");
    return 1;
}
CMD:comandosadm(playerid, params[])
{
    new Str[1000];
    if (info[playerid][Admin] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            strcat(Str, "{FFFFFF}/trabalhar | /limparchat | /sethora | /setclima | /dv | /car | /setmoney \n");
            strcat(Str, "{FFFFFF}/setskin   |   /aviso    | /trazer  |   /tvoff  | /tv |  /ir | /setvida  \n");
            strcat(Str, "{FFFFFF}/setarma   |   /daradmin |  /fix    | /trabalhar| /esc                   \n");
            strcat(Str, "{FFFFFF}                                TELEPORTES                               \n");
            strcat(Str, "{FFFFFF}/lobby     |   /favela   |  /dp     |    /ls    | /sf | /lv  | /cachoeira\n");
            ShowPlayerDialog(playerid, D_ADMINISTRADOR, DIALOG_STYLE_MSGBOX, "Comandos Admin - Five Fugas", Str, "-", "");
        }
    }
    return 1;
}

CMD:setmoney(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, valor;
            if (sscanf(params, "ud", id, valor))
                return SendClientMessage(playerid, 0xBFC0C2FF, "{9900FF}[Five] {FFFFFF}* Use: /setmoney [ID] [Valor]");
            GivePlayerMoney(id, valor);
        }
    }
    return 1;
}

CMD:setvida(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, vida, string[100], str[100];
            if (sscanf(params, "ii", id, vida)) return SendClientMessage(playerid, COR_AMARELO, "Use: /setvida [id] [vida]");
            format(string, 100, "{9900FF}[Five] {FFFFFF}Voce setou %d de vida no ID: %d", vida, id);
            format(str, 100, "{9900FF}[Five] {FFFFFF}Voce recebeu %d de vida do Admin", vida);
            SetPlayerHealth(id, vida);
            SendClientMessage(playerid, COR_AMARELO, string);
            SendClientMessage(id, COR_AMARELO, str);
        }
    }
    return 1;
}

CMD:daradmin(playerid, params[])
{
    new id, adm, funcao[999], str[999];
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "dds", id, adm, funcao)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /admin0 [ID] [NIVEL] [FUNCAO].");
            format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu administrador {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF} Para {FFFFFF}{F0E68C}%s(%d){FFFFFF}{FFFFFF}.", adm, funcao, PlayerName(id), id);
            SCM(playerid, -1, str);
            format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu admin nivel {9900FF}%d{FFFFFF} Funcao {9900FF}%s{FFFFFF}.", PlayerName(playerid), playerid, adm, funcao);
            SCM(id, -1, str);
            format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(id));
            if (DOF2_FileExists(arquivo))
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
CMD:limparchat(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            LimparChat(playerid, 30);
        }
    }
    return 1;
}
CMD:sethora(playerid, params[])
{
    new hora;
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", hora)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /sethora [HORA].");
            SetWorldTime(hora);
        }
    }
    return 1;
}

CMD:setclima(playerid, params[])
{
    new clima;
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", clima)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setclima [CLIMA].");
            SetWeather(clima);
        }
    }
    return 1;
}
CMD:car(playerid, params[])
{
    new Vehi[MAX_PLAYERS], CAR, C1, C2, Float:X, Float:Y, Float:Z, Float:R;
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            Gasolina[playerid] = 100;
            if (sscanf(params, "ddd", CAR, C1, C2)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /car [ID] [COR1] [COR2]");
            GetPlayerPos(playerid, X, Y, Z);
            GetPlayerFacingAngle(playerid, R);
            Vehi[playerid] = CreateVehicle(CAR, X, Y, Z, R, C1, C2, -1);
            PutPlayerInVehicle(playerid, Vehi[playerid], 0);
        }
    }
    return 1;
}
CMD:trabalhar(playerid, params[])
{
    new str[999];
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] > 0)
        {
            SetPlayerSkin(playerid, skinadm[playerid]);
            Trabalhando[playerid] = 0;
            SetPlayerHealth(playerid, 100);
            SetPlayerArmour(playerid, 0);
            SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
            format(str, sizeof(str), "{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Jogando.", PlayerName(playerid), playerid);
            SendClientMessageToAll(-1, str);
        }
        else
        {
            skinadm[playerid] = GetPlayerSkin(playerid);
            Trabalhando[playerid] = 1;
            SetPlayerHealth(playerid, 99999);
            SetPlayerArmour(playerid, 99999);
            SetPlayerSkin(playerid, 217);
            SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
            format(str, sizeof(str), "{FFFFFF}O Admin {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} Esta Trabalhando.", PlayerName(playerid), playerid);
            SendClientMessageToAll(-1, str);
        }
    }
    return 1;
}
CMD:setskin(playerid, params[])
{
    new ID, SKIN, str[999];
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "dd", ID, SKIN)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /setskin [ID] [SKIN]");
            {
                format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}Voce deu skin {FFFFFF}%d{FFFFFF} Para {9900FF}%s(%d){FFFFFF}.", SKIN, PlayerName(ID), ID);
                SCM(playerid, -1, str);
                format(str, sizeof(str), "{9900FF}[Five] {FFFFFF}O Administrador {FFFFFF}{9900FF}%s(%d){FFFFFF}{FFFFFF} te deu Skin {9900FF}%d{FFFFFF}.", PlayerName(playerid), playerid, SKIN);
                SCM(ID, -1, str);
                format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(ID));
                if (DOF2_FileExists(arquivo))
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
CMD:dv(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            DestroyVehicle(GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}
CMD:fix(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            RepairVehicle(GetPlayerVehicleID(playerid));
            //SendClientMessage(playerid, ROXO, "[Five] Veiculo Reparado!");
        }
    }
    return 1;
}
CMD:aviso(playerid, params[])
{
    new str[999], TEXTO;
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "s", TEXTO)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use: /aviso [TEXTO]");
            {
                SendClientMessageToAll(-1, "{9900FF}|_______________ {FFFFFF}Aviso da Administracao{9900FF} _______________|");
                format(str, 128, "{FFFFFF}Admin {9900FF}%s(%d){FFFFFF}{FFFFFF}: %s.", PlayerName(playerid), playerid, TEXTO);
                SendClientMessageToAll(-1, str);
            }
        }
    }
    return 1;
}
CMD:tv(playerid, params[])
{
    new id;
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if (EstaTv[playerid] == 0)
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "i", id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Use /tv [ID]");
            if (id == playerid) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Voce nao pode assistir!");
            if (!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Para parar de assistir use /tvoff.");
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectatePlayer(playerid, id);
            PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
            EstaTv[playerid] = 1;
        }
    }
    else
    {
        SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce ja esta tv em alguem, Use: /tvoff");
    }
    return 1;
}
CMD:tvoff(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    if (EstaTv[playerid] == 1)
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            TogglePlayerSpectating(playerid, 0);
            PlayerSpectatePlayer(playerid, playerid);
            PlayerSpectateVehicle(playerid, GetPlayerVehicleID(playerid));
            EstaTv[playerid] = 0;
        }
    }
    else
    {
        SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Voce nao esta tv em alguem.");
    }
    return 1;
}
CMD:ir(playerid, params[])
{
    new id, Float:PedPos[3], string[999];
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Use: /ir [ID].");
            if (!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
            GetPlayerPos(id, PedPos[0], PedPos[1], PedPos[2]);
            SetPlayerPos(playerid, PedPos[0], PedPos[1], PedPos[2]);
            format(string, 999, "{9900FF}[Five] {FFFFFF}Voce foi ate o player {9900FF}%s{FFFFFF}.", PlayerName(id));
            SCM(playerid, -1, string);
        }
    }
    return 1;
}
CMD:trazer(playerid, params[])
{
    new id, Float:PedPos[3], string[999];
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (sscanf(params, "d", id)) return SCM(playerid, 0xFF0000AA, "{9900FF}[Five] {FFFFFF}Use: /trazer [ID].");
            if (!IsPlayerConnected(id)) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Esse player nao esta online.");
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
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            new id, arma, municao, string[100], str[100];
            if (sscanf(params, "iii", id, arma, municao)) return SendClientMessage(playerid, COR_AMARELO, "{9900FF}[Five] {FFFFFF}Use: /setarma [id] [arma] [municao]");
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
    if (!DOF2_FileExists(arquivo))
    {
        DOF2_CreateFile(arquivo);
        DOF2_SetString(arquivo, "Senha", VSenha[playerid]);
        DOF2_SetInt(arquivo, "Dinheiro", 800);
        DOF2_SetInt(arquivo, "Level", 0);
        if (VGenero[playerid] == 1) // HOMEM
        {
            DOF2_SetInt(arquivo, "Skin", 29);
        }
        else if (VGenero[playerid] == 2)   // MULHER
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
    if (DOF2_FileExists(arquivo))
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

        SetSpawnInfo(playerid, NO_TEAM, GetPlayerSkin(playerid), 3343.6267, -1718.2443, 8.2578, 264.5571, 0, 0, 0, 0, 0, 0); //8.2578
        SpawnPlayer(playerid);
    }
    return 1;
}

stock SalvarDados(playerid)
{
    format(arquivo, sizeof(arquivo), PASTA_CONTAS, PlayerName(playerid));
    if (DOF2_FileExists(arquivo))
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
    TextdrawRegistro[0][playerid] = CreatePlayerTextDraw(playerid, 402.000000, 119.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[0][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[0][playerid], 2.679999, 21.999996);
    PlayerTextDrawColor(playerid, TextdrawRegistro[0][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[0][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[0][playerid], 471604479);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[0][playerid], 236.000000, 189.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[0][playerid], 0);

    TextdrawRegistro[1][playerid] = CreatePlayerTextDraw(playerid, 382.000000, 172.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[1][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[1][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[1][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[1][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[1][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[1][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[1][playerid], 0);

    TextdrawRegistro[2][playerid] = CreatePlayerTextDraw(playerid, 307.000000, 146.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[2][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[2][playerid], 4);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[2][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[2][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[2][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[2][playerid], 18.000000, -19.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[2][playerid], 0);

    TextdrawRegistro[3][playerid] = CreatePlayerTextDraw(playerid, 305.000000, 159.000000, "hud:ball");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[3][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[3][playerid], 4);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[3][playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[3][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[3][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[3][playerid], 22.000000, -11.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[3][playerid], 0);

    TextdrawRegistro[4][playerid] = CreatePlayerTextDraw(playerid, 382.000000, 205.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[4][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[4][playerid], 0.480000, 1.800000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[4][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[4][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[4][playerid], -1061109590);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[4][playerid], 255.000000, -247.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[4][playerid], 0);

    TextdrawRegistro[5][playerid] = CreatePlayerTextDraw(playerid, 353.000000, 251.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[5][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[5][playerid], 0.529999, 2.299999);
    PlayerTextDrawColor(playerid, TextdrawRegistro[5][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[5][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawUseBox(playerid, TextdrawRegistro[5][playerid], 1);
    PlayerTextDrawBoxColor(playerid, TextdrawRegistro[5][playerid], COR_ROXOCLARO);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[5][playerid], 284.000000, -252.000000);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[5][playerid], 0);

    TextdrawRegistro[6][playerid] = CreatePlayerTextDraw(playerid, 316.000000, 174.000000, "Nome_Sobrenome");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[6][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[6][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[6][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[6][playerid], COR_BRANCO);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[6][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[6][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[6][playerid], 0);

    TextdrawRegistro[7][playerid] = CreatePlayerTextDraw(playerid, 317.000000, 207.000000, "Senha");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[7][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[7][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[7][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[7][playerid], COR_BRANCO);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[7][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[7][playerid], 1);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[7][playerid], 30.0, 30.0);

    TextdrawRegistro[8][playerid] = CreatePlayerTextDraw(playerid, 318.000000, 255.000000, "Entrar");
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[8][playerid], 010101);
    PlayerTextDrawFont(playerid, TextdrawRegistro[8][playerid], 2);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[8][playerid], 0.190000, 1.200000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[8][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[8][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[8][playerid], 1);
    PlayerTextDrawTextSize(playerid, TextdrawRegistro[8][playerid], 30.0, 30.0);

    TextdrawRegistro[9][playerid] = CreatePlayerTextDraw(playerid, 317.000000, 326.000000, "_"); // erro
    PlayerTextDrawAlignment(playerid, TextdrawRegistro[9][playerid], 2);
    PlayerTextDrawBackgroundColor(playerid, TextdrawRegistro[9][playerid], 255);
    PlayerTextDrawFont(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawLetterSize(playerid, TextdrawRegistro[9][playerid], 0.250000, 1.300000);
    PlayerTextDrawColor(playerid, TextdrawRegistro[9][playerid], -1);
    PlayerTextDrawSetOutline(playerid, TextdrawRegistro[9][playerid], 0);
    PlayerTextDrawSetProportional(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetShadow(playerid, TextdrawRegistro[9][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TextdrawRegistro[9][playerid], 0);
    return 1;
}

stock MensagemText(playerid, const text[])
{
    PlayerTextDrawSetString(playerid, TextdrawRegistro[9][playerid], text);
    PlayerTextDrawShow(playerid, TextdrawRegistro[9][playerid]);
    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
    SelectTextDraw(playerid, 0xFFFFFFAA);
    return SetTimerEx("QuebrarText", 8000, false, "i", playerid);
}

stock LimparChat(playerid, linhas)
{
    for (new a = 0; a <= linhas; a++) SCM(playerid, -1, "");
}

stock PlayerName(playerid)
{
    new Nick[MAX_PLAYER_NAME];
    GetPlayerName(playerid, Nick, sizeof(Nick));
    return Nick;
}


CMD:escolher(playerid, params[])
{
    if (!PlayerToPoint(2.0, playerid, 3406.7095, -1677.8269, 7.5313))
    return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce precisa estar no lobby para usar esse comando!");
    ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "Escolha sua ORG/CORP", "{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar");
    return true;
}

CMD:esc(playerid, params[])
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            ShowPlayerDialog(playerid, DIALOG_ESCOLHER_LADO, DIALOG_STYLE_LIST, "(ADMIN) Escolha sua ORG/CORP", "{63AFF0}Policial - {FFFFFF}Funcao Prender os Procurados\n{FB0000}Bandido - {FFFFFF}Funcao Roubar Caixas e Lojas\n", "Escolher", "Fechar");
        }
    }
    return true;
}

//TELEPORTES
CMD:ls(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LS.");
            SetPlayerPos(playerid, 1479.7734, -1706.5443, 14.0469);
        }
    }
    return 1;
}
CMD:lv(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 1569.0677, 1397.1111, 10.8460);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para LV.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}
CMD:sf(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, -1988.3597, 143.4470, 27.5391);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para SF.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}


CMD:favela(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 2530.9797, -939.0609, 83.4220);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Favela");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:dp(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 1579.5828, -1607.0725, 13.3828);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a Delegacia de LS.");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:lobby(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 3408.9929, -1684.4728, 7.5313);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para o Lobby!");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}

CMD:cachoeira(playerid)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            SetPlayerPos(playerid, 3115.7041, -352.2107, 7.9271);
            SendClientMessage(playerid, 0x3A3FF1FF, "{9900FF}[Five] {FFFFFF}Voce foi teleportado para a cachoeira!");
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
    }
    return 1;
}


CMD:garagem(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2536.6902, -920.2032, 86.6194))
    {
        if (Bandido[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Garagem_Bandido, DIALOG_STYLE_LIST, "GARAGEM - VEICULOS", "{ff4848}Sultan\n{ff4848}Elegy\n{FF4848}Cheetah\n{FF4848}PCJ-600\n{FF4848}Burrito", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1588.4276, -1692.5383, 6.2188))
    {
        if (Policial[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Garagem_Policial, DIALOG_STYLE_LIST, "GARAGEM - VIATURAS", "{ff4848}Viatura LS\n{ff4848}Viatura SF\n{FF4848}Viatura LV\n{FF4848}Viatura FBI\n{FF4848}Blindado\n{FF4848}Rocam\n{FF4848}Helicoptero", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "[Five] Voce nao faz parte da Policia!");
        }
    }
    return 1;
}


CMD:guardarv(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2534.2649, -911.4888, 86.6154))
    {
        if (Bandido[playerid] == 1)
        {
            if (!IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um veículo.");
            }
            SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
            new var0 = GetPlayerVehicleID(playerid);
            DestroyVehicle(var0);
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1585.6941, -1677.2054, 5.8978))
    {
        if (Policial[playerid] == 1)
        {
            if (!IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um veículo.");
            }
            SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
            new var0 = GetPlayerVehicleID(playerid);
            DestroyVehicle(var0);
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!.");
        }
    }
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1550.4474,-1609.7603,13.4933))
    {
        // if (Policial[playerid] == 1)
        // {
        //     if (IsPlayerInAnyVehicle(playerid))
        //     {
        //         if(IsPlayerInVehicle(playerid, 497)) 
        //         {
        //             SendClientMessage(playerid, COR_ROXOCLARO, "{9900FF}[Five] {FFFFFF}Veiculo guardado com sucesso.");
        //             new var0 = GetPlayerVehicleID(playerid);
        //             DestroyVehicle(var0);
        //         }
        //         return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce so pode guardar helicopteros nessa garagem.");
        //     }
        //     return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao esta dentro de um helicoptero.");
        // }
        // else
        // {
        //     return SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!.");
        // }
    }
    return 1;
}


CMD:skins(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2547.4292, -926.9975, 84.5811))
    {
        if (Bandido[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Skins_Bandidos, DIALOG_STYLE_LIST, "Skins Bandidos", "{1E90FF}Skins Masculinas\n{FF69B4}Skins Femininas", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte dos Bandidos!");
        }
    }

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 1577.6028, 1606.5544, 1003.5000))
    {
        if (Policial[playerid] == 1)
        {
            ShowPlayerDialog(playerid, Skins_Policiais, DIALOG_STYLE_LIST, "Fardas Policiais", "{1E90FF}Fardas Masculinas\n{FF69B4}Fardas Femininas", "Selecionar", "Fechar");
        }
        else
        {
            SendClientMessage(playerid, COR_VERMELHO, "{9900FF}[Five] {FFFFFF}Voce nao faz parte da Policia!");
        }
    }
    return 1;
}

CMD:sair(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1564.1604, 1597.5245, 1003.5000)) //Saida DELEGACIA
    {
        SetPlayerFacingAngle(playerid, 91.2688);
        SetPlayerPos(playerid, 1555.5005, -1675.6212, 16.1953);
        ShowLoadInt(playerid);
    }

    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1127.9659, -1561.3444, -30.2015)) //Saida loja eletronicos magalu
    {
        SetPlayerFacingAngle(playerid, 91.2688);
        SetPlayerPos(playerid, 1128.4916, -1563.2698, 13.5489);
        ShowLoadInt(playerid);
    }
    return 1;
}

CMD:entrar(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1555.5005, -1675.6212, 16.1953)) //Entrada DELEGACIA
    {
        SetPlayerFacingAngle(playerid, 268.0929);
        SetPlayerPos(playerid, 1564.1604, 1597.5245, 1003.5000);
        ShowLoadInt(playerid);
    }

    if (IsPlayerInRangeOfPoint(playerid, 2.5, 1128.4916, -1563.2698, 13.5489)) //Entrada Loja eletronico
    {
        SetPlayerFacingAngle(playerid, 268.0929);
        SetPlayerPos(playerid, 1127.9659, -1561.3444, -30.2015);
        ShowLoadInt(playerid);
    }
    return 1;
}

CMD:equipar(playerid, params[])
{
    if (Bandido[playerid] < 1)
    {
        if (Policial[playerid] > 0)
        {
            if (Policial_Equipado[playerid] > 0)
            {
                SendClientMessage(playerid, COR_ROXO, "[Five] Voce Já Esta Equipado!");
            }

            SetPlayerHealth(playerid, 100); // Vida
            SetPlayerArmour(playerid, 100); // Colete
            GivePlayerWeapon(playerid, 24, 300); //DESERT EAGLE
            GivePlayerWeapon(playerid, 29, 500); //MP5
            GivePlayerWeapon(playerid, 31, 500); //M4A1
            Policial_Equipado[playerid] = 1;
        }
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (info[playerid][Admin] < 10) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao tem permissao.");
    {
        if (Trabalhando[playerid] < 1) return SCM(playerid, -1, "{9900FF}[Five] {FFFFFF}Voce nao esta em modo trabalho.");
        {
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                new veh = GetPlayerVehicleID(playerid);
                SetVehiclePos(veh, fX, fY, fZ);
            }
            else
            {
                SetPlayerPosFindZ(playerid, fX, fY, fZ);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
            }
        }
    }
    return 1;
}


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