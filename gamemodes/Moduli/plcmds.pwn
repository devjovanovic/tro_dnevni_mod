// Player commands kreirano od strane Jovanovica 31.12.2020.
#include <YSI\y_hooks>

function SetSpawn(playerid)
{
	if(PI[playerid][pSpawn] == 1)
	{
	    SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1481.0356,-1772.1704,18.7958);
	}
	else if(PI[playerid][pSpawn] == 2 && PI[playerid][pKuca] != -1)
	{
        new i = PI[playerid][pKuca];
        SetPlayerInterior(playerid, KI[i][VW]);
		SetPlayerVirtualWorld(playerid, KI[i][Int]);
		SetPlayerPos(playerid, KI[i][PosX], KI[i][PosY], KI[i][PosZ]);
	}
	/*else if(PI[playerid][pSpawn] == 3 && PlayerInfo[playerid][pClan] != -1)
	{
	}*/
	return 1;
}
hook OnPlayerSpawn(playerid)
{
	return 1;
}
CMD:spawnchange(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return KORISTI(playerid, "/spawnchange [1-opstina, 2-kuca, 3-organizacija]");
	if(id == 1)
	{
	    PI[playerid][pSpawn] = 1;
	    SCM(playerid, -1, "Postavili ste spawn na Opstinu.");
	}
	else if(id == 2)
	{
	    PI[playerid][pSpawn] = 2;
	    SCM(playerid, -1, "Postavili ste spawn na Kucu.");
	}
	else if(id == 3)
	{
	    PI[playerid][pSpawn] = 3;
	    SCM(playerid, -1, "Postavili ste spawn na Organizacijsku bazu.");
	}
	return 1;
}
