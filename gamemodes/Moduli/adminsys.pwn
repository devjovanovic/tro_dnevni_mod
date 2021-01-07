//Admin system kreirao Jovanovic datuma 30.12.2020.
#include <YSI\y_hooks>

new bool:ADuty[MAX_PLAYERS];
//----------------------------------------------------------
function SendASCM(color,const string[])
{
    if(strlen(string) > 0)
    {
		foreach(new i:Player)
		{
			if (PI[i][pAdmin] > 0)
			{
				SCMF(i, color, string);
			}
		}
	}
}
//----------------------------------------------------------
stock IsVehicleEmpty(vehicleid)
{
	foreach(new i:Player)
    {
        if(IsPlayerConnected(i))
		{
    		if(IsPlayerInVehicle(i, vehicleid)) return false;
		}
    }
	return true;
}
//----------------------------------------------------------
CMD:ah(playerid, params[])
{
	if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemas ovlascenje za ovu komandu!");
	new cmd[2048];
	if(PI[playerid][pAdmin] >= 1)
	{
	    strcat(cmd, ""ZUTA"ADMIN LEVEL 1\n\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/a [chat] /ao /veh /aduty /goto /kill /warn\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/cc /pm /kick /ban /vr /jetpack\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/freeze /unfreeze /setvw /setint /rtc\n\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 2)
	{
	    strcat(cmd, ""ZUTA"ADMIN LEVEL 2\n\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/postavivreme /gotopos /gethere\n\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 3)//
	{
	    strcat(cmd, ""ZUTA"ADMIN LEVEL 3\n\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/unwarn /rac /podesihp /podesiarmor\n\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 4)
	{
	    strcat(cmd, ""ZUTA"ADMIN LEVEL 4\n\n",sizeof(cmd));
	    strcat(cmd, ""BELA"/unban /setskin\n\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 5)
	{
		strcat(cmd, ""ZUTA"GLAVNI ADMIN\n\n",sizeof(cmd));
        strcat(cmd, ""BELA"/agun\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 6)
	{
		strcat(cmd, "DIREKTOR\n\n",sizeof(cmd));
        strcat(cmd, ""BELA"/dajnovac\n",sizeof(cmd));
	}
	if(PI[playerid][pAdmin] >= 7)
	{
	    strcat(cmd, "VLASNIK\n\n",sizeof(cmd));
        strcat(cmd, ""BELA"/nkucu /nfirmu /nrent /nvozilo /postaviadmina\n",sizeof(cmd));
	}
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, ""ZUTA"ADMIN KOMANDE", cmd, "ZATVORI","");
	return 1;
}
CMD:veh(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id, boja1, boja2, Float:X, Float:Y, Float:Z, Float:A;
	if(sscanf(params, "iii", id, boja1, boja2)) return KORISTI(playerid, "/veh [id vozila][boja1][boja2]");
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	CreateVehicle(id, X, Y, Z, A, boja1, boja2, 1000);
	ASCM(playerid, "Kreirali ste vozilo ID:%d", id);
	return 1;
}
//---------------------------------------------------------
CMD:jetpack(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		ASCM(playerid, "Uzeli ste JetPack!");
	}
	else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ASCM(playerid, "Skinuli ste JetPack!");
	}
	return true;
}
//---------------------------------------------------------
CMD:rtc(playerid, params[])
{
	if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	if(IsPlayerInAnyVehicle(playerid))
 	{
	 	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	 	LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
	 	ASCM(playerid, "Respawnovali ste vozilo.");
 	}
 	else return GRESKA(playerid, "Morate biti u vozilu");
	return 1;
}
//---------------------------------------------------------
CMD:setint(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id, in;
	if(sscanf(params, "ii", id, in)) return KORISTI(playerid, "/setint [id][int]");
	SetPlayerInterior(id, in);
	ASCM(playerid, "Setovali ste Interior %d ste igracu %s.", in, GetName(id));
    ASCM(id, "Setovan vam je Interior %d od strane Admina %s.", in, GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:setvw(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id, vw;
	if(sscanf(params, "ii", id, vw)) return KORISTI(playerid, "/setvw [id][vw]");
	SetPlayerVirtualWorld(id, vw);
	ASCM(playerid, "Setovali ste Virtual World %d ste igracu %s.", vw, GetName(id));
    ASCM(id, "Setovan vam je Virtual World %d od strane Admina %s.", vw, GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:unfreeze(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id;
	if(sscanf(params, "i", id)) return KORISTI(playerid, "/unfreeze [id]");
	TogglePlayerControllable(id, true);
	ASCM(playerid, "Unfreezovali ste igraca %s.", GetName(id));
    ASCM(id, "Unfreezani ste od strane Admina %s.", GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:freeze(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id;
	if(sscanf(params, "i", id)) return KORISTI(playerid, "/freeze [id]");
	TogglePlayerControllable(id, false);
	ASCM(playerid, "Freezovali ste igraca %s.", GetName(id));
    ASCM(id, "Freezani ste od strane Admina %s.", GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:vr(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    RepairVehicle(GetPlayerVehicleID(playerid));
	SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
	ASCM(playerid, "Popravili ste svoje vozilo.");
	return 1;
}
//---------------------------------------------------------
CMD:goto(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, Float:X, Float:Y, Float:Z;
    if(sscanf(params, "i", id)) return KORISTI(playerid, "/goto [id]");
    GetPlayerPos(id, X,Y,Z);
    SetPlayerPos(playerid, X,Y,Z);
    ASCM(playerid, "Teleportovali ste se do igraca %s.", GetName(id));
    ASCM(id, "Teleportovao se Admina %s do vas.", GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:kick(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, razlog[12];
	if(sscanf(params, "is[12]", id, razlog)) return KORISTI(playerid, "/kick [id][razlog]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	Kick(id);
	new string[128];
 	format(string, sizeof(string), "[ADMIN] Admin %s je kikovao igraca %s, razlog %s.", GetName(playerid), GetName(id), razlog);
	SendClientMessageToAll(0xcccc00ff, string);
	return 1;
}
//---------------------------------------------------------
CMD:pm(playerid, params[])
{
	if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, tekst[12];
	if(sscanf(params, "is[12]", id, tekst)) return KORISTI(playerid, "/pm [id][tekst]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	SCMF(playerid, -1, "[PM za %s]: %s.", GetName(id), tekst);
	SCMF(id, -1, "[PM od %s]: %s.", tekst, GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:warn(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, razlog[12];
	if(sscanf(params, "is[12]", id, razlog)) return KORISTI(playerid, "/warn [id][razlog]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	PI[id][pWarn] += 1;
	ASCM(playerid, "Dali ste igracu %s warn razlog: %s.", GetName(id), razlog);
	ASCM(id, "Dodeljen vam je warn razlog %s od strane %s.", razlog, GetName(playerid));
	if(PI[id][pWarn] >= 3)
	{
	    Ban(id);
	}
	return 1;
}
//---------------------------------------------------------
CMD:kill(playerid, params[])
{
    if(PI[playerid][pAdmin] < 3) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id;
	if(sscanf(params, "i", id)) return KORISTI(playerid, "/kill [id]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	SetPlayerHealth(playerid, 0);
	ASCM(playerid, "Ubili ste igraca %s.", GetName(id));
	ASCM(id, "Ubijeni ste od strane %s.", GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:report(playerid, params[])
{
    new text[128], string[128];
    if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/report [tekst]");
    format(string, sizeof(string), "[REPORT]{FFFFFF} Igrac %s je poslao report razlog %s", GetName(playerid), text);
	SendASCM(0xcccc00ff, string);
	return 1;
}
//---------------------------------------------------------
CMD:askq(playerid, params[])
{
    new text[128], string[128];
    if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/askq [tekst]");
    format(string, sizeof(string), "[ASKQ]{FFFFFF} Igrac %s je poslao report razlog %s", GetName(playerid), text);
	SendASCM(0xcccc00ff, string);
	return 1;
}
//---------------------------------------------------------
CMD:aduty(playerid, params[])
{
	if(ADuty[playerid] == false)
	{
	    ADuty[playerid] = true;
	    new string[128];
	    format(string, sizeof(string), "[ADMIN DUZNOST] Admin %s se prijavljuje na duznost mozete koristi /askq i /report.", GetName(playerid));
		SendClientMessageToAll(0xcccc00ff, string);
	}
	else if(ADuty[playerid] == true)
	{
	    ADuty[playerid] = false;
	    new string[128];
	    format(string, sizeof(string), "[ADMIN DUZNOST] Admin %s se odjavljuje sa duznosti, molimo vas budite strpljivi.", GetName(playerid));
		SendClientMessageToAll(0xcccc00ff, string);
	}
	return 1;
}
//---------------------------------------------------------
CMD:ao(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new text[128], string[128];
    if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/ao [tekst]");
    format(string, sizeof(string), "[A-OOC %s | %d] %s", GetName(playerid), PI[playerid][pAdmin],  text);
	SendClientMessageToAll(0xcccc00ff, string);
	return 1;
}
//---------------------------------------------------------
CMD:a(playerid, params[])
{
    if(PI[playerid][pAdmin] < 1) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new text[128], string[128];
    if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/a [tekst]");
    format(string, sizeof(string), "[A %s | %d]{FFFFFF} %s", GetName(playerid), PI[playerid][pAdmin],  text);
	SendASCM(0xcccc00ff, string);
	return 1;
}
//---------------------------------------------------------
CMD:gethere(playerid, params[])
{
    if(PI[playerid][pAdmin] < 2) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, Float:X, Float:Y, Float:Z;
    if(sscanf(params, "i", id)) return KORISTI(playerid, "/gethere [id]");
    GetPlayerPos(playerid, X,Y,Z);
    SetPlayerPos(id, X,Y,Z);
    ASCM(playerid, "Teleportovali ste igraca %s do vas.", GetName(id));
    ASCM(id, "Teleportovani ste od strane Admina %s do njega.", GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:gotopos(playerid, params[])
{
	if(PI[playerid][pAdmin] < 2) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new Float:X, Float:Y, Float:Z;
	if(sscanf(params, "fff", X, Y, Z)) return KORISTI(playerid, "/gotopos [x][y][z]");
	SetPlayerPos(playerid, X, Y, Z);
	ASCM(playerid, "Teleportovali ste se na unete kordinate.");
	return 1;
}
//---------------------------------------------------------
CMD:postavivreme(playerid, params[])
{
    if(PI[playerid][pAdmin] < 2) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new vreme, string[64];
	if(sscanf(params, "i", vreme)) return KORISTI(playerid, "/postavivreme [id 0-24]");
	if(vreme < 0 || vreme > 24) return GRESKA(playerid, "Vreme moze biti vece od 0 i manje od 24");
    format(string, sizeof(string), ""ZUTA"[ADMIN]: Admin %s je postavio vreme na %d.",GetName(playerid), vreme);
	SendClientMessageToAll(-1, string);
	SetWorldTime(vreme);
	return 1;
}
//---------------------------------------------------------
CMD:postaviarmor(playerid, params[])
{
    if(PI[playerid][pAdmin] < 3) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, armor;
	if(sscanf(params, "ii", id, armor)) return KORISTI(playerid, "/postaviarmor [id][iznos]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	if(armor < 0 || armor > 100) return GRESKA(playerid, "Armor ne mogu ici iznad 100.");
	SetPlayerArmour(playerid, armor);
	ASCM(playerid, "Postavili ste igracu %s armor na %d.", GetName(id), armor);
	ASCM(id, "Postavljen vamje armor na %d od strane %s.", armor, GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:postavihp(playerid, params[])
{
    if(PI[playerid][pAdmin] < 3) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, hp;
	if(sscanf(params, "ii", id, hp)) return KORISTI(playerid, "/postavihp [id][iznos]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	if(hp < 0 || hp > 100) return GRESKA(playerid, "Healthi ne mogu ici iznad 100.");
	SetPlayerHealth(playerid, hp);
	ASCM(playerid, "Postavili ste igracu %s helthe na %d.", GetName(id), hp);
	ASCM(id, "Postavljeni su vam helthi na %d od strane %s.", hp, GetName(playerid));
	return 1;
}
//---------------------------------------------------------
CMD:rac(playerid, params[])
{
    if(PI[playerid][pAdmin] < 3) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new string[64];
	for(new car = 1; car < MAX_VEHICLES; car++)
	{
	 	if(IsVehicleEmpty(car))
		{
			SetVehicleToRespawn(car);
		}
	}
	format(string, sizeof(string), ""ZUTA"[ADMIN]: Admin %s je uradio respawn svih slobodnih vozila.",GetName(playerid));
	SendClientMessageToAll(-1, string);
	return 1;
}
//---------------------------------------------------------
CMD:unwarn(playerid, params[])
{
    if(PI[playerid][pAdmin] < 3) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id;
	if(sscanf(params, "i", id)) return KORISTI(playerid, "/unwarn [id");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	if(PI[id][pWarn] == 0) return GRESKA(playerid, "Taj igrac nema warnove!");
	PI[id][pWarn] -= 1;
	ASCM(playerid, "Skinuli ste igracu %s warn.", GetName(id));
	ASCM(id, "Skinut vam je warn od strane %s.", GetName(playerid));
	return 1;
}
//----------------------------------------------------------
CMD:setskin(playerid, params[])
{
    if(PI[playerid][pAdmin] < 4) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, skin;
	if(sscanf(params, "ii", id, skin)) return KORISTI(playerid, "/setskin [id][skin]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	if(skin < 1 || skin > 311) return GRESKA(playerid, "Idevi skinova idu od 1 do 311");
	SetPlayerSkin(id, skin);
	PI[playerid][pSkin] = skin;
	ASCM(playerid, "Dali ste igracu %s skin id %d.", GetName(id), skin);
	ASCM(id, "Dodeljen vam je skin id %d od strane %s.", skin, GetName(playerid));
	return 1;
}
//----------------------------------------------------------
CMD:agun(playerid, params[])
{
    if(PI[playerid][pAdmin] < 5) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, gun, ammo;
	if(sscanf(params, "iii", id, gun, ammo)) return KORISTI(playerid, "/agun [id][gun][ammo]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	GivePlayerWeapon(id, gun, ammo);
	ASCM(playerid, "Dali ste igracu %s oruzije id %d, municije %d.", GetName(id), gun, ammo);
	ASCM(id, "Dodeljen vam je gun id %d, municije %d od strane %s.", gun, ammo, GetName(playerid));
	return 1;
}
//----------------------------------------------------------
CMD:dajnovac(playerid, params[])
{
    if(PI[playerid][pAdmin] < 6) return GRESKA(playerid, "Nemate dovoljan admin level.");
    new id, novac;
	if(sscanf(params, "ii", id, novac)) return KORISTI(playerid, "/dajnovac [id][novac]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	PI[id][pAdmin] += novac;
	ASCM(playerid, "Dali ste igracu %s novca %d.", GetName(id), novac);
	ASCM(id, "Dodeljeno vam je %d novca od strane %s.", novac, GetName(playerid));
	return 1;
}
//----------------------------------------------------------
CMD:posatviadmina(playerid, params[])
{
	if(PI[playerid][pAdmin] < 7) return GRESKA(playerid, "Nemate dovoljan admin level.");
	new id, level, string[64];
	if(sscanf(params, "ii", id, level)) return KORISTI(playerid, "/postaviadmina [id][level]");
	if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Igrac nije na serveru!");
	if(level > 0)
	{
		PI[id][pAdmin] = level;
		format(string, sizeof(string), ""ZUTA"[ADMIN]: Igracu %s je postavljen Admin Level %d od strane Vlasnika %s", GetName(id), level, GetName(playerid));
		SendClientMessageToAll(-1, string);
		ASCM(playerid, "Postavili ste igracu %s Admin Level %d.", GetName(id), level);
		ASCM(id, "Postavljen vam je Admin Level %d od strane %s.", level, GetName(playerid));
	}
	else if(level == 0)
	{
	    PI[id][pAdmin] = 0;
		format(string, sizeof(string), ""ZUTA"[ADMIN]: Igracu %s je skinut Admin Level %d od strane Vlasnika %s", GetName(id), level, GetName(playerid));
		SendClientMessageToAll(-1, string);
		ASCM(playerid, "Skinuli ste igracu %s Admin Level %d.", GetName(id), level);
		ASCM(id, "Skinut vam je Admin Level %d od strane %s.", level, GetName(playerid));
	}
	return 1;
}
//----------------------------------------------------------
