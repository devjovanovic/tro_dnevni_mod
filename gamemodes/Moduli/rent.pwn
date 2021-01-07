// Rent sistem kreiran od strane Jovanovica dana 30.12.2020.
#include <YSI\y_hooks>

//----------------------------------------------------------
#define MAX_RENT    150
#define RENT_FILE   "/Rent/%d.ini"
enum rInfo
{
	Float:PosX,
	Float:PosY,
	Float:PosZ,
}
new RentInfo[MAX_RENT][rInfo];
new Text3D:RentLabel[MAX_RENT];
new bool:RentaoVozilo[MAX_PLAYERS];
new bool:RentanoVozilo[MAX_VEHICLES];
new Rentano[MAX_PLAYERS];
new RentTimer[MAX_PLAYERS];
new RentIzbor[MAX_PLAYERS];
new RentCena[MAX_PLAYERS];
//----------------------------------------------------------
stock SledeciIDRenta()
{
	new file[80];
	for(new i = 0; i < MAX_RENT; i++)
	{
		format(file,sizeof(file),RENT_FILE,i);
		if(!fexist(file)) return i;
	}
	return 1;
}
//----------------------------------------------------------
function RentVreme(playerid, vehicleid)
{
    DestroyVehicle(Rentano[playerid]);
	DestroyDynamic3DTextLabel(RentLabel[Rentano[playerid]]);
	RentaoVozilo[playerid] = false;
    RentanoVozilo[Rentano[playerid]] = false;
    Rentano[playerid] = -1;
	SCM(playerid, -1, "Isteklo je vreme renta. Vozilo je vraceno.");
	return true;
}
//----------------------------------------------------------
function UcitajRent(id, name[], value[])
{
	INI_Float("Lokacija X", RentInfo[id][PosX]);
	INI_Float("Lokacija Y", RentInfo[id][PosY]);
	INI_Float("Lokacija Z", RentInfo[id][PosZ]);
	return 1;
}
//----------------------------------------------------------
stock SacuvajRent(id)
{
    new rFile[60];
    format(rFile, sizeof(rFile), RENT_FILE, id);
	new INI:File = INI_Open(rFile);
	INI_WriteFloat(File, "Pozicija X", RentInfo[id][PosX]);
	INI_WriteFloat(File, "Pozicija Y", RentInfo[id][PosY]);
	INI_WriteFloat(File, "Pozicija Z", RentInfo[id][PosZ]);
	INI_Close(File);
	return 1;
}
//----------------------------------------------------------
stock NajbliziRent(playerid) {
    for(new i = 1; i < sizeof(RentInfo); i++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 4.0, RentInfo[i][PosX], RentInfo[i][PosY], RentInfo[i][PosZ]))  return i;
	}
    return -1;
}
//----------------------------------------------------------
hook OnGameModeInit()
{
	for(new i = 1; i < MAX_RENT; i++)
	{
	    new rFile[50];
        format(rFile, sizeof(rFile), RENT_FILE, i);
        if(fexist(rFile))
		{
		    INI_ParseFile(rFile, "UcitajRent", .bExtra = true, .extra = i);
		    CreateDynamicPickup(1239, 1, RentInfo[i][PosX], RentInfo[i][PosY], RentInfo[i][PosZ]);
		    CreateDynamic3DTextLabel(""ZUTA"[ RENT ]\n da iznajmite vozilo kucajte /rent", -1, RentInfo[i][PosX], RentInfo[i][PosY], RentInfo[i][PosZ], 15.0, INVALID_PLAYER_ID);
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
	{
		if(Rentano[playerid] != GetPlayerVehicleID(playerid))
		{
		    RemovePlayerFromVehicle(playerid);
			GRESKA(playerid, "Ne mozete voziti tudje rent vozilo!");
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        //---
		case DIALOG_RENT:
		{
            if(!response) { SCM(playerid, -1, "Odustali ste od biranja rent vozila!"); }
	 		else if(response)
			{
			    switch(listitem)
				{
				    case 0:
				    {
				        RentIzbor[playerid] = 400;
				        RentCena[playerid] = 10;
				        SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT",""BELA"Upisite vreme renta. 1 minut = 10$","DALJE","IZLAZ");
				    }
				    case 1:
				    {
				        RentIzbor[playerid] = 560;
				        RentCena[playerid] = 50;
				        SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT",""BELA"Upisite vreme renta. 1 minut = 10$","DALJE","IZLAZ");
				    }
				    case 2:
				    {
				        RentIzbor[playerid] = 522;
				        RentCena[playerid] = 100;
				        SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT",""BELA"Upisite vreme renta. 1 minut = 10$","DALJE","IZLAZ");
				    }
				}
			}
		}
        //---
        case DIALOG_RENT2:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od biranja rent vozila!"); }
		    else if(response)
		    {
		        new vreme, id = NajbliziRent(playerid);
		        if(sscanf(inputtext, "d", vreme)) return SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT","Upisite vreme renta. 1 minut = 10$", "DALJE", "IZLAZ");
				if(vreme < 1 || vreme > 60) { SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT","Upisite vreme renta. 1 minut = 10$", "DALJE", "IZLAZ"); GRESKA(playerid, "Rent vreme ne moze biti manje od 1 ili vece od 60 !"); }
				if(vreme*RentCena[playerid] > GetPlayerMoney(playerid)) { SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_INPUT, "RENT","Upisite vreme renta. 1 minut = 10$", "DALJE", "IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca za to vreme."); }
		        RentaoVozilo[playerid] = true;
		        RentanoVozilo[GetPlayerVehicleID(playerid)] = true;
		        TogglePlayerControllable(playerid, 1);
		        Rentano[playerid] = CreateVehicle(RentIzbor[playerid], RentInfo[id][PosX], RentInfo[id][PosY], RentInfo[id][PosZ], 90, 3, 3, 3000);
		        RentLabel[playerid] = CreateDynamic3DTextLabel(""ZUTA"[ RENT VOZILO ]", -1, 0, 0, 0, 15.0, INVALID_PLAYER_ID, Rentano[playerid]);
		        NovacMinus(playerid, vreme*RentCena[playerid]);
		        SCM(playerid, -1, "Iznajmili ste vozilo.");
		        RentTimer[playerid] = SetTimerEx("RentVreme", vreme*60000, false, "i", playerid);
		        RentIzbor[playerid] = -1;
		        RentCena[playerid] = -1;
			}
		}
		//---
    }
	return 1;
}
//----------------------------------------------------------
CMD:nrent(playerid, params[])
{
	if(PI[playerid][pAdmin] < 7) return GRESKA(playerid, "Nemate dovoljan admin level!");
	new Float:X, Float:Y,Float:Z;
	new id = SledeciIDRenta();
	if(id >= MAX_RENT) return GRESKA(playerid, "Povecaj limit rent vozila!");
 	GetPlayerPos(playerid, X,Y,Z);
	RentInfo[id][PosX] = X;
	RentInfo[id][PosY] = Y;
	RentInfo[id][PosZ] = Z;
	CreateDynamicPickup(1239, 1, RentInfo[id][PosX], RentInfo[id][PosY], RentInfo[id][PosZ]);
 	CreateDynamic3DTextLabel(""ZUTA"[ RENT ]\n da iznajmite vozilo kucajte /rent", -1, RentInfo[id][PosX], RentInfo[id][PosY], RentInfo[id][PosZ], 15.0, INVALID_PLAYER_ID);
	SacuvajRent(id);
	ASCM(playerid, "Kreirali ste rent pickup.");
	return 1;
}
//----------------------------------------------------------
CMD:rent(playerid, params[])
{
 	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return GRESKA(playerid, "Niste na mestu vozaca.");
	if(Rentano[playerid] == GetPlayerVehicleID(playerid)) return GRESKA(playerid, "Niste u rent vozilu !");
	if(RentaoVozilo[playerid]) return SCM(playerid, -1, "Vec ste iznajmili vozilo.");
	if(RentanoVozilo[GetPlayerVehicleID(playerid)]) return SCM(playerid, -1, "To vozilo je vec rentano.");
	SPD(playerid, DIALOG_RENT2, DIALOG_STYLE_LIST, "RENT","Landstaker(10$-min)\nSultan(50$-min)\nNRG-500(100$-min)","DALJE","IZLAZ");
	TogglePlayerControllable(playerid, 0);
	return 1;
}
//----------------------------------------------------------
CMD:unrent(playerid, params[])
{
	if(!RentaoVozilo[playerid]) return GRESKA(playerid, "Niste iznajmili vozilo.");
	KillTimer(RentTimer[playerid]);
	DestroyVehicle(Rentano[playerid]);
	DestroyDynamic3DTextLabel(RentLabel[ Rentano[playerid] ]);
	RentaoVozilo[playerid] = false;
    RentanoVozilo[Rentano[playerid]] = false;
    Rentano[playerid] = -1;
	SCM(playerid, -1, "Vratili ste iznamljeno vozilo.");
	return 1;
}
//----------------------------------------------------------
