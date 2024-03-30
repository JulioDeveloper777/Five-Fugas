#include <YSI_Coding/y_hooks>


stock DialogLogin(playerid)
{
  new str[1500], StrG[1500];
  format(str, sizeof(str), "\n{FFFFFF}Bem-vindo, {006400}%s!", PlayerName(playerid));
  strcat(StrG, str);
  format(str, sizeof(str), "\n\n{FFFFFF}Percebemos que ja possui uma conta registrada com este nome em nosso banco de dados.");
  strcat(StrG, str);
  format(str, sizeof(str), "\n{FFFFFF}Voce agora precisa informar a senha de login registrada nesta conta para continuar.");
  strcat(StrG, str);
  format(str, sizeof(str), "\n\n{808080}-		Aperte em 'recuperar conta'no lado esquerdo caso tenha");
  strcat(StrG, str);
  format(str, sizeof(str), "\n{808080}-		perdido a senha e possui o discord vinculado na conta.");
  strcat(StrG, str);
  format(str, sizeof(str), "\n\n{FFFFFF}Voce pode errar a senha no maximo {FF4500}3 {FFFFFF}vezes:");
  strcat(StrG, str);
  Dialog_Show(playerid, LOGANDO, DIALOG_STYLE_PASSWORD, "Efetuando login...", StrG, "Login", "Cancelar", ReturnPlayerName(playerid));
  return 1;
}

stock DialogRegistro(playerid)
{
  new strr[1500], StrG[1500];
  format(strr, sizeof(strr), "\n{FFFFFF}Parece que o status da sua conta {B22222}NAO REGISTRADA {FFFFFF}no nosso servidor.");
  strcat(StrG, strr);
  format(strr, sizeof(strr), "\n{FFFFFF}Confirme que voce quer criar uma conta neste servidor:");
  strcat(StrG, strr);
  format(strr, sizeof(strr), "\n\n{808080}-Ao criar uma conta no servidor voce vai estar concordando");
  strcat(StrG, strr);
  format(strr, sizeof(strr), "\n{808080}-Com todas as regras da comunidade que podem ser encontradas em");
  strcat(StrG, strr);
  format(strr, sizeof(strr), "\n{808080}-Nosso discord ou pedindo ajuda a um administrador");
  strcat(StrG, strr);
  format(strr, sizeof(strr), "\n\n{FFFFFF}Voce concorda em seguir todas as regras da comunidade?");
  strcat(StrG, strr);
  Dialog_Show(playerid, REGISTRO, DIALOG_STYLE_MSGBOX, "{FFFFFF}Registro|Passo[1/2]", StrG, "Sim", "Nao", ReturnPlayerName(playerid));
  return 1;
}

stock SegundaDialogRegistro(playerid)
{
  new str[1500], StrG[1500];
  format(str, sizeof(str), "\n{FFFFFF}Ola %s,voce ainda nao tem uma conta no servidor!", PlayerName(playerid));
  strcat(StrG, str);
  format(str, sizeof(str), "\n{FFFFFF}OBS:Voce precisa digitar sua senha abaixo para efetuar o registro no servidor.");
  strcat(StrG, str);
  format(str, sizeof(str), "\n\n{FFFFFF}OBS:A senha que voce digitar precisa ter no minimo 3 caracteres para ser valida.");
  strcat(StrG, str);
  Dialog_Show(playerid, REGISTROFINAL, DIALOG_STYLE_PASSWORD, "{FFFFFF}Registro|Passo[2/2]", StrG, "REGISTRAR", "", ReturnPlayerName(playerid));
  return 1;
}