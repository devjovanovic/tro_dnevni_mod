//Celokupni mod kreiran od strane Jovanovica sa pocetkom dana 30.12.2020.
#include <a_samp>
#include <a_actor>
#include <foreach>
#include <streamer>
#include <YSI\y_ini>
#include <YSI\y_va>
#include <YSI\y_hooks>
#include <Pawn.CMD>
#include <sscanf2>
#include <crashdetect>
#include <sky>
#include <weapon-config>
//----------------------------------------------------------
#define ZUTA  "{d6cf00}"
#define BELA  "{ffffff}"
//----------------------------------------------------------
enum
{
    DIALOG_REGISTRACIJA,
    DIALOG_POL,
    DIALOG_GODINE,
    DIALOG_LOGIN,
    DIALOG_RENT,
    DIALOG_RENT2,
    DIALOG_BANKA,
    DIALOG_BANKA2,
    DIALOG_BANKA3,
    DIALOG_BANKA4,
    DIALOG_HELP,
    DIALOG_KUCA,
    DIALOG_FIRMA,
    DIALOG_FIRMA2,
    DIALOG_FIRMA3,
    DIALOG_KUPOVINAVOZILA,
    DIALOG_VOZILA,
	DIALOG_VOZILA2
}
//----------------------------------------------------------
stock SCMF(id, color, const fmt[], va_args<>)
{
	new str[128];
	va_format(str, sizeof str, fmt, va_start<3>); 
	return SendClientMessage(id, color, str); 
}
//----------------------------------------------------------
#define SCM va_SendClientMessage
#define SPD ShowPlayerDialog
#define function%0(%1) forward%0(%1); public%0(%1)
#define GRESKA(%0,%1) \
	SCMF(%0, 0xf6347aa, "[GRESKA] {FFFFFF}"%1)
#define KORISTI(%0,%1) \
	SCMF(%0, 0x66ccffff, "[KORISTI] {FFFFFF}"%1)
#define ASCM(%0,%1) \
	SCMF(%0, 0xcccc00ff, "[ADMIN] "%1)
#undef MAX_PLAYERS
const MAX_PLAYERS = 150;
#undef MAX_VEHICLES
const MAX_VEHICLES = 2000;
//----------------------------------------------------------
#include "Moduli/reglog.pwn"
#include "Moduli/chatsys.pwn"
#include "Moduli/banksys.pwn"
#include "Moduli/adminsys.pwn"
#include "Moduli/gps.pwn"//ni zapocet
#include "Moduli/sistemkuca.pwn"
#include "Moduli/plcmds.pwn"
#include "Moduli/sistemfirmi.pwn"
#include "Moduli/cos.pwn"
#include "Moduli/rent.pwn"
//----------------------------------------------------------
main() { }
//----------------------------------------------------------
public OnPlayerConnect(playerid)
{
 	return 1;
}
//----------------------------------------------------------
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
 	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 30000);
	TogglePlayerClock(playerid, 0);
	SetSpawn(playerid);
	return 1;
}
//----------------------------------------------------------
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}
//----------------------------------------------------------
public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}
//----------------------------------------------------------
public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	return 0;
}
//----------------------------------------------------------
public OnGameModeInit()
{
	SetGameModeText("Casa Campo RolePlay v0.0.1");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(1);
	SetNameTagDrawDistance(20.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	return 1;
}
//----------------------------------------------------------
public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}
//----------------------------------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return 1;
}
//----------------------------------------------------------
function Malloc_OnRuntimeError(code, &bool:suppress)
{
    printf("[RUNTIME ERROR]: %d %s", code, suppress);
	return 1;
}
//----------------------------------------------------------
