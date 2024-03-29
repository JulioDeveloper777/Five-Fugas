#include <YSI_Coding/y_hooks>

static MySQL: ConexaoMySQL = MYSQL_INVALID_HANDLE;


//___________MYSQL________________//
#define MYSQL_HOST        "localhost"
#define MYSQL_USER        "root"
#define MYSQL_PASS        ""
#define MYSQL_DB          "MyServerTest"

new global_query[612] = "";

MySQL:SQL_GetHandle()
{
	return ConexaoMySQL;
}

hook OnGameModeInit()
{
	ConexaoMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);

	if (ConexaoMySQL == MYSQL_INVALID_HANDLE || mysql_errno(ConexaoMySQL) != 0)
	{
		printf("** ATENÇÃO: [MYSQL] Não foi possível conectar ao banco de dados (erro: %i)", mysql_errno(ConexaoMySQL));
		return 0;
		// return Y_HOOKS_BREAK_RETURN_0;
	}
	else
	{
		print("[MYSQL] Banco de dados conectado com sucesso!");
		InternalSQL_CheckTables();
		
		mysql_set_charset("latin1"); // suportar caracteres (ã, á, ...)
	}
	return 1;
	// return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeExit()
{
	if (ConexaoMySQL != MYSQL_INVALID_HANDLE) 
	{
		mysql_close(ConexaoMySQL);
	}
	return 1;
	// return Y_HOOKS_CONTINUE_RETURN_1;
}

stock InternalSQL_CheckTables()
{
	mysql_tquery(SQL_GetHandle(), "CREATE TABLE IF NOT EXISTS `players`(player_id int NOT NULL AUTO_INCREMENT PRIMARY KEY);");
	mysql_tquery(SQL_GetHandle(), "ALTER TABLE `players` ADD IF NOT EXISTS (player_name varchar(21) NOT NULL default 'N/A')");
	mysql_tquery(SQL_GetHandle(), "ALTER TABLE `players` ADD IF NOT EXISTS (player_pass varchar(129) NOT NULL default 'N/A')");
	mysql_tquery(SQL_GetHandle(), "ALTER TABLE `players` ADD IF NOT EXISTS (player_skin int(11) NOT NULL default '26')");
	mysql_tquery(SQL_GetHandle(), "ALTER TABLE `players` ADD IF NOT EXISTS (player_admin int(11) NOT NULL default '0')");
	mysql_tquery(SQL_GetHandle(), "ALTER TABLE `players` ADD IF NOT EXISTS (player_discord_id varchar(21) NOT NULL default 'Nenhum')");
	return true;
}