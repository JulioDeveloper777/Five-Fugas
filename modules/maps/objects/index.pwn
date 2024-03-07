#include <YSI_Coding/y_hooks>


hook OnGameModeInit()
{
  CreatePickup(19132, 1, 1634.6958, -1365.4015, 331.4063, 0); //LOBBY
  Create3DTextLabel("{836FFF}Five Lobby\n{FFFFFF}Use {836FFF}/escolher {FFFFFF}Para Ser Policial ou Bandido", -1, 1634.6958, -1365.4015, 331.4063, 269.6019, 0, 0); //LOBBY

  CreateActor(280, 1636.5200, -1364.6707, 331.4063, 87.0475);
  CreateActor(293, 1636.4669, -1366.1387, 331.4063, 85.8724);

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
  return 1;
}