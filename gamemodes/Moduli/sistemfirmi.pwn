// Sistem firmi kreiran od strane Jovanovic 31.12.2020.
#include <YSI\y_hooks>

//----------------------------------------------------------
#define FIRME_FILE    "Firme/%d.ini"
#define MAX_FIRMI 100
enum fInfo
{
	Vlasnik,
	ImeVlasnika[45],
	Vrsta,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:EntPosX,
	Float:EntPosY,
	Float:EntPosZ,
	Level,
	Cena,
	Novac,
	Int,
	Zakljucano,
	VW,
};
new FI[MAX_FIRMI][fInfo];
new FirmaPickup[sizeof(FI)];
new Text3D:FirmaLabel[sizeof(FI)];
new FirmaID[MAX_PLAYERS];
//----------------------------------------------------------
stock SledeciIDFirme()
{
	new file[80];
	for(new i = 0; i < MAX_FIRMI; i++)
	{
		format(file,sizeof(file),FIRME_FILE,i);
		if(!fexist(file)) return i;
	}
	return 1;
}
//----------------------------------------------------------
forward UcitajFirme(id, name[], value[]);
public UcitajFirme(id, name[], value[])
{
	INI_Int("ProveraVlasnika",FI[id][Vlasnik]);
	INI_String("Vlasnik",FI[id][ImeVlasnika],45);
	INI_Int("Vrsta",FI[id][Vrsta]);
    INI_Float("UlazX",FI[id][PosX]);
    INI_Float("UlazY",FI[id][PosY]);
    INI_Float("UlazZ",FI[id][PosZ]);
    INI_Float("IzlazX",FI[id][EntPosX]);
    INI_Float("IzlazY",FI[id][EntPosY]);
    INI_Float("IzlazZ",FI[id][EntPosZ]);
    INI_Int("Level",FI[id][Level]);
    INI_Int("Cena",FI[id][Cena]);
    INI_Int("Novac",FI[id][Novac]);
    INI_Int("Interior",FI[id][Int]);
    INI_Int("Zatvoreno",FI[id][Zakljucano]);
    INI_Int("VW",FI[id][VW]);
	return 1;
}
//----------------------------------------------------------
stock SacuvajFirmu(id)
{
	new file[128];
    format(file, sizeof(file), FIRME_FILE, id);
	new INI:File = INI_Open(file);
	INI_WriteInt(File,"ProveraVlasnika",FI[id][Vlasnik]);
	INI_WriteString(File,"Vlasnik",FI[id][ImeVlasnika]);
	INI_WriteInt(File,"Vrsta",FI[id][Vrsta]);
	INI_WriteFloat(File,"UlazX",FI[id][PosX]);
	INI_WriteFloat(File,"UlazY",FI[id][PosY]);
	INI_WriteFloat(File,"UlazZ",FI[id][PosZ]);
	INI_WriteFloat(File,"IzlazX",FI[id][EntPosX]);
	INI_WriteFloat(File,"IzlazY",FI[id][EntPosY]);
	INI_WriteFloat(File,"IzlazZ",FI[id][EntPosZ]);
	INI_WriteInt(File,"Level",FI[id][Level]);
    INI_WriteInt(File,"Cena",FI[id][Cena]);
    INI_WriteInt(File,"Novac",FI[id][Novac]);
    INI_WriteInt(File,"Interior",FI[id][Int]);
    INI_WriteInt(File,"Zatvoreno",FI[id][Zakljucano]);
    INI_WriteInt(File,"VW",FI[id][VW]);
	INI_Close(File);
	return 1;
}
//----------------------------------------------------------
stock RefreshFirme(id)
{
	new string[400], vrsta[16];
 	if(FI[id][Vrsta] == 1) vrsta = "Market";
	else if(FI[id][Vrsta] == 2) vrsta = "Gunshop";
	if(FI[id][Vlasnik] == 0)
	{
		DestroyDynamic3DTextLabel(FirmaLabel[id]);
		DestroyDynamicPickup(FirmaPickup[id]);
        format(string,sizeof(string),"Firma na Prodaju (ID: %d)\nVrsta: %s\nCena: %d\nLevel: %d\nZa kupovinu /kupifirmu", id, vrsta, FI[id][Cena], FI[id][Level]);
        FirmaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,FI[id][PosX],FI[id][PosY],FI[id][PosZ],25,0,1);
        FirmaPickup[id] = CreateDynamicPickup(1273, 1, FI[id][PosX], FI[id][PosY], FI[id][PosZ]);
	}
	else if(FI[id][Vlasnik] == 1)
	{
		DestroyDynamic3DTextLabel(FirmaLabel[id]);
		DestroyDynamicPickup(FirmaPickup[id]);
		format(string,sizeof(string),"Vlasnik: %s (ID: %d)\nVrsta: %s\nCena: %d\nLevel: %d\nZa kupovinu /kupifirmu", FI[id][ImeVlasnika], id, vrsta, FI[id][Cena], FI[id][Level]);
        FirmaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,FI[id][PosX],FI[id][PosY],FI[id][PosZ],25,0,1);
        FirmaPickup[id] = CreateDynamicPickup(1239, 1, FI[id][PosX], FI[id][PosY], FI[id][PosZ]);
	}
	return 1;
}
//----------------------------------------------------------
CMD:kupi(playerid, params[])
{
	new id;
	if(FirmaID[playerid] == -1) return GRESKA(playerid, "Morate biti u firmi.");
	if(FI[FirmaID[playerid]][Vrsta] == 1) {
		if(sscanf(params, "i", id)) return KORISTI(playerid, "/kupi [1-telefon]");
		if(id == 1)
		{
		    if(PI[playerid][pNovac] < 100) return GRESKA(playerid, "Nemate 100$.");
		    if(PI[playerid][pMobilni] == 1) return GRESKA(playerid, "Vec imate mobilni.");
			NovacMinus(playerid, 100);
		    PI[playerid][pMobilni] = 1;
		    SCM(playerid, -1, "Kupili ste telefon za 100$");
		}
	}
	else if(FI[FirmaID[playerid]][Vrsta] == 2) {
		if(sscanf(params, "i", id)) return KORISTI(playerid, "/kupi [1-deagle, 2-m4, 3-pancir]");
		if(id == 1)
		{
		    if(PI[playerid][pNovac] < 100) return GRESKA(playerid, "Nemate 100$.");
			NovacMinus(playerid, 100);
			GivePlayerWeapon(playerid, 24, 50);
		    SCM(playerid, -1, "Kupili ste deagle od 50 metkova za 100$");
		}
		else if(id == 2)
		{
		    if(PI[playerid][pNovac] < 200) return GRESKA(playerid, "Nemate 200$.");
			NovacMinus(playerid, 200);
			GivePlayerWeapon(playerid, 31, 100);
		    SCM(playerid, -1, "Kupili ste m4 od 50 metkova za 200$");
		}
		else if(id == 3)
		{
		    if(PI[playerid][pNovac] < 500) return GRESKA(playerid, "Nemate 500$.");
			NovacMinus(playerid, 500);
			SetPlayerArmour(playerid, 100);
		    SCM(playerid, -1, "Kupili ste pancir za 500$");
		}
	}
	return 1;
}
//----------------------------------------------------------
CMD:firma(playerid, params[])
{
    new string[256];
	if(PI[playerid][pFirma] == -1) return GRESKA(playerid, "Morate posedovati firmuu.");
	if(strcmp(FI[PI[playerid][pFirma]][ImeVlasnika], GetName(playerid), true)) return GRESKA(playerid, "Morate biti vlasnik ove firmee.");
    format(string,sizeof(string),"Informacije\nOtkljucaj/Zakljucaj\nProdaj firmuu\nLociraj\nUzmi novac\nOstavi novac");
    SPD(playerid, DIALOG_FIRMA, DIALOG_STYLE_LIST, "FIRMA", string, "DALJE", "IZLAZ");
	return 1;
}
//----------------------------------------------------------
CMD:kupifirmuu(playerid, params[])
{
    for(new i; i < sizeof(FI); i++)
	{
    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, FI[i][PosX], FI[i][PosY], FI[i][PosZ])) return GRESKA(playerid, "Niste pored firme.");
   		if(strcmp(FI[i][ImeVlasnika], "Niko", true) && FI[i][Vlasnik] == 0) return GRESKA(playerid, "Ova firma nije na prodaju.");
		if(PI[playerid][pFirma] != -1) return GRESKA(playerid, "Vi vec posedujete firmu.");
		if(PI[playerid][pLevel] < FI[i][Level]) return GRESKA(playerid, "Morate biti %d level za kupovinu ove firme.", FI[i][Level]);
		if(PI[playerid][pNovac] < FI[i][Cena]) return GRESKA(playerid, "Morate imati kod sebe %d$ za kupovinu ove firme.", FI[i][Cena]);
		strmid(FI[i][ImeVlasnika], GetName(playerid), 0, strlen(GetName(playerid)), 255);
		FI[i][Vlasnik] = 1;
		PI[playerid][pFirma] = i;
		FI[i][Zakljucano] = 0;
		NovacMinus(playerid, FI[i][Cena]);
		RefreshFirme(i);
		SacuvajFirmu(i);
		SACC(playerid);
		SCM(playerid,-1, "Uspesno ste kupili firmu, za kontrolu nad firmom koristite /firma.");
		return 1;
	}
    return 1;
}
//----------------------------------------------------------
CMD:nfirmu(playerid, params[],help)
{
	if(PI[playerid][pAdmin] < 7) return GRESKA(playerid, "Nemas ovlascenje za ovu komandu!");
	new Float:X, Float:Y, Float:Z, string[400], vrsta[16], vrstaid;
	if(sscanf(params, "i", vrstaid)) return KORISTI(playerid, "/nfirmu [1-market, 2-gunshop]");
	GetPlayerPos(playerid,X,Y,Z);
	new id = SledeciIDFirme();
	if(id >= MAX_FIRMI) return GRESKA(playerid, "Povecaj limit firmi!");
	FI[id][Cena] = 50000;
	FI[id][Level] = 3;
	FI[id][PosX] = X;
    FI[id][PosY] = Y;
	FI[id][PosZ] = Z;
	FI[id][Vlasnik] = 0;
	FI[id][Zakljucano] = 1;
	FI[id][VW] = id;
	SacuvajFirmu(id);
	if(FI[vrstaid][Vrsta] == 1)
	{
 		vrsta = "Market";
 		FI[id][EntPosX] = -30.946699;//cord marketa
		FI[id][EntPosY] = -89.609596;
		FI[id][EntPosZ] = 1003.546875;
		FI[id][Int] = 18;
		FI[id][Vrsta] = 1;
	}
	else if(FI[vrstaid][Vrsta] == 2)
	{
 		vrsta = "Gunshop";
 		FI[id][EntPosX] = 286.800994;//cord gunshopa
		FI[id][EntPosY] = -82.547599;
		FI[id][EntPosZ] = 1001.515625;
		FI[id][Int] = 4;
		FI[id][Vrsta] = 2;
	}
    strmid(FI[id][ImeVlasnika],"Niko",0,strlen("Niko"),255);
    format(string,sizeof(string),"Firma na Prodaju (ID: %d)\nVrsta: %s\nCena: %d\nLevel: %d\nZa kupovinu /kupifirmu", id, vrsta, FI[id][Cena], FI[id][Level]);
    FirmaLabel[id] = CreateDynamic3DTextLabel(string ,-1,X,Y,Z,25,0,1);
    FirmaPickup[id] = CreateDynamicPickup(1273, 1, FI[id][PosX], FI[id][PosY], FI[id][PosZ]);
	ASCM(playerid, "Kreirao si firmu.");
	return 1;
}
//----------------------------------------------------------
hook OnGameModeInit()
{
    for(new id = 0; id < sizeof(FI); id++)
    {
        new file[50], string[400];
        format(file, sizeof(file), FIRME_FILE, id);
        if(fexist(file))
        {
            new vrsta[16];
            if(FI[id][Vrsta] == 1) vrsta = "Market";
 			else if(FI[id][Vrsta] == 2) vrsta = "Gunshop";
            INI_ParseFile(file, "UcitajFirme", .bExtra = true, .extra = id);
            if(FI[id][Vlasnik] == 0)
	        {
        	    format(string,sizeof(string),"Firma na Prodaju (ID: %d)\nVrsta: %s\nCena: %d\nLevel: %d\nZa kupovinu /kupifirmu", id, vrsta, FI[id][Cena], FI[id][Level]);
        	    FirmaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,FI[id][PosX],FI[id][PosY],FI[id][PosZ],25,0,1);
        	    FirmaPickup[id] = CreateDynamicPickup(1273, 1, FI[id][PosX], FI[id][PosY], FI[id][PosZ]);
        	}
        	else if(FI[id][Vlasnik] == 1)
        	{
				format(string,sizeof(string),"Vlasnik: %s (ID: %d)\nVrsta: %s\nCena: %d\nLevel: %d\nZa kupovinu /kupifirmu", FI[id][ImeVlasnika], id, vrsta, FI[id][Cena], FI[id][Level]);
        	    FirmaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,FI[id][PosX],FI[id][PosY],FI[id][PosZ],25,0,1);
        	    FirmaPickup[id] = CreateDynamicPickup(1239, 1, FI[id][PosX], FI[id][PosY], FI[id][PosZ]);
        	}
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnGameModeExit()
{
    for(new id = 0; id <= MAX_FIRMI; id++)
	{
		SacuvajFirmu(id);
	}
	return 1;
}
//----------------------------------------------------------
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SECONDARY_ATTACK)
	{
		for(new i; i < MAX_FIRMI; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, FI[i][PosX], FI[i][PosY], FI[i][PosZ]))
			{
    			if(PI[playerid][pFirma] == i || FI[i][Zakljucano] == 0)
    		   	{
					FirmaID[playerid] = i;
    		   	    SetPlayerInterior(playerid, FI[i][Int]);
                    SetPlayerVirtualWorld(playerid, FI[i][VW]);
                 	SetPlayerPos(playerid, FI[i][EntPosX], FI[i][EntPosY], FI[i][EntPosZ]);
                 	SCM(playerid, -1, "Za kupovinu koristite /kupi.");
                }
                else return GRESKA(playerid, "Ova firma je zakljucana.");
			}
            if(IsPlayerInRangeOfPoint(playerid, 2.0, FI[i][EntPosX], FI[i][EntPosY], FI[i][EntPosZ]) && GetPlayerVirtualWorld(playerid) == FI[i][VW])
	        {
	            FirmaID[playerid] = -1;
             	SetPlayerInterior(playerid, FI[i][Int]);
             	SetPlayerVirtualWorld(playerid, FI[i][VW]);
             	SetPlayerPos(playerid, FI[i][PosX], FI[i][PosY], FI[i][PosZ]);
             	return 1;
            }
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
		case DIALOG_FIRMA:
		{
			if(!response) return 1;
			if(PI[playerid][pFirma] == -1) return GRESKA(playerid, "Morate posedovati firmu.");
			new i = PI[playerid][pFirma];
			switch(listitem)
			{
				case 0:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, FI[i][EntPosX], FI[i][EntPosY], FI[i][EntPosZ])) return GRESKA(playerid, "Morate biti u vasoj firmi.");
					new lock[16], vrsta[16];
				    if(FI[i][Zakljucano] == 1) lock = "Zakljucano";
	      			else lock = "Otkljucano";
	      			if(FI[i][Vrsta] == 1) vrsta = "Market";
	      			else if(FI[i][Vrsta] == 2) vrsta = "Gunshop";
					SCMF(playerid, -1, " ID: %d | Vlasnik: %s | Vrsta: %s | Level: %d | Zakljucano: %s | Cena: %d | Novac u kasi: %d", i, FI[i][ImeVlasnika], vrsta, FI[i][Level], lock, FI[i][Cena], FI[i][Novac]);
				}
				case 1:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, FI[i][EntPosX], FI[i][EntPosY], FI[i][EntPosZ])) return GRESKA(playerid, "Morate biti u vasoj firmi.");
				    if(FI[i][Zakljucano] == 0)
				    {
						FI[i][Zakljucano] = 0;
						SacuvajFirmu(i);
						SCM(playerid, -1, "Uspesno ste otkljucali vasu firmu.");
					}
					else if(FI[i][Zakljucano] == 1)
					{
					    FI[i][Zakljucano] = 1;
						SacuvajFirmu(i);
					    SCM(playerid, -1, "Uspesno ste zakljucali vasu firmuu.");
				    }
				}
				case 3:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, FI[i][PosX], FI[i][PosY], FI[i][PosZ])) return GRESKA(playerid, "Morate biti ispred vase firme.");
					NovacPlus(playerid, FI[i][Cena]);
					FI[i][Vlasnik] = 0;
					FI[i][Zakljucano] = 1;
					strmid(FI[i][ImeVlasnika], "Niko", 0, strlen("Niko"), 255);
					PI[playerid][pFirma] = -1;
					SacuvajFirmu(i);
					RefreshFirme(i);
					SACC(playerid);
					SCMF(playerid, -1, "Uspesno ste prodali firmu za %d$.", FI[i][Cena]);
				}
				case 4:
				{
				    if(GPSUpaljen[playerid] == 0)
				    {
						SetPlayerCheckpoint(playerid,FI[i][PosX],FI[i][PosY],FI[i][PosZ], 3.0);
						GPSUpaljen[playerid] = 1;
						SCM(playerid, -1, "Locirali ste firmu, crvena kocka na mapi.");
					}
					else if(GPSUpaljen[playerid] == 1)
					{
					    GPSUpaljen[playerid] = 0;
						SCM(playerid, -1, "Prekinuli ste lociranje vase firme.");
						DisablePlayerCheckpoint(playerid);
					}
				}
				case 5:
				{
				    SPD(playerid, DIALOG_FIRMA2, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da podignete.", "DALJE", "IZLAZ");
				}
				case 6:
				{
				    SPD(playerid, DIALOG_FIRMA3, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da ostavite.", "DALJE", "IZLAZ");
				}
			}
		}
		case DIALOG_FIRMA2:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od uzimanja novca iz firme!"); }
		    else if(response)
		    {
      			new novac;
		        if(sscanf(inputtext, "d", novac)) return SPD(playerid, DIALOG_FIRMA2, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da podignete.", "DALJE", "IZLAZ");
				if(novac > FI[FirmaID[playerid]][Novac]) { SPD(playerid, DIALOG_FIRMA2, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da podignete.", "DALJE", "IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca u firmi."); }
                if(novac < 0 || novac > 10000) { SPD(playerid, DIALOG_FIRMA2, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da podignete.", "DALJE", "IZLAZ"); GRESKA(playerid, "Najvise mozete od jednom uzeti 10000$."); }
				NovacPlus(playerid, novac);
		        FI[FirmaID[playerid]][Novac] -= novac;
		        SCMF(playerid, -1, "Uspesno ste uzeli %d iz vase firme.", novac);
			}
		}
		case DIALOG_FIRMA3:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od ostavljanja novca iz firme!"); }
		    else if(response)
		    {
      			new novac;
		        if(sscanf(inputtext, "d", novac)) return SPD(playerid, DIALOG_FIRMA3, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da ostavite.", "DALJE", "IZLAZ");
				if(novac < FI[FirmaID[playerid]][Novac]) { SPD(playerid, DIALOG_FIRMA3, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da ostavite.", "DALJE", "IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca kod sebe."); }
				if(novac < 0 || novac > 10000) { SPD(playerid, DIALOG_FIRMA3, DIALOG_STYLE_INPUT, "FIRMA","Upisite kolicinu novca koju zelite da ostavite.", "DALJE", "IZLAZ"); GRESKA(playerid, "Najvise mozete od jednom ostaviti 10000$."); }
				NovacMinus(playerid, novac);
		        FI[FirmaID[playerid]][Novac] += novac;
		        SCMF(playerid, -1, "Uspesno ste ostavili %d u vasu firmu.", novac);
			}
		}
	}
	return 1;
}
//----------------------------------------------------------
