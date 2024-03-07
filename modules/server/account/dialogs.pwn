#include <YSI_Coding/y_hooks>


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
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
          SelectTextDraw(playerid, -1);
      }
    }
    else
    {
      SelectTextDraw(playerid, -1);
    }
  }
  if (dialogid == D_GENERO)
  {
    if (response)
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
    }
    else
    {
      return ShowPlayerDialog(playerid, D_GENERO, DIALOG_STYLE_LIST, "Genero", "1. Masculino\n2. Feminino", "Proximo", "");
    }
  }
  return 1;
}